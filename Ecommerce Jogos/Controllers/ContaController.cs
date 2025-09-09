using Ecommerce_Jogos.Data;
using Ecommerce_Jogos.Models;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using BCrypt.Net;

namespace Ecommerce_Jogos.Controllers
{
    public class ContaController : Controller
    {
        private readonly ApplicationDbContext _context;

        public ContaController(ApplicationDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Login(string returnUrl = "/")
        {
            ViewData["ReturnUrl"] = returnUrl;
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel viewModel, string returnUrl = "/")
        {
            if (!ModelState.IsValid)
            {
                return View(viewModel);
            }
            var claims = new List<Claim>();
            bool loginValido = false;

            var cliente = await _context.Clientes
                                        .FirstOrDefaultAsync(c => c.Email == viewModel.Email);

            if (cliente != null && BCrypt.Net.BCrypt.Verify(viewModel.Senha, cliente.SenhaHash))
            {
                claims.Add(new Claim(ClaimTypes.Name, cliente.Email));
                claims.Add(new Claim("FullName", cliente.NomeCompleto));
                claims.Add(new Claim(ClaimTypes.NameIdentifier, cliente.Id.ToString()));
                claims.Add(new Claim("UserType", "Cliente"));
                loginValido = true;
            }

            if (!loginValido)
            {
                var administrador = await _context.Administradores
                                                .FirstOrDefaultAsync(a => a.Email == viewModel.Email);

                if (administrador != null && BCrypt.Net.BCrypt.Verify(viewModel.Senha, administrador.SenhaHash))
                {
                    claims.Add(new Claim(ClaimTypes.Name, administrador.Email));
                    claims.Add(new Claim("FullName", administrador.NomeCompleto));
                    claims.Add(new Claim(ClaimTypes.NameIdentifier, administrador.Id.ToString()));
                    claims.Add(new Claim("UserType", "Administrador"));
                    claims.Add(new Claim(ClaimTypes.Role, administrador.Funcao));
                    loginValido = true;
                }
            }

            if (loginValido)
            {
                var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                var authProperties = new AuthenticationProperties
                {
                    IsPersistent = viewModel.LembrarMe,
                    ExpiresUtc = DateTimeOffset.UtcNow.AddMinutes(30)
                };

                await HttpContext.SignInAsync(
                    CookieAuthenticationDefaults.AuthenticationScheme,
                    new ClaimsPrincipal(claimsIdentity),
                    authProperties);

                return LocalRedirect(returnUrl);
            }

            ModelState.AddModelError(string.Empty, "E-mail ou senha inválidos. Tente novamente.");
            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("Index", "Home");
        }

    }
}
