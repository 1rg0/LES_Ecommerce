using Ecommerce_Jogos.Data;
using Ecommerce_Jogos.Models;
using Ecommerce_Jogos.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace Ecommerce_Jogos.Controllers
{
    public class EnderecosController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly LogService _logService;

        public EnderecosController(ApplicationDbContext context, LogService logService)
        {
            _context = context;
            _logService = logService;
        }

        public async Task<IActionResult> Index(int clienteId)
        {
            var cliente = await _context.Clientes.FindAsync(clienteId);
            if (cliente == null)
            {
                return RedirectToAction("Index", "Clientes");
            }

            var enderecosDoCliente = await _context.Enderecos
                .Where(e => e.ClienteID == clienteId)
                .Include(e => e.Cidade).ThenInclude(c => c.Estado).ThenInclude(es => es.Pais)
                .Include(e => e.Tipo_Endereco)
                .Include(e => e.Tipo_Logradouro)
                .Include(e => e.Tipo_Residencia)
                .ToListAsync();

            var viewModel = new EnderecoIndexViewModel
            {
                ClienteID = cliente.Id,
                ClienteNome = cliente.NomeCompleto,
                Enderecos = enderecosDoCliente
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

            var viewModel = new EnderecoCadastroViewModel
            {
                ClienteID = cliente.Id,
                ClienteNome = cliente.NomeCompleto
            };

            ViewBag.Cidades = new SelectList(_context.Cidades, "ID", "Nome");
            ViewBag.TiposEndereco = new SelectList(_context.TiposEndereco, "ID", "Tipo");
            ViewBag.TiposResidencia = new SelectList(_context.TiposResidencia, "ID", "Tipo");
            ViewBag.TiposLogradouro = new SelectList(_context.TiposLogradouro, "ID", "Tipo");

            ViewData["ReturnUrl"] = returnUrl;

            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(EnderecoCadastroViewModel viewModel, string returnUrl = null)
        {
            if (ModelState.IsValid)
            {
                var novoEndereco = new Endereco
                {
                    ClienteID = viewModel.ClienteID,
                    Apelido = viewModel.Apelido,
                    Tipo_EnderecoID = viewModel.Tipo_EnderecoID,
                    Tipo_ResidenciaID = viewModel.Tipo_ResidenciaID,
                    Tipo_LogradouroID = viewModel.Tipo_LogradouroID,
                    CidadeID = viewModel.CidadeID,
                    Logradouro = viewModel.Logradouro,
                    Numero = viewModel.Numero,
                    Bairro = viewModel.Bairro,
                    CEP = viewModel.CEP,
                    Observacao = viewModel.Observacao
                };
                _context.Enderecos.Add(novoEndereco);


                await _context.SaveChangesAsync();

                await _logService.RegistrarLog(
                    adminId: GetCurrentAdminId(),
                    tipoOperacao: "INSERÇÃO",
                    tabela: "Endereco",
                    registroId: novoEndereco.ID,
                    dadosAntigos: null,
                    dadosNovos: novoEndereco
                );
                await _context.SaveChangesAsync();

                if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
                {
                    return Redirect(returnUrl);
                }

                return RedirectToAction("Details", "Clientes", new { id = viewModel.ClienteID });
            }

            ViewBag.Cidades = new SelectList(_context.Cidades.OrderBy(c => c.Nome), "ID", "Nome", viewModel.CidadeID);
            ViewBag.TiposResidencia = new SelectList(_context.TiposResidencia, "ID", "Tipo", viewModel.Tipo_ResidenciaID);
            ViewBag.TiposLogradouro = new SelectList(_context.TiposLogradouro, "ID", "Tipo", viewModel.Tipo_LogradouroID);

            ViewData["ReturnUrl"] = returnUrl;
            return View(viewModel);
        }

        public async Task<IActionResult> Edit(int id)
        {
            var endereco = await _context.Enderecos.Include(e => e.Cliente).FirstOrDefaultAsync(e => e.ID == id);
            if (endereco == null)
            {
                return NotFound();
            }

            var viewModel = new EnderecoEdicaoViewModel
            {
                ID = endereco.ID,
                ClienteID = endereco.ClienteID,
                Apelido = endereco.Apelido,
                Tipo_EnderecoID = endereco.Tipo_EnderecoID,
                Tipo_ResidenciaID = endereco.Tipo_ResidenciaID,
                Tipo_LogradouroID = endereco.Tipo_LogradouroID,
                CidadeID = endereco.CidadeID,
                Logradouro = endereco.Logradouro,
                Numero = endereco.Numero,
                Bairro = endereco.Bairro,
                CEP = endereco.CEP,
                Observacao = endereco.Observacao
            };

            ViewBag.Cidades = new SelectList(_context.Cidades.OrderBy(c => c.Nome), "ID", "Nome", viewModel.CidadeID);
            ViewBag.TiposEndereco = new SelectList(_context.TiposEndereco, "ID", "Tipo", viewModel.Tipo_EnderecoID);
            ViewBag.TiposResidencia = new SelectList(_context.TiposResidencia, "ID", "Tipo", viewModel.Tipo_ResidenciaID);
            ViewBag.TiposLogradouro = new SelectList(_context.TiposLogradouro, "ID", "Tipo", viewModel.Tipo_LogradouroID);

            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, EnderecoEdicaoViewModel viewModel)
        {
            if (id != viewModel.ID)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    var enderecoAntigo = await _context.Enderecos
                        .AsNoTracking()
                        .FirstOrDefaultAsync(e => e.ID == viewModel.ID);

                    if (enderecoAntigo == null)
                    {
                        return NotFound();
                    }

                    var endereco = await _context.Enderecos.FindAsync(id);
                    if (endereco == null)
                    {
                        return NotFound();
                    }

                    endereco.Apelido = viewModel.Apelido;
                    endereco.Tipo_EnderecoID = viewModel.Tipo_EnderecoID;
                    endereco.Tipo_ResidenciaID = viewModel.Tipo_ResidenciaID;
                    endereco.Tipo_LogradouroID = viewModel.Tipo_LogradouroID;
                    endereco.CidadeID = viewModel.CidadeID;
                    endereco.Logradouro = viewModel.Logradouro;
                    endereco.Numero = viewModel.Numero;
                    endereco.Bairro = viewModel.Bairro;
                    endereco.CEP = viewModel.CEP;
                    endereco.Observacao = viewModel.Observacao;

                    await _logService.RegistrarLog(
                        adminId: GetCurrentAdminId(),
                        tipoOperacao: "ALTERAÇÃO",
                        tabela: "Endereco",
                        registroId: endereco.ID,
                        dadosAntigos: enderecoAntigo,
                        dadosNovos: endereco
                    );

                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    throw;
                }

                return RedirectToAction("Index", "Enderecos", new { clienteId = viewModel.ClienteID });
            }

            ViewBag.Cidades = new SelectList(_context.Cidades.OrderBy(c => c.Nome), "ID", "Nome", viewModel.CidadeID);
            ViewBag.TiposEndereco = new SelectList(_context.TiposEndereco, "ID", "Tipo", viewModel.Tipo_EnderecoID);
            ViewBag.TiposResidencia = new SelectList(_context.TiposResidencia, "ID", "Tipo", viewModel.Tipo_ResidenciaID);
            ViewBag.TiposLogradouro = new SelectList(_context.TiposLogradouro, "ID", "Tipo", viewModel.Tipo_LogradouroID);
            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var enderecoParaExcluir = await _context.Enderecos
                .Include(e => e.Tipo_Endereco)
                .FirstOrDefaultAsync(e => e.ID == id);

            if (enderecoParaExcluir == null)
            {
                return NotFound();
            }

            int clienteId = enderecoParaExcluir.ClienteID;

            var todosOsEnderecosDoCliente = await _context.Enderecos
                .Where(e => e.ClienteID == clienteId)
                .ToListAsync();

            int totalEnderecosEntrega = todosOsEnderecosDoCliente.Count(e => e.Tipo_EnderecoID == 1);
            int totalEnderecosCobranca = todosOsEnderecosDoCliente.Count(e => e.Tipo_EnderecoID == 2);

            if (enderecoParaExcluir.Tipo_EnderecoID == 1 && totalEnderecosEntrega <= 1)
            {
                TempData["ErrorMessage"] = "Exclusão não permitida. O cliente deve ter pelo menos um endereço de entrega cadastrado.";
                return RedirectToAction("Index", new { clienteId = clienteId });
            }

            if (enderecoParaExcluir.Tipo_EnderecoID == 2 && totalEnderecosCobranca <= 1)
            {
                TempData["ErrorMessage"] = "Exclusão não permitida. O cliente deve ter pelo menos um endereço de cobrança cadastrado.";
                return RedirectToAction("Index", new { clienteId = clienteId });
            }

            _context.Enderecos.Remove(enderecoParaExcluir);

            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = "Endereço excluído com sucesso!";
            return RedirectToAction("Index", new { clienteId = clienteId });
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
