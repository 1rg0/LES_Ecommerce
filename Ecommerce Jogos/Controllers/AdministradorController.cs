using Ecommerce_Jogos.Data;
using Ecommerce_Jogos.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Ecommerce_Jogos.Controllers
{
    public class AdministradorController : Controller
    {
        private readonly ApplicationDbContext _context;

        public AdministradorController(ApplicationDbContext context)
        {
            _context = context;
        }

        public IActionResult AlterarSenha(int id)
        {
            var viewModel = new AlterarSenhaViewModel
            {
                ClienteID = id // Usamos o mesmo ViewModel, então o nome é ClienteID
            };
            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AlterarSenha(AlterarSenhaViewModel viewModel)
        {
            if (!ModelState.IsValid)
            {
                return View(viewModel);
            }

            var admin = await _context.Administradores.FindAsync(1);
            if (admin == null)
            {
                return NotFound();
            }

            if (!BCrypt.Net.BCrypt.Verify(viewModel.SenhaAtual, admin.SenhaHash))
            {
                ModelState.AddModelError("SenhaAtual", "A senha atual está incorreta.");
                return View(viewModel);
            }


            admin.SenhaHash = BCrypt.Net.BCrypt.HashPassword(viewModel.NovaSenha);

            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = "Senha alterada com sucesso!";

            return RedirectToAction("Catalogo", "Produtos");
        }
    }
}