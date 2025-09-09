using Ecommerce_Jogos.Data;
using Ecommerce_Jogos.Models;
using Ecommerce_Jogos.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace Ecommerce_Jogos.Controllers
{
    public class CartoesController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly LogService _logService;

        public CartoesController(ApplicationDbContext context, LogService logService)
        {
            _context = context;
            _logService = logService;
        }

        public async Task<IActionResult> Index(int clienteId)
        {
            var cliente = await _context.Clientes.FindAsync(clienteId);
            if (cliente == null)
            {
                return NotFound();
            }

            var cartoesDoCliente = await _context.Cartoes
                .Where(c => c.ClienteID == clienteId)
                .ToListAsync();

            var viewModel = new CartaoIndexViewModel
            {
                ClienteID = cliente.Id,
                ClienteNome = cliente.NomeCompleto,
                Cartoes = cartoesDoCliente
            };

            return View(viewModel);
        }

        public IActionResult Create(int clienteId, string returnUrl = null)
        {
            var cliente = _context.Clientes.Find(clienteId);
            if (cliente == null)
            {
                return NotFound();
            }

            var viewModel = new CartaoCadastroViewModel
            {
                ClienteID = cliente.Id,
                ClienteNome = cliente.NomeCompleto
            };

            ViewData["ReturnUrl"] = returnUrl;
            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(CartaoCadastroViewModel viewModel, string returnUrl = null)
        {
            if (!ModelState.IsValid)
            {
                var cliente = await _context.Clientes.FindAsync(viewModel.ClienteID);
                if (cliente != null)
                {
                    viewModel.ClienteNome = cliente.NomeCompleto;
                }
                return View(viewModel);
            }

            if (ModelState.IsValid)
            {

                if (viewModel.Preferencial)
                {
                    var antigosPreferenciais = await _context.Cartoes
                        .Where(c => c.ClienteID == viewModel.ClienteID && c.Preferencial)
                        .ToListAsync();

                    foreach (var cartaoAntigo in antigosPreferenciais)
                    {
                        cartaoAntigo.Preferencial = false;
                    }
                }

                var ultimosQuatroDigitos = viewModel.NumeroCartao.Length > 4
                    ? viewModel.NumeroCartao.Substring(viewModel.NumeroCartao.Length - 4)
                    : viewModel.NumeroCartao;

                var novoCartao = new Cartao
                {
                    ClienteID = viewModel.ClienteID,
                    NomeImpresso = viewModel.NomeImpresso,
                    DataValidade = viewModel.DataValidade,
                    Bandeira = viewModel.Bandeira,
                    UltimosQuatroDigitos = ultimosQuatroDigitos,
                    Preferencial = viewModel.Preferencial
                };

                _context.Cartoes.Add(novoCartao);

                await _context.SaveChangesAsync();

                await _logService.RegistrarLog(
                        adminId: GetCurrentAdminId(),
                        tipoOperacao: "INSERÇÃO",
                        tabela: "Cartao",
                        registroId: novoCartao.ID,
                        dadosAntigos: null,
                        dadosNovos: novoCartao
                    );
                await _context.SaveChangesAsync();

                if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
                {
                    return Redirect(returnUrl);
                }

                return RedirectToAction("Index", new { clienteId = viewModel.ClienteID });
            }

            ViewData["ReturnUrl"] = returnUrl;
            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var cartao = await _context.Cartoes.FindAsync(id);

            if (cartao == null)
            {
                return NotFound();
            }

            int clienteId = cartao.ClienteID;

            _context.Cartoes.Remove(cartao);

            await _context.SaveChangesAsync();

            return RedirectToAction("Index", new { clienteId = clienteId });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SetPreferred(int id)
        {
            var cartaoEscolhido = await _context.Cartoes.FindAsync(id);
            if (cartaoEscolhido == null)
            {
                return NotFound();
            }

            var antigosPreferenciais = await _context.Cartoes
                .Where(c => c.ClienteID == cartaoEscolhido.ClienteID && c.Preferencial)
                .ToListAsync();

            foreach (var cartaoAntigo in antigosPreferenciais)
            {
                cartaoAntigo.Preferencial = false;
            }

            cartaoEscolhido.Preferencial = true;

            await _context.SaveChangesAsync();

            return RedirectToAction("Index", new { clienteId = cartaoEscolhido.ClienteID });
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
    }
}
