using Ecommerce_Jogos.Data;
using Ecommerce_Jogos.Helpers;
using Ecommerce_Jogos.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace Ecommerce_Jogos.Controllers
{
    [Authorize]
    public class CheckoutController : Controller
    {
        private readonly ApplicationDbContext _context;

        public CheckoutController(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var carrinho = SessionHelper.GetObjectFromJson<CarrinhoViewModel>(HttpContext.Session, "Carrinho");
            if (carrinho == null || !carrinho.Itens.Any())
            {
                return RedirectToAction("Index", "Carrinho");
            }

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

            var clienteIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (clienteIdClaim == null)
            {
                return RedirectToAction("Login", "Conta");
            }

            var clienteId = int.Parse(clienteIdClaim.Value);
            ViewBag.ClienteId = clienteId;

            var enderecosCliente = await _context.Enderecos
                                .Where(e => e.ClienteID == clienteId)
                                .Include(e => e.Cidade).ThenInclude(c => c.Estado)
                                .Include(e => e.Tipo_Logradouro)
                                .ToListAsync();

            var cartoesCliente = await _context.Cartoes
                                      .Where(c => c.ClienteID == clienteId)
                                      .ToListAsync();

            var viewModel = new CheckoutViewModel
            {
                Carrinho = carrinho,
                Enderecos = enderecosCliente,
                Cartoes = cartoesCliente
            };

            var cupomCodigo = HttpContext.Session.GetString("CupomCodigo");
            if (!string.IsNullOrEmpty(cupomCodigo))
            {
                var cupom = await _context.Cupons.FirstOrDefaultAsync(c => c.Codigo == cupomCodigo && c.Ativo);
                if (cupom != null)
                {
                    viewModel.CupomCodigo = cupom.Codigo;
                    viewModel.ValorDesconto = Math.Min(carrinho.Total, cupom.Valor);
                }
            }

            return View(viewModel);
        }

        [HttpPost]
        public async Task<IActionResult> CalcularFrete(int enderecoId)
        {
            var endereco = await _context.Enderecos
                .Include(e => e.Cidade).ThenInclude(c => c.Estado)
                .FirstOrDefaultAsync(e => e.ID == enderecoId);

            if (endereco == null)
            {
                return NotFound("Endereço não encontrado.");
            }

            decimal valorFrete;
            var uf = endereco.Cidade.Estado.UF;

            if (uf == "SP")
            {
                valorFrete = 10.50m;
            }
            else if (new[] { "RJ", "MG", "ES" }.Contains(uf))
            {
                valorFrete = 18.00m;
            }
            else
            {
                valorFrete = 25.75m;
            }

            var carrinho = SessionHelper.GetObjectFromJson<CarrinhoViewModel>(HttpContext.Session, "Carrinho");
            var cuponsNaSessao = SessionHelper.GetObjectFromJson<List<string>>(HttpContext.Session, "CuponsAplicados") ?? new List<string>();
            decimal valorDescontoTotal = 0;

            if (cuponsNaSessao.Any())
            {
                var cuponsDoBanco = await _context.Cupons
                    .Where(c => cuponsNaSessao.Contains(c.Codigo) && c.Ativo)
                    .ToListAsync();

                valorDescontoTotal = cuponsDoBanco.Sum(c => c.Valor);
            }

            if (valorDescontoTotal > carrinho.Total)
            {
                valorDescontoTotal = carrinho.Total;
            }

            var totalComFrete = (carrinho.Total - valorDescontoTotal) + valorFrete;

            return Ok(new
            {
                valorFreteFormatado = valorFrete.ToString("C"),
                totalComFreteFormatado = totalComFrete.ToString("C")
            });
        }

        [HttpPost]
        public async Task<IActionResult> AplicarCupom(string codigo)
        {
            var carrinho = SessionHelper.GetObjectFromJson<CarrinhoViewModel>(HttpContext.Session, "Carrinho");
            if (carrinho == null) return BadRequest("Carrinho não encontrado.");

            var cuponsNaSessao = SessionHelper.GetObjectFromJson<List<string>>(HttpContext.Session, "CuponsAplicados") ?? new List<string>();

            if (cuponsNaSessao.Contains(codigo.ToUpper()))
            {
                return Json(new { sucesso = false, mensagem = "Este cupom já foi aplicado." });
            }

            var cupom = await _context.Cupons.FirstOrDefaultAsync(c => c.Codigo == codigo && c.Ativo);
            if (cupom == null)
            {
                return Json(new { sucesso = false, mensagem = "Cupom inválido ou expirado." });
            }

            if (cupom.Tipo == "PROMOCIONAL")
            {
                var cuponsDoBanco = await _context.Cupons.Where(c => cuponsNaSessao.Contains(c.Codigo)).ToListAsync();
                if (cuponsDoBanco.Any(c => c.Tipo == "PROMOCIONAL"))
                {
                    return Json(new { sucesso = false, mensagem = "Apenas um cupom promocional por compra." });
                }
            }

            cuponsNaSessao.Add(cupom.Codigo.ToUpper());
            SessionHelper.SetObjectAsJson(HttpContext.Session, "CuponsAplicados", cuponsNaSessao);

            var cuponsDoBancoAtualizados = await _context.Cupons.Where(c => cuponsNaSessao.Contains(c.Codigo)).ToListAsync();
            decimal descontoTotal = cuponsDoBancoAtualizados.Sum(c => c.Valor);
            if (descontoTotal > carrinho.Total) descontoTotal = carrinho.Total;
            var novoTotal = carrinho.Total - descontoTotal;

            return Json(new
            {
                sucesso = true,
                cupomAdicionado = new { codigo = cupom.Codigo, valorFormatado = cupom.Valor.ToString("C") },
                descontoTotalFormatado = descontoTotal.ToString("C"),
                novoTotalFormatado = novoTotal.ToString("C")
            });
        }

        [HttpPost]
        public async Task<IActionResult> RemoverCupom(string codigo)
        {
            var carrinho = SessionHelper.GetObjectFromJson<CarrinhoViewModel>(HttpContext.Session, "Carrinho");
            var cuponsNaSessao = SessionHelper.GetObjectFromJson<List<string>>(HttpContext.Session, "CuponsAplicados") ?? new List<string>();

            cuponsNaSessao.Remove(codigo.ToUpper());
            SessionHelper.SetObjectAsJson(HttpContext.Session, "CuponsAplicados", cuponsNaSessao);

            var cuponsDoBancoAtualizados = await _context.Cupons.Where(c => cuponsNaSessao.Contains(c.Codigo)).ToListAsync();
            decimal descontoTotal = cuponsDoBancoAtualizados.Sum(c => c.Valor);
            if (descontoTotal > carrinho.Total) descontoTotal = carrinho.Total;
            var novoTotal = carrinho.Total - descontoTotal;

            return Json(new
            {
                sucesso = true,
                descontoTotalFormatado = descontoTotal.ToString("C"),
                novoTotalFormatado = novoTotal.ToString("C")
            });
        }

    }
}
