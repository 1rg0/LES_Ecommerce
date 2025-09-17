using Ecommerce_Jogos.Data;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;

namespace Ecommerce_Jogos.Services
{
    public class RankingService
    {
        private readonly ApplicationDbContext _context;

        public RankingService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task AtualizarRankingCliente(int clienteId)
        {
            var cliente = await _context.Clientes.FindAsync(clienteId);
            if (cliente == null)
            {
                return;
            }

            var pedidosEntregues = await _context.Pedidos
                .Where(p => p.ClienteID == clienteId && p.Status == "ENTREGUE")
                .ToListAsync();

            if (!pedidosEntregues.Any())
            {
                cliente.Ranking = 0;
                await _context.SaveChangesAsync();
                return;
            }

            int pontosPorPedidos = pedidosEntregues.Count * 10;

            decimal valorTotalGasto = pedidosEntregues.Sum(p => p.ValorTotal);
            int pontosPorValor = (int)(valorTotalGasto / 10);

            cliente.Ranking = pontosPorPedidos + pontosPorValor;

            await _context.SaveChangesAsync();
        }
    }
}