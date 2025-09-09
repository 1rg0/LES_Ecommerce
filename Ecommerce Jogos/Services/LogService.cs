using Ecommerce_Jogos.Data;
using Ecommerce_Jogos.Models;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace Ecommerce_Jogos.Services
{
    public class LogService
    {
        private readonly ApplicationDbContext _context;

        public LogService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task RegistrarLog(int? adminId, string tipoOperacao, string tabela, int registroId, object? dadosAntigos, object? dadosNovos, string? motivo = null)
        {
            var options = new JsonSerializerOptions
            {
                ReferenceHandler = ReferenceHandler.IgnoreCycles,
                WriteIndented = false
            };

            var log = new LogTransacoes
            {
                DataHoraOcorrencia = DateTime.Now,
                AdministradorID = adminId,
                TipoOperacao = tipoOperacao,
                TabelaAfetada = tabela,
                RegistroID = registroId,
                DadosAntigos = dadosAntigos != null ? JsonSerializer.Serialize(dadosAntigos, options) : null,
                DadosNovos = dadosNovos != null ? JsonSerializer.Serialize(dadosNovos, options) : null,
                Motivo = motivo
            };

            _context.LogTransacoes.Add(log);
        }
    }
}