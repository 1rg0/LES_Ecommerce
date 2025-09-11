using Ecommerce_Jogos.Data;
using Ecommerce_Jogos.Helpers;
using Ecommerce_Jogos.Models;
using Ecommerce_Jogos.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace Ecommerce_Jogos.Controllers
{
    public class PedidosController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly LogService _logService;

        public PedidosController(ApplicationDbContext context, LogService logService)
        {
            _context = context;
            _logService = logService;
        }

        public async Task<IActionResult> Index(string filtroCliente, string filtroStatus, DateTime? dataInicio, DateTime? dataFim, int pageNumber = 1)
        {
            ViewData["FiltroCliente"] = filtroCliente;
            ViewData["FiltroStatus"] = filtroStatus;
            ViewData["DataInicio"] = dataInicio?.ToString("yyyy-MM-dd");
            ViewData["DataFim"] = dataFim?.ToString("yyyy-MM-dd");

            var pedidosQuery = _context.Pedidos
                                       .Include(p => p.Cliente)
                                       .AsQueryable();

            if (!string.IsNullOrEmpty(filtroCliente))
            {
                pedidosQuery = pedidosQuery.Where(p => p.Cliente.NomeCompleto.Contains(filtroCliente) || p.Cliente.CPF.Contains(filtroCliente));
            }

            if (!string.IsNullOrEmpty(filtroStatus))
            {
                pedidosQuery = pedidosQuery.Where(p => p.Status == filtroStatus);
            }

            if (dataInicio.HasValue)
            {
                pedidosQuery = pedidosQuery.Where(p => p.DataPedido >= dataInicio.Value);
            }

            if (dataFim.HasValue)
            {
                pedidosQuery = pedidosQuery.Where(p => p.DataPedido < dataFim.Value.AddDays(1));
            }

            int pageSize = 10;
            var pedidosPaginados = await ListaPaginada<Pedido>.CreateAsync(pedidosQuery.AsNoTracking().OrderByDescending(p => p.DataPedido), pageNumber, pageSize);

            return View(pedidosPaginados);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Processar(CheckoutViewModel viewModel)
        {
            var carrinho = SessionHelper.GetObjectFromJson<CarrinhoViewModel>(HttpContext.Session, "Carrinho");
            var clienteId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value);

            if (carrinho == null || !carrinho.Itens.Any())
            {
                return RedirectToAction("Index", "Carrinho");
            }

            foreach (var item in carrinho.Itens)
            {
                var estoqueDisponivel = await _context.EntradasEstoque
                                              .Where(e => e.ProdutoID == item.ProdutoId)
                                              .SumAsync(e => e.Quantidade);
                if (item.Quantidade > estoqueDisponivel)
                {
                    TempData["ErrorMessage"] = $"Estoque insuficiente para o produto '{item.NomeProduto}'. Apenas {estoqueDisponivel} unidades disponíveis. Por favor, ajuste seu carrinho.";
                    return RedirectToAction("Index", "Carrinho");
                }
            }

            decimal valorFrete = 0;
            var enderecoSelecionado = await _context.Enderecos
                .Include(e => e.Cidade).ThenInclude(c => c.Estado)
                .FirstOrDefaultAsync(e => e.ID == viewModel.EnderecoSelecionadoId);

            if (enderecoSelecionado != null)
            {
                var uf = enderecoSelecionado.Cidade.Estado.UF;
                if (uf == "SP") { valorFrete = 10.50m; }
                else if (new[] { "RJ", "MG", "ES" }.Contains(uf)) { valorFrete = 18.00m; }
                else { valorFrete = 25.75m; }
            }

            decimal valorDescontoTotal = 0;
            var cuponsUtilizados = new List<Cupom>();
            var cupomCodigo = HttpContext.Session.GetString("CupomCodigo");
            if (viewModel.CuponsAplicados != null && viewModel.CuponsAplicados.Any())
            {
                var cuponsDoBanco = await _context.Cupons
                    .Where(c => viewModel.CuponsAplicados.Contains(c.Codigo) && c.Ativo)
                    .ToListAsync();

                foreach (var cupom in cuponsDoBanco.Where(c => c.Tipo == "TROCA"))
                {
                    valorDescontoTotal += cupom.Valor;
                    cuponsUtilizados.Add(cupom);
                }
                var cupomPromocional = cuponsDoBanco.FirstOrDefault(c => c.Tipo == "PROMOCIONAL");
                if (cupomPromocional != null)
                {
                    valorDescontoTotal += cupomPromocional.Valor;
                    cuponsUtilizados.Add(cupomPromocional);
                }
            }

            var subtotal = carrinho.Total;
            if (valorDescontoTotal > subtotal) valorDescontoTotal = subtotal;

            var valorTotalFinal = subtotal + valorFrete - valorDescontoTotal;

            decimal totalPagoComCartoes = 0;
            if (viewModel.PagamentosComCartao != null)
            {
                totalPagoComCartoes = viewModel.PagamentosComCartao.Sum(p => p.Valor);
            }

            if (totalPagoComCartoes < valorTotalFinal)
            {
                TempData["ErrorMessage"] = "O valor pago nos cartões é insuficiente para cobrir o total do pedido.";
                return RedirectToAction("Index", "Checkout");
            }

            var novoPedido = new Pedido
            {
                ClienteID = clienteId,
                EnderecoID = viewModel.EnderecoSelecionadoId,
                DataPedido = DateTime.Now,
                ValorTotal = valorTotalFinal,
                Status = "EM PROCESSAMENTO"
            };
            _context.Pedidos.Add(novoPedido);

            var produtosAfetados = new List<int>();

            foreach (var item in carrinho.Itens)
            {
                if (!produtosAfetados.Contains(item.ProdutoId))
                {
                    produtosAfetados.Add(item.ProdutoId);
                }

                var itemPedido = new ItemPedido
                {
                    Pedido = novoPedido,
                    ProdutoID = item.ProdutoId,
                    Quantidade = item.Quantidade,
                    PrecoUnitario = item.PrecoUnitario
                };
                _context.ItensPedido.Add(itemPedido);

                var saidaEstoque = new EntradaEstoque
                {
                    ProdutoID = item.ProdutoId,
                    Quantidade = -item.Quantidade,
                    ValorCusto = 0,
                    DataEntrada = DateTime.Now,
                    FornecedorID = null
                };
                _context.EntradasEstoque.Add(saidaEstoque);
            }

            await _context.SaveChangesAsync();

            if (viewModel.PagamentosComCartao != null)
            {
                foreach (var pagamento in viewModel.PagamentosComCartao)
                {
                    var pagamentoPedido = new PagamentoPedido
                    {
                        PedidoID = novoPedido.ID,
                        CartaoID = pagamento.CartaoId,
                        ValorPago = pagamento.Valor
                    };
                    _context.PagamentosPedido.Add(pagamentoPedido);
                }
            }

            await _context.SaveChangesAsync();

            foreach (var cupom in cuponsUtilizados)
            {
                if (cupom != null && cupom.Tipo == "TROCA")
                {
                    var dadosAntigosCupom = new { Ativo = cupom.Ativo, PedidoUsoID = cupom.PedidoUsoID };

                    cupom.Ativo = false;
                    cupom.PedidoUsoID = novoPedido.ID;

                    await _logService.RegistrarLog(
                        adminId: null,
                        tipoOperacao: "INATIVAÇÃO",
                        tabela: "Cupom",
                        registroId: cupom.ID,
                        dadosAntigos: dadosAntigosCupom,
                        dadosNovos: new { Ativo = cupom.Ativo, PedidoUsoID = cupom.PedidoUsoID },
                        motivo: $"Cupom de troca utilizado no pedido #{novoPedido.ID}"
                    );
                }
            }

            await _context.SaveChangesAsync();

            HttpContext.Session.Remove("Carrinho");
            HttpContext.Session.Remove("CupomCodigo");

            await _logService.RegistrarLog(
                adminId: null,
                tipoOperacao: "INSERÇÃO",
                tabela: "Pedido",
                registroId: novoPedido.ID,
                dadosAntigos: null,
                dadosNovos: novoPedido
            );

            foreach (var produtoId in produtosAfetados)
            {
                await VerificarEstoque(produtoId);
            }

            await _context.SaveChangesAsync();
            await SimularAprovacaoPagamento(novoPedido.ID);

            return RedirectToAction("Confirmacao", new { pedidoId = novoPedido.ID });
        }

        public async Task<IActionResult> Confirmacao(int pedidoId)
        {
            var pedido = await _context.Pedidos.FindAsync(pedidoId);
            if (pedido == null)
            {
                return NotFound();
            }
            ViewBag.PedidoId = pedido.ID;
            return View();
        }

        public async Task<IActionResult> Details(int id)
        {
            var pedido = await _context.Pedidos
                .Include(p => p.Cliente)
                .Include(p => p.Endereco)
                    .ThenInclude(e => e.Cidade)
                        .ThenInclude(c => c.Estado)
                .Include(p => p.Endereco)
                    .ThenInclude(e => e.Tipo_Logradouro)
                .Include(p => p.ItensPedido)
                    .ThenInclude(ip => ip.Produto)
                        .ThenInclude(prod => prod.Plataforma)
                .FirstOrDefaultAsync(p => p.ID == id);

            if (pedido == null)
            {
                return NotFound();
            }

            var pagamentos = await _context.PagamentosPedido
                           .Where(pc => pc.PedidoID == id)
                           .Include(pc => pc.Cartao)
                           .ToListAsync();

            ViewBag.Pagamentos = pagamentos;

            ViewBag.CuponsUtilizados = await _context.Cupons
                .Where(c => c.PedidoUsoID == id)
                .ToListAsync();

            if (pedido.Status == "TROCADO")
            {
                var cupomDeTroca = await _context.Cupons
                                         .FirstOrDefaultAsync(c => c.PedidoOrigemID == id);
                ViewBag.CupomDeTroca = cupomDeTroca;
            }

            return View(pedido);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Despachar(int id)
        {
            var pedido = await _context.Pedidos.FindAsync(id);

            if (pedido == null)
            {
                return NotFound();
            }
            if (pedido.Status != "APROVADA")
            {
                TempData["ErrorMessage"] = $"O pedido #{id} não pode ser despachado pois seu status atual é '{pedido.Status}'.";
                return RedirectToAction(nameof(Index));
            }

            var dadosAntigos = new { Status = pedido.Status };

            pedido.Status = "EM TRÂNSITO";

            await _logService.RegistrarLog(
                adminId: GetCurrentAdminId(),
                tipoOperacao: "ALTERAÇÃO",
                tabela: "Pedido",
                registroId: pedido.ID,
                dadosAntigos: dadosAntigos,
                dadosNovos: new { Status = "EM TRANSITO" },
                motivo: "Pedido despachado pelo administrador"
            );

            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = $"Pedido #{id} despachado com sucesso!";
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ConfirmarEntrega(int id)
        {
            var pedido = await _context.Pedidos.FindAsync(id);

            if (pedido == null)
            {
                return NotFound();
            }
            if (pedido.Status != "EM TRÂNSITO")
            {
                TempData["ErrorMessage"] = $"A entrega do pedido #{id} não pode ser confirmada pois seu status atual é '{pedido.Status}'.";
                return RedirectToAction(nameof(Index));
            }

            var dadosAntigos = new { Status = "EM TRANSITO" };


            pedido.Status = "ENTREGUE";

            await _logService.RegistrarLog(
                adminId: GetCurrentAdminId(),
                tipoOperacao: "ALTERAÇÃO",
                tabela: "Pedido",
                registroId: pedido.ID,
                dadosAntigos: dadosAntigos,
                dadosNovos: new { Status = pedido.Status },
                motivo: "Entrega confirmada pelo administrador"
            );

            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = $"Entrega do pedido #{id} confirmada com sucesso!";
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AutorizarTroca(int id)
        {
            var pedido = await _context.Pedidos.FindAsync(id);

            if (pedido == null)
            {
                return NotFound();
            }
            if (pedido.Status != "EM TROCA")
            {
                TempData["ErrorMessage"] = $"A troca do pedido #{id} não pode ser autorizada pois seu status atual é '{pedido.Status}'.";
                return RedirectToAction(nameof(Index));
            }

            var dadosAntigos = new { Status = pedido.Status };

            pedido.Status = "TROCA AUTORIZADA";

            var novaNotificacao = new Notificacao
            {
                ClienteID = pedido.ClienteID,
                Mensagem = $"Sua solicitação de troca para o pedido #{pedido.ID} foi autorizada.",
                Url = Url.Action("Details", "Pedidos", new { id = pedido.ID }),
                DataCriacao = DateTime.Now,
                Lida = false
            };
            _context.Notificacoes.Add(novaNotificacao);

            await _logService.RegistrarLog(
                adminId: GetCurrentAdminId(),
                tipoOperacao: "ALTERAÇÃO",
                tabela: "Pedido",
                registroId: pedido.ID,
                dadosAntigos: dadosAntigos,
                dadosNovos: new { Status = pedido.Status },
                motivo: "Troca autorizada pelo administrador"
            );

            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = $"Troca do pedido #{id} autorizada com sucesso!";
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ConfirmarRecebimentoTroca(int id, bool retornarAoEstoque)
        {
            var pedido = await _context.Pedidos
                .Include(p => p.Cliente)
                .Include(p => p.Trocas)
                    .ThenInclude(t => t.ItensTroca)
                        .ThenInclude(it => it.ItemPedido)
                .FirstOrDefaultAsync(p => p.ID == id);

            if (pedido == null || pedido.Status != "TROCA AUTORIZADA")
            {
                TempData["ErrorMessage"] = "Ação não permitida para o status atual do pedido.";
                return RedirectToAction(nameof(Index));
            }

            var troca = pedido.Trocas.FirstOrDefault(t => t.StatusTroca == "SOLICITADA" || t.StatusTroca == "AUTORIZADA");
            if (troca == null)
            {
                TempData["ErrorMessage"] = "Nenhuma solicitação de troca ativa encontrada para este pedido.";
                return RedirectToAction(nameof(Index));
            }

            decimal valorTotalTroca = 0;

            if (retornarAoEstoque)
            {
                foreach (var itemTrocado in troca.ItensTroca)
                {
                    var itemOriginal = itemTrocado.ItemPedido;
                    valorTotalTroca += itemOriginal.PrecoUnitario * itemOriginal.Quantidade;

                    var entradaEstoque = new EntradaEstoque
                    {
                        ProdutoID = itemOriginal.ProdutoID,
                        Quantidade = itemOriginal.Quantidade,
                        ValorCusto = 0,
                        DataEntrada = DateTime.Now,
                        FornecedorID = null
                    };
                    _context.EntradasEstoque.Add(entradaEstoque);

                    await VerificarEstoque(itemOriginal.ProdutoID);
                }
            }
            else
            {
                foreach (var itemTrocado in troca.ItensTroca)
                {
                    valorTotalTroca += itemTrocado.ItemPedido.PrecoUnitario * itemTrocado.ItemPedido.Quantidade;
                }
            }

            var novoCupom = new Cupom
            {
                Codigo = $"TROCA-{pedido.ID}-{DateTime.Now.Ticks}",
                Tipo = "TROCA",
                Valor = valorTotalTroca,
                DataCriacao = DateTime.Now,
                Ativo = true,
                ClienteID = pedido.ClienteID,
                PedidoOrigemID = pedido.ID
            };
            _context.Cupons.Add(novoCupom);
            await _context.SaveChangesAsync();

            var dadosAntigosPedido = new { Status = pedido.Status };
            pedido.Status = "TROCADO";
            troca.StatusTroca = "FINALIZADA";

            await _logService.RegistrarLog(
                adminId: GetCurrentAdminId(), 
                tipoOperacao: "ALTERAÇÃO", 
                tabela: "Pedido", 
                registroId: pedido.ID, 
                dadosAntigos: dadosAntigosPedido, 
                dadosNovos: new { Status = pedido.Status }, 
                motivo: "Recebimento de troca confirmado"
            );

            await _logService.RegistrarLog(
                adminId: GetCurrentAdminId(),
                tipoOperacao: "INSERÇÃO",
                tabela: "Cupom",
                registroId: novoCupom.ID,
                dadosAntigos: null,
                dadosNovos: novoCupom,
                motivo: $"Gerado a partir da troca do pedido #{pedido.ID}");

            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = $"Recebimento da troca para o pedido #{id} confirmado. Cupom de R$ {valorTotalTroca} gerado para o cliente {pedido.Cliente.NomeCompleto}.";
            return RedirectToAction(nameof(Index));
        }

        private async Task VerificarEstoque(int produtoId)
        {
            var estoqueAtual = await _context.EntradasEstoque
                                     .Where(e => e.ProdutoID == produtoId)
                                     .SumAsync(e => e.Quantidade);

            if (estoqueAtual <= 0)
            {
                var produto = await _context.Produtos.FindAsync(produtoId);

                if (produto != null && produto.Ativo)
                {
                    var dadosAntigos = new { Ativo = produto.Ativo };

                    produto.Ativo = false;

                    await _logService.RegistrarLog(
                        adminId: null,
                        tipoOperacao: "INATIVAÇÃO",
                        tabela: "Produto",
                        registroId: produto.ID,
                        dadosAntigos: dadosAntigos,
                        dadosNovos: new { Ativo = produto.Ativo },
                        motivo: "Fora de mercado"
                    );
                }
            }
        }

        private int? GetCurrentAdminId()
        {
            if (!User.Identity.IsAuthenticated)
            {
                return null;
            }

            var userTypeClaim = User.FindFirst("UserType");
            if (userTypeClaim?.Value != "Administrador")
            {
                return null;
            }

            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim != null && int.TryParse(userIdClaim.Value, out int adminId))
            {
                return adminId;
            }

            return null;
        }

        private async Task SimularAprovacaoPagamento(int pedidoId)
        {
            // Aguarda um tempo curto para simular a comunicação com a operadora
            await Task.Delay(2000); // Espera 2 segundos

            var pedido = await _context.Pedidos.FindAsync(pedidoId);
            if (pedido == null || pedido.Status != "EM PROCESSAMENTO")
            {
                return; // Sai se o pedido não for encontrado ou já tiver sido processado
            }

            var pagamentos = await _context.PagamentosPedido
                                           .Where(p => p.PedidoID == pedidoId)
                                           .Include(p => p.Cartao)
                                           .ToListAsync();

            bool deveReprovar = false;
            foreach (var pagamento in pagamentos)
            {
                if (pagamento.Cartao != null)
                {
                    var ultimosQuatro = pagamento.Cartao.UltimosQuatroDigitos;
                    // RN0028 (Simulado) - Verifica se os 4 últimos dígitos são iguais
                    if (ultimosQuatro.All(c => c == ultimosQuatro[0]))
                    {
                        deveReprovar = true;
                        break; // Encontrou um motivo para reprovar, pode parar a verificação
                    }
                }
            }

            var dadosAntigos = new { Status = pedido.Status };
            var novoStatus = deveReprovar ? "REPROVADA" : "APROVADA";
            pedido.Status = novoStatus;

            await _logService.RegistrarLog(
                adminId: null, // Processo automático
                tipoOperacao: "ALTERAÇÃO",
                tabela: "Pedido",
                registroId: pedido.ID,
                dadosAntigos: dadosAntigos,
                dadosNovos: new { Status = novoStatus },
                motivo: "Resposta do operadora do cartão"
            );

            // Se o pagamento foi reprovado, retorna os itens ao estoque
            if (deveReprovar)
            {
                var itensDoPedido = await _context.ItensPedido.Where(ip => ip.PedidoID == pedidoId).ToListAsync();
                foreach (var item in itensDoPedido)
                {
                    var reentradaEstoque = new EntradaEstoque
                    {
                        ProdutoID = item.ProdutoID,
                        Quantidade = item.Quantidade, // Quantidade positiva para reentrada
                        ValorCusto = 0,
                        DataEntrada = DateTime.Now,
                        FornecedorID = null
                    };
                    _context.EntradasEstoque.Add(reentradaEstoque);
                    // RN0028 - Desbloqueia e mantém em estoque
                    await VerificarEstoque(item.ProdutoID);
                }
            }

            await _context.SaveChangesAsync();
        }
    }
}
