using Ecommerce_Jogos.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using System.Threading.Tasks;

namespace Ecommerce_Jogos.Controllers
{
    [Authorize]
    public class NotificacoesController : Controller
    {
        private readonly ApplicationDbContext _context;

        public NotificacoesController(ApplicationDbContext context)
        {
            _context = context;
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> MarcarComoLida([FromBody] int id)
        {
            var clienteIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (clienteIdClaim == null || !int.TryParse(clienteIdClaim.Value, out int clienteId))
            {
                return Unauthorized();
            }

            var notificacao = await _context.Notificacoes.FindAsync(id);

            if (notificacao == null || notificacao.ClienteID != clienteId)
            {
                return NotFound();
            }

            if (!notificacao.Lida)
            {
                notificacao.Lida = true;
                await _context.SaveChangesAsync();
            }

            return Ok(new { success = true });
        }
    }
}