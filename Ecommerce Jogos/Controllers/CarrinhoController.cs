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

        public async Task<IActionResult> Index()
        {
            var carrinho = SessionHelper.GetObjectFromJson<CarrinhoViewModel>(HttpContext.Session, "Carrinho") ?? new CarrinhoViewModel();

            if (carrinho.Itens.Any())
            {
                var mensagensNotificacao = new List<string>();
                var itensParaRemover = new List<CarrinhoItemViewModel>();

                foreach (var item in carrinho.Itens)
                {
                    var estoqueDisponivel = await _context.EntradasEstoque
                                                          .Where(e => e.ProdutoID == item.ProdutoId)
                                                          .SumAsync(e => e.Quantidade);

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

                // Remove os itens marcados fora do loop para não dar erro na coleção
                foreach (var item in itensParaRemover)
                {
                    carrinho.Itens.Remove(item);
                }

                // Se houveram notificações, armazena em TempData e atualiza a sessão
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
