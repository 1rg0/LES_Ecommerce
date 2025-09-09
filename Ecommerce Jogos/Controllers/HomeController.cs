using System.Diagnostics;
using Ecommerce_Jogos.Models;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace Ecommerce_Jogos.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            if (User.Identity.IsAuthenticated)
            {
                var userType = User.FindFirst("UserType")?.Value;

                if (userType == "Administrador")
                {
                    return RedirectToAction("Index", "Clientes");
                }
            }
            return RedirectToAction("Catalogo", "Produtos");
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
