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
            // Pega o HttpContext atual
            var httpContext = _httpContextAccessor.HttpContext;

            // Verifica se o usuário está autenticado
            if (httpContext.User.Identity.IsAuthenticated)
            {
                // Pega o ID do cliente a partir das claims
                var clienteIdClaim = httpContext.User.FindFirst(ClaimTypes.NameIdentifier);

                if (clienteIdClaim != null && int.TryParse(clienteIdClaim.Value, out int clienteId))
                {
                    // Busca as 5 notificações mais recentes não lidas para o cliente
                    var notificacoes = await _context.Notificacoes
                        .Where(n => n.ClienteID == clienteId && !n.Lida)
                        .OrderByDescending(n => n.DataCriacao)
                        .Take(5)
                        .ToListAsync();

                    return View(notificacoes);
                }
            }

            // Se o usuário não estiver logado ou não for um cliente, retorna uma view vazia
            return View(new List<Notificacao>());
        }
    }
}