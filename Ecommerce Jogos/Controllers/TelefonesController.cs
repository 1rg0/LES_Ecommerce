using Ecommerce_Jogos.Data;
using Ecommerce_Jogos.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace Ecommerce_Jogos.Controllers
{
    public class TelefonesController : Controller
    {
        private readonly ApplicationDbContext _context;

        public TelefonesController(ApplicationDbContext context)
        {
            _context = context;
        }

        public IActionResult Create(int clienteId)
        {

            var cliente = _context.Clientes.Find(clienteId);
            if (cliente == null)
            {
                return NotFound();
            }

            var listaDeTipos = _context.TiposTelefone.ToList();
            var viewModel = new TelefoneCadastroViewModel
            {
                ClienteID = cliente.Id,
                ClienteNome = cliente.NomeCompleto
            };

            ViewBag.TiposTelefone = new SelectList(listaDeTipos, "ID", "Tipo");

            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(TelefoneCadastroViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                var novoTelefone = new Telefone
                {
                    ClienteID = viewModel.ClienteID,
                    Tipo_TelefoneID = viewModel.Tipo_TelefoneID,
                    DDD = viewModel.DDD,
                    Numero = viewModel.Numero
                };

                _context.Telefones.Add(novoTelefone);
                await _context.SaveChangesAsync();

                return RedirectToAction("Create", "Enderecos", new { clienteId = viewModel.ClienteID });
            }

            ViewBag.TiposTelefone = new SelectList(_context.TiposTelefone, "ID", "Tipo", viewModel.Tipo_TelefoneID);
            return View(viewModel);
        }
    }
}