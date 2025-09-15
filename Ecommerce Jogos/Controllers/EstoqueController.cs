using Ecommerce_Jogos.Data;
using Ecommerce_Jogos.Models;
using Ecommerce_Jogos.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace Ecommerce_Jogos.Controllers
{
    public class EstoqueController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly LogService _logService;

        public EstoqueController(ApplicationDbContext context, LogService logService)
        {
            _context = context;
            _logService = logService;
        }

        public async Task<IActionResult> Index()
        {
            var produtos = await _context.Produtos
                .Include(p => p.Plataforma)
                .OrderBy(p => p.ID)
                .ToListAsync();

            var quantidadesEmEstoque = new Dictionary<int, int>();
            foreach (var produto in produtos)
            {
                var quantidade = await _context.EntradasEstoque
                                       .Where(e => e.ProdutoID == produto.ID)
                                       .SumAsync(e => e.Quantidade);
                quantidadesEmEstoque.Add(produto.ID, quantidade);
            }

            ViewBag.Quantidades = quantidadesEmEstoque;

            return View(produtos);
        }

        public IActionResult Details(int id)
        {
            return View();
        }

        public IActionResult Create()
        {
            ViewBag.Produtos = new SelectList(_context.Produtos.OrderBy(p => p.ID), "ID", "Nome");
            ViewBag.Fornecedores = new SelectList(_context.Fornecedores.OrderBy(f => f.Nome), "ID", "Nome");

            return View(new EntradaEstoqueViewModel());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(EntradaEstoqueViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                var novaEntrada = new EntradaEstoque
                {
                    ProdutoID = viewModel.ProdutoID,
                    FornecedorID = viewModel.FornecedorID,
                    Quantidade = viewModel.Quantidade,
                    ValorCusto = viewModel.ValorCusto,
                    DataEntrada = viewModel.DataEntrada
                };
                _context.Add(novaEntrada);
                await _context.SaveChangesAsync();

                var maiorCusto = await _context.EntradasEstoque
                               .Where(e => e.ProdutoID == viewModel.ProdutoID)
                               .MaxAsync(e => e.ValorCusto);

                var produtoParaAtualizar = await _context.Produtos
                    .Include(p => p.GrupoPrecificacao)
                    .FirstOrDefaultAsync(p => p.ID == viewModel.ProdutoID);

                if (produtoParaAtualizar != null && produtoParaAtualizar.GrupoPrecificacao != null)
                {
                    produtoParaAtualizar.PrecoCusto = maiorCusto;

                    var margem = produtoParaAtualizar.GrupoPrecificacao.MargemLucro;
                    produtoParaAtualizar.PrecoVenda = maiorCusto * (1 + (margem / 100));
                }

                await VerificarEstoque(viewModel.ProdutoID);

                await _context.SaveChangesAsync();

                TempData["SuccessMessage"] = "Entrada de estoque registrada com sucesso!";
                return RedirectToAction(nameof(Index));
            }

            ViewBag.Produtos = new SelectList(_context.Produtos.OrderBy(p => p.Nome), "ID", "Nome", viewModel.ProdutoID);
            ViewBag.Fornecedores = new SelectList(_context.Fornecedores.OrderBy(f => f.Nome), "ID", "Nome", viewModel.FornecedorID);
            return View(viewModel);
        }

        public IActionResult Edit(int id)
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        public IActionResult Delete(int id)
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        private async Task VerificarEstoque(int produtoId)
        {
            var estoqueAtual = await _context.EntradasEstoque
                                     .Where(e => e.ProdutoID == produtoId)
                                     .SumAsync(e => e.Quantidade);

            var produto = await _context.Produtos.FindAsync(produtoId);

            if (produto != null && !produto.Ativo)
            {
                var dadosAntigos = new { Ativo = produto.Ativo };
                produto.Ativo = true;

                await _logService.RegistrarLog(
                    adminId: null,
                    tipoOperacao: "ATIVAÇÃO",
                    tabela: "Produto",
                    registroId: produto.ID,
                    dadosAntigos: dadosAntigos,
                    dadosNovos: new { Ativo = produto.Ativo },
                    motivo: "Reentrada de estoque"
                );
            }
        }
    }
}
