using Ecommerce_Jogos.Data;
using Ecommerce_Jogos.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Ecommerce_Jogos.Controllers
{
    public class AnaliseController : Controller
    {
        private readonly ApplicationDbContext _context;

        public AnaliseController(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var viewModel = new AnaliseVendasViewModel
            {
                Produtos = await _context.Produtos
                                .AsNoTracking()
                                .OrderBy(p => p.Nome)
                                .Select(p => new Microsoft.AspNetCore.Mvc.Rendering.SelectListItem
                                {
                                    Value = p.ID.ToString(),
                                    Text = $"{p.Nome} ({p.Plataforma.Nome})"
                                }).ToListAsync(),

                Categorias = await _context.Categorias
                                .AsNoTracking()
                                .OrderBy(c => c.Nome)
                                .Select(c => new Microsoft.AspNetCore.Mvc.Rendering.SelectListItem
                                {
                                    Value = c.ID.ToString(),
                                    Text = c.Nome
                                }).ToListAsync()
            };

            return View(viewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ObterDadosAnalise([FromBody] FiltroAnaliseViewModel filtro)
        {
            // A primeira parte (a consulta de vendas) continua a mesma
            if (filtro.Ids == null || !filtro.Ids.Any())
            {
                return BadRequest("Nenhum item selecionado para comparação.");
            }
            var dataFimAjustada = filtro.DataFim.AddDays(1);
            var itensVendidosQuery = _context.ItensPedido
                .AsNoTracking()
                .Where(ip => ip.Pedido.DataPedido >= filtro.DataInicio && ip.Pedido.DataPedido < dataFimAjustada);

            var vendasAgrupadas = new List<VendaAgrupadaDia>();
            if (filtro.TipoComparacao == "produto")
            {
                itensVendidosQuery = itensVendidosQuery.Where(ip => filtro.Ids.Contains(ip.ProdutoID));
                vendasAgrupadas = await itensVendidosQuery
                    .GroupBy(ip => new { Data = ip.Pedido.DataPedido.Date, ip.ProdutoID, ip.Produto.Nome })
                    .Select(g => new VendaAgrupadaDia { Data = g.Key.Data, IdItem = g.Key.ProdutoID, NomeItem = g.Key.Nome, Quantidade = g.Sum(ip => ip.Quantidade) })
                    .ToListAsync();
            }
            else // categoria
            {
                var produtosPorCategoria = _context.ProdutoCategorias.Where(pc => filtro.Ids.Contains(pc.CategoriaID)).Select(pc => pc.ProdutoID);
                itensVendidosQuery = itensVendidosQuery.Where(ip => produtosPorCategoria.Contains(ip.ProdutoID));
                var vendasPorProduto = await itensVendidosQuery.Select(ip => new { Data = ip.Pedido.DataPedido.Date, ip.Quantidade, CategoriasDoProduto = ip.Produto.Categorias.Select(c => c.ID).ToList() }).ToListAsync();
                var categoriasLookup = await _context.Categorias.Where(c => filtro.Ids.Contains(c.ID)).ToDictionaryAsync(c => c.ID, c => c.Nome);
                vendasAgrupadas = vendasPorProduto.SelectMany(v => v.CategoriasDoProduto.Where(catId => filtro.Ids.Contains(catId)).Select(catId => new { v.Data, CategoriaId = catId, v.Quantidade })).GroupBy(x => new { x.Data, x.CategoriaId }).Select(g => new VendaAgrupadaDia { Data = g.Key.Data, IdItem = g.Key.CategoriaId, NomeItem = categoriasLookup.ContainsKey(g.Key.CategoriaId) ? categoriasLookup[g.Key.CategoriaId] : "Categoria Desconhecida", Quantidade = g.Sum(x => x.Quantidade) }).ToList();
            }

            // --- Montagem da resposta para o Chart.js ---

            // 1. Criar todos os labels de data para o período completo
            var labels = new List<string>();
            for (var dt = filtro.DataInicio.Date; dt <= filtro.DataFim.Date; dt = dt.AddDays(1))
            {
                labels.Add(dt.ToString("dd/MM"));
            }

            // --- ALTERAÇÃO AQUI: Buscando todos os nomes antecipadamente ---
            var nomesLookup = new Dictionary<int, string>();
            if (filtro.TipoComparacao == "produto")
            {
                nomesLookup = await _context.Produtos
                    .Where(p => filtro.Ids.Contains(p.ID))
                    .ToDictionaryAsync(p => p.ID, p => p.Nome);
            }
            else
            {
                nomesLookup = await _context.Categorias
                    .Where(c => filtro.Ids.Contains(c.ID))
                    .ToDictionaryAsync(c => c.ID, c => c.Nome);
            }

            var datasets = new List<object>();
            var cores = new[] { "rgba(75, 192, 192, 1)", "rgba(255, 99, 132, 1)", "rgba(54, 162, 235, 1)", "rgba(255, 206, 86, 1)", "rgba(153, 102, 255, 1)" };
            var corIndex = 0;

            // 2. Para cada ID de item selecionado, criar um dataset
            foreach (var id in filtro.Ids)
            {
                var itemData = vendasAgrupadas.Where(v => v.IdItem == id).ToDictionary(v => v.Data, v => v.Quantidade);

                // --- ALTERAÇÃO AQUI: Usando o dicionário de nomes ---
                var nomeItem = nomesLookup.ContainsKey(id) ? nomesLookup[id] : $"Item Desconhecido {id}";

                var dataPoints = new List<int>();
                // 3. Preencher os dados de venda para cada dia do período
                for (var dt = filtro.DataInicio.Date; dt <= filtro.DataFim.Date; dt = dt.AddDays(1))
                {
                    dataPoints.Add(itemData.ContainsKey(dt) ? itemData[dt] : 0);
                }

                datasets.Add(new
                {
                    label = nomeItem,
                    data = dataPoints,
                    borderColor = cores[corIndex % cores.Length],
                    backgroundColor = cores[corIndex % cores.Length],
                    fill = false,
                    tension = 0.1
                });
                corIndex++;
            }

            return Ok(new { labels, datasets });
        }

        public IActionResult Details(int id)
        {
            return View();
        }

        private class VendaAgrupadaDia
        {
            public DateTime Data { get; set; }
            public int IdItem { get; set; }
            public string NomeItem { get; set; }
            public int Quantidade { get; set; }
        }

        public class FiltroAnaliseViewModel
        {
            public DateTime DataInicio { get; set; }
            public DateTime DataFim { get; set; }
            public string TipoComparacao { get; set; }
            public List<int> Ids { get; set; }
        }
    }
}
