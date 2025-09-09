using Ecommerce_Jogos.Data;
using Ecommerce_Jogos.Helpers;
using Ecommerce_Jogos.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Ecommerce_Jogos.Controllers
{
    public class CarrinhoController : Controller
    {
        private readonly ApplicationDbContext _context;

        public CarrinhoController(ApplicationDbContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            var carrinho = SessionHelper.GetObjectFromJson<CarrinhoViewModel>(HttpContext.Session, "Carrinho") ?? new CarrinhoViewModel();
            return View(carrinho);
        }

        public IActionResult Details(int id)
        {
            return View();
        }

        public IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create(IFormCollection collection)
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

        [HttpPost]
        public async Task<IActionResult> Adicionar(int produtoId, int quantidade)
        {
            var produto = await _context.Produtos.FindAsync(produtoId);
            if (produto == null)
            {
                return NotFound("Produto não encontrado.");
            }

            var estoqueDisponivel = await _context.EntradasEstoque
                                          .Where(e => e.ProdutoID == produtoId)
                                          .SumAsync(e => e.Quantidade);

            if (quantidade > estoqueDisponivel)
            {
                return BadRequest($"Estoque insuficiente. Apenas {estoqueDisponivel} unidades disponíveis.");
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
        public IActionResult Remover(int produtoId)
        {
            var carrinho = SessionHelper.GetObjectFromJson<CarrinhoViewModel>(HttpContext.Session, "Carrinho");

            if (carrinho != null)
            {
                var itemParaRemover = carrinho.Itens.FirstOrDefault(i => i.ProdutoId == produtoId);

                if (itemParaRemover != null)
                {
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
                return Remover(produtoId);
            }

            var estoqueDisponivel = await _context.EntradasEstoque
                                          .Where(e => e.ProdutoID == produtoId)
                                          .SumAsync(e => e.Quantidade);

            if (novaQuantidade > estoqueDisponivel)
            {
                return BadRequest($"Estoque insuficiente. Apenas {estoqueDisponivel} unidades disponíveis.");
            }

            var carrinho = SessionHelper.GetObjectFromJson<CarrinhoViewModel>(HttpContext.Session, "Carrinho");

            if (carrinho != null)
            {
                var itemParaAtualizar = carrinho.Itens.FirstOrDefault(i => i.ProdutoId == produtoId);

                if (itemParaAtualizar != null)
                {
                    itemParaAtualizar.Quantidade = novaQuantidade;
                    SessionHelper.SetObjectAsJson(HttpContext.Session, "Carrinho", carrinho);

                    return Ok(new
                    {
                        sucesso = true,
                        novoSubtotal = itemParaAtualizar.Subtotal.ToString("C"),
                        novoTotal = carrinho.Total.ToString("C")
                    });
                }
            }

            return NotFound("Item não encontrado no carrinho.");
        }
    }
}
