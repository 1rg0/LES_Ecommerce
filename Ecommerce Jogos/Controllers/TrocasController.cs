using Ecommerce_Jogos.Data;
using Ecommerce_Jogos.Models;
using Ecommerce_Jogos.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace Ecommerce_Jogos.Controllers
{
    public class TrocasController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly LogService _logService;

        public TrocasController(ApplicationDbContext context, LogService logService)
        {
            _context = context;
            _logService = logService;
        }

        public async Task<IActionResult> Solicitar(int pedidoId)
        {
            var pedido = await _context.Pedidos
                .Include(p => p.ItensPedido).ThenInclude(ip => ip.Produto)
                .FirstOrDefaultAsync(p => p.ID == pedidoId);

            if (pedido == null || pedido.Status != "ENTREGUE")
            {
                return BadRequest("Este pedido não pode ser trocado.");
            }

            var viewModel = new SolicitarTrocaViewModel
            {
                PedidoId = pedido.ID,
                ItensParaTroca = pedido.ItensPedido.Select(item => new ItemParaTrocaViewModel
                {
                    ProdutoId = item.ProdutoID,
                    NomeProduto = item.Produto.Nome,
                    UrlImagem = item.Produto.URLImagem,
                    ItemPedidoChave = $"{item.PedidoID}_{item.ProdutoID}"
                }).ToList()
            };

            return PartialView("_SolicitarTrocaPartial", viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Solicitar(SolicitarTrocaViewModel viewModel)
        {
            if (viewModel.ItensSelecionados == null || !viewModel.ItensSelecionados.Any())
            {
                ModelState.AddModelError("ItensSelecionados", "Você deve selecionar pelo menos um item para trocar.");
            }

            if (ModelState.IsValid)
            {
                var pedidoOriginal = await _context.Pedidos.FindAsync(viewModel.PedidoId);
                if (pedidoOriginal == null || pedidoOriginal.Status != "ENTREGUE")
                {
                    return Json(new { success = false, message = "Este pedido não pode mais ser trocado." });
                }

                var novaTroca = new Troca
                {
                    PedidoID = viewModel.PedidoId,
                    ClienteID = GetCurrentClientId(),
                    DataSolicitacao = DateTime.Now,
                    Motivo = viewModel.Motivo,
                    StatusTroca = "SOLICITADA"
                };

                foreach (var itemChave in viewModel.ItensSelecionados)
                {
                    var ids = itemChave.Split('_');
                    var pedidoId = int.Parse(ids[0]);
                    var produtoId = int.Parse(ids[1]);
                    novaTroca.ItensTroca.Add(new ItemTroca
                    {
                        ItemPedidoPedidoID = pedidoId,
                        ItemPedidoProdutoID = produtoId
                    });
                }

                _context.Trocas.Add(novaTroca);

                var dadosAntigosPedido = new { Status = pedidoOriginal.Status };
                pedidoOriginal.Status = "EM TROCA";

                await _logService.RegistrarLog(
                    adminId: null,
                    tipoOperacao: "ALTERAÇÃO",
                    tabela: "Pedido",
                    registroId: pedidoOriginal.ID,
                    dadosAntigos: dadosAntigosPedido,
                    dadosNovos: new { Status = pedidoOriginal.Status },
                    motivo: "Solicitação de troca criada pelo cliente"
                );

                await _context.SaveChangesAsync();

                TempData["SuccessMessage"] = "Sua solicitação de troca foi registrada com sucesso!";

                return Json(new { success = true, redirectUrl = Url.Action("Details", "Pedidos", new { id = viewModel.PedidoId }) });
            }

            return BadRequest(ModelState);
        }

        private int GetCurrentClientId()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim != null && int.TryParse(userIdClaim.Value, out int clienteId))
            {
                return clienteId;
            }
            throw new Exception("Não foi possível obter o ID do cliente logado.");
        }
    }
}