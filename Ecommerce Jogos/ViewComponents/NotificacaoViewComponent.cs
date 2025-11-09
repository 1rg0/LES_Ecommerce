using Ecommerce_Jogos.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Linq;
using System.Collections.Generic;
using Ecommerce_Jogos.Models;

namespace Ecommerce_Jogos.ViewComponents
{
    public class NotificacaoViewComponent : ViewComponent
    {
        private readonly ApplicationDbContext _context;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public NotificacaoViewComponent(ApplicationDbContext context, IHttpContextAccessor httpContextAccessor)
        {
            _context = context;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {
            var httpContext = _httpContextAccessor.HttpContext;

            if (httpContext.User.Identity.IsAuthenticated)
            {
                var clienteIdClaim = httpContext.User.FindFirst(ClaimTypes.NameIdentifier);

                if (clienteIdClaim != null && int.TryParse(clienteIdClaim.Value, out int clienteId))
                {
                    var notificacoes = await _context.Notificacoes
                        .Where(n => n.ClienteID == clienteId && !n.Lida)
                        .OrderByDescending(n => n.DataCriacao)
                        .Take(5)
                        .ToListAsync();

                    return View(notificacoes);
                }
            }
            return View(new List<Notificacao>());
        }
    }
}