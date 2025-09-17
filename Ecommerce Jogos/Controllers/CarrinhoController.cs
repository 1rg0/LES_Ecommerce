using Ecommerce_Jogos.Data;
using Ecommerce_Jogos.Helpers;
using Ecommerce_Jogos.Models;
using Ecommerce_Jogos.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace Ecommerce_Jogos.Controllers
{
    public class CarrinhoController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly EstoqueService _estoqueService;

        public CarrinhoController(ApplicationDbContext context, EstoqueService estoqueService)
        {
            _context = context;
            _estoqueService = estoqueService;
        }

        public async Task<IActionResult> Index()
        {
            var carrinho = SessionHelper.GetObjectFromJson<CarrinhoViewModel>(HttpContext.Session, "Carrinho") ?? new CarrinhoViewModel();

            if (carrinho.Itens.Any())
            {
                var mensagensNotificacao = new List<string>();
                var itensParaRemover = new List<CarrinhoItemViewModel>();

                foreach (var item in carrinho.Itens)
                {
                    var estoqueDisponivel = await _estoqueService.GetEstoqueDisponivel(item.ProdutoId);

                    if (estoqueDisponivel == 0)
                    {
                        mensagensNotificacao.Add($"O produto '{item.NomeProduto}' não está mais disponível em estoque e foi removido do seu carrinho.");
                        itensParaRemover.Add(item);
                    }
                    else if (item.Quantidade > estoqueDisponivel)
                    {
                        mensagensNotificacao.Add($"A quantidade do produto '{item.NomeProduto}' foi ajustada para {estoqueDisponivel} unidade(s) devido à disponibilidade em estoque.");
                        item.Quantidade = estoqueDisponivel;
                    }
                }

                if (itensParaRemover.Any())
                {
                    var idsParaRemover = itensParaRemover.Select(i => i.ProdutoId).ToList();
                    var (clienteId, sessaoId) = GetUserAndSessionIds();

                    var bloqueiosParaRemover = await _context.EstoquesBloqueados
                        .Where(b => ((clienteId.HasValue && b.ClienteID == clienteId) || b.SessaoId == sessaoId) && idsParaRemover.Contains(b.ProdutoID))
                        .ToListAsync();

                    if (bloqueiosParaRemover.Any())
                    {
                        _context.EstoquesBloqueados.RemoveRange(bloqueiosParaRemover);
                        await _context.SaveChangesAsync();
                    }
                }

                foreach (var item in itensParaRemover)
                {
                    carrinho.Itens.Remove(item);
                }

                if (mensagensNotificacao.Any())
                {
                    TempData["CarrinhoNotificacoes"] = mensagensNotificacao;
                    SessionHelper.SetObjectAsJson(HttpContext.Session, "Carrinho", carrinho);
                }
            }

            return View(carrinho);
        }

        [HttpPost]
        public async Task<IActionResult> Adicionar(int produtoId, int quantidade)
        {
            var produto = await _context.Produtos.FindAsync(produtoId);
            if (produto == null)
            {
                return NotFound("Produto não encontrado.");
            }

            var estoqueDisponivel = await _estoqueService.GetEstoqueDisponivel(produtoId);
            if (quantidade > estoqueDisponivel)
            {
                return BadRequest($"Estoque insuficiente. Apenas {estoqueDisponivel} unidades disponíveis.");
            }

            var (clienteId, sessaoId) = GetUserAndSessionIds();
            var bloqueioCriado = await _estoqueService.CriarBloqueio(produtoId, quantidade, clienteId, sessaoId);

            if (!bloqueioCriado)
            {
                return BadRequest("Não foi possível reservar o item no estoque. Tente novamente.");
            }

            var carrinho = SessionHelper.GetObjectFromJson<CarrinhoViewModel>(HttpContext.Session, "Carrinho") ?? new CarrinhoViewModel();
            var itemNoCarrinho = carrinho.Itens.FirstOrDefault(i => i.ProdutoId == produtoId);

            if (itemNoCarrinho == null)
            {
                carrinho.Itens.Add(new CarrinhoItemViewModel
                {
                    ProdutoId = produto.ID,
                    NomeProduto = produto.Nome,
                    Quantidade = quantidade,
                    PrecoUnitario = produto.PrecoVenda,
                    UrlImagem = produto.URLImagem
                });
            }
            else
            {
                itemNoCarrinho.Quantidade += quantidade;
            }

            SessionHelper.SetObjectAsJson(HttpContext.Session, "Carrinho", carrinho);

            return Ok(new { sucesso = true, mensagem = "Produto adicionado ao carrinho!" });
        }

        [HttpPost]
        public async Task<IActionResult> Remover(int produtoId)
        {
            var carrinho = SessionHelper.GetObjectFromJson<CarrinhoViewModel>(HttpContext.Session, "Carrinho");
            if (carrinho != null)
            {
                var itemParaRemover = carrinho.Itens.FirstOrDefault(i => i.ProdutoId == produtoId);
                if (itemParaRemover != null)
                {
                    var (clienteId, sessaoId) = GetUserAndSessionIds();
                    await _estoqueService.LiberarBloqueios(clienteId, sessaoId);

                    carrinho.Itens.Remove(itemParaRemover);
                    SessionHelper.SetObjectAsJson(HttpContext.Session, "Carrinho", carrinho);
                }
                return Ok(new { sucesso = true, novoTotal = carrinho.Total.ToString("C") });
            }
            return BadRequest("Carrinho não encontrado.");
        }

        [HttpPost]
        public async Task<IActionResult> AtualizarQuantidade(int produtoId, int novaQuantidade)
        {
            if (novaQuantidade <= 0)
            {
                return await Remover(produtoId);
            }

            var (clienteId, sessaoId) = GetUserAndSessionIds();
            var carrinho = SessionHelper.GetObjectFromJson<CarrinhoViewModel>(HttpContext.Session, "Carrinho");

            if (carrinho == null)
            {
                return BadRequest("Carrinho não encontrado.");
            }

            var itemParaAtualizar = carrinho.Itens.FirstOrDefault(i => i.ProdutoId == produtoId);
            if (itemParaAtualizar == null)
            {
                return NotFound("Item não encontrado no carrinho.");
            }

            // --- LÓGICA DE VALIDAÇÃO CORRIGIDA ---
            // 1. Libera temporariamente o bloqueio do item que está sendo alterado para obter o estoque total real.
            var bloqueioExistente = await _context.EstoquesBloqueados
                .FirstOrDefaultAsync(b => ((clienteId.HasValue && b.ClienteID == clienteId) || b.SessaoId == sessaoId) && b.ProdutoID == produtoId);

            if (bloqueioExistente != null)
            {
                _context.EstoquesBloqueados.Remove(bloqueioExistente);
                await _context.SaveChangesAsync();
            }

            // 2. Agora, verifica o estoque disponível REAL
            var estoqueDisponivel = await _estoqueService.GetEstoqueDisponivel(produtoId);
            if (novaQuantidade > estoqueDisponivel)
            {
                // Se o estoque não for suficiente, recria o bloqueio com a quantidade antiga e retorna o erro.
                if (bloqueioExistente != null)
                {
                    _context.EstoquesBloqueados.Add(bloqueioExistente); // Readiciona o bloqueio original
                    await _context.SaveChangesAsync();
                }
                return BadRequest($"Estoque insuficiente. Apenas {estoqueDisponivel} unidades disponíveis.");
            }

            // 3. Se o estoque for suficiente, atualiza o item no carrinho e cria o novo bloqueio.
            itemParaAtualizar.Quantidade = novaQuantidade;
            await _estoqueService.CriarBloqueio(itemParaAtualizar.ProdutoId, itemParaAtualizar.Quantidade, clienteId, sessaoId);

            SessionHelper.SetObjectAsJson(HttpContext.Session, "Carrinho", carrinho);

            return Ok(new
            {
                sucesso = true,
                novoSubtotal = itemParaAtualizar.Subtotal.ToString("C"),
                novoTotal = carrinho.Total.ToString("C")
            });
        }

        private (int? clienteId, string sessaoId) GetUserAndSessionIds()
        {
            int? clienteId = null;
            if (User.Identity.IsAuthenticated && User.FindFirstValue("UserType") == "Cliente")
            {
                clienteId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier));
            }

            string sessaoId = HttpContext.Session.Id;

            return (clienteId, sessaoId);
        }

        [HttpGet]
        public async Task<IActionResult> VerificarExpiracao()
        {
            var carrinho = SessionHelper.GetObjectFromJson<CarrinhoViewModel>(HttpContext.Session, "Carrinho") ?? new CarrinhoViewModel();
            if (!carrinho.Itens.Any())
            {
                return Ok(new { expirado = false });
            }

            await _estoqueService.GetEstoqueDisponivel(0);

            var (clienteId, sessaoId) = GetUserAndSessionIds();
            var bloqueiosAtivos = await _context.EstoquesBloqueados
                .Where(b => (clienteId.HasValue && b.ClienteID == clienteId) || b.SessaoId == sessaoId)
                .Select(b => b.ProdutoID)
                .ToListAsync();

            var itensExpirados = carrinho.Itens.Where(item => !bloqueiosAtivos.Contains(item.ProdutoId)).ToList();

            if (itensExpirados.Any())
            {
                foreach (var item in itensExpirados)
                {
                    carrinho.Itens.Remove(item);
                }
                SessionHelper.SetObjectAsJson(HttpContext.Session, "Carrinho", carrinho);

                return Ok(new { expirado = true, produtosRemovidos = itensExpirados.Select(i => i.NomeProduto) });
            }

            return Ok(new { expirado = false });
        }
    }
}