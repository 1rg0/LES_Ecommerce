using Ecommerce_Jogos.Data;
using Ecommerce_Jogos.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace Ecommerce_Jogos.Services
{
    public class EstoqueService
    {
        private readonly ApplicationDbContext _context;
        private readonly IConfiguration _configuration;

        public EstoqueService(ApplicationDbContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        public async Task<int> GetEstoqueDisponivel(int produtoId)
        {
            await LimparBloqueiosExpirados();

            var totalEntradas = await _context.EntradasEstoque
                .Where(e => e.ProdutoID == produtoId)
                .SumAsync(e => (int?)e.Quantidade) ?? 0;

            var totalBloqueado = await _context.EstoquesBloqueados
                .Where(b => b.ProdutoID == produtoId)
                .SumAsync(b => (int?)b.QuantidadeBloqueada) ?? 0;

            return totalEntradas - totalBloqueado;
        }

        public async Task<bool> CriarBloqueio(int produtoId, int quantidade, int? clienteId, string sessaoId)
        {
            var estoqueDisponivel = await GetEstoqueDisponivel(produtoId);
            if (quantidade > estoqueDisponivel)
            {
                return false;
            }

            var tempoExpiracao = _configuration.GetValue<int>("CarrinhoSettings:TempoExpiracaoMinutos");

            var novoBloqueio = new EstoqueBloqueado
            {
                ProdutoID = produtoId,
                QuantidadeBloqueada = quantidade,
                ClienteID = clienteId,
                SessaoId = sessaoId,
                DataBloqueio = DateTime.Now,
                DataExpiracao = DateTime.Now.AddMinutes(tempoExpiracao)
            };

            _context.EstoquesBloqueados.Add(novoBloqueio);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task LiberarBloqueios(int? clienteId, string sessaoId)
        {
            var bloqueiosParaRemover = await _context.EstoquesBloqueados
                .Where(b => (clienteId.HasValue && b.ClienteID == clienteId) || b.SessaoId == sessaoId)
                .ToListAsync();

            if (bloqueiosParaRemover.Any())
            {
                _context.EstoquesBloqueados.RemoveRange(bloqueiosParaRemover);
                await _context.SaveChangesAsync();
            }
        }

        private async Task LimparBloqueiosExpirados()
        {
            var bloqueiosExpirados = await _context.EstoquesBloqueados
                .Where(b => b.DataExpiracao < DateTime.Now)
                .ToListAsync();

            if (bloqueiosExpirados.Any())
            {
                _context.EstoquesBloqueados.RemoveRange(bloqueiosExpirados);
                await _context.SaveChangesAsync();
            }
        }
    }
}