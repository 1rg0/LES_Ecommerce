using Ecommerce_Jogos.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Net.Http;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Linq;

namespace Ecommerce_Jogos.Controllers
{
    [Authorize]
    public class RecomendacaoController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly IConfiguration _configuration;
        private readonly HttpClient _httpClient;

        public RecomendacaoController(ApplicationDbContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
            _httpClient = new HttpClient();
        }

        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> ObterRecomendacao([FromBody] PerguntaViewModel perguntaCompleta) // Alterado para receber o novo ViewModel
        {
            var clienteId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier));

            // 1. Coletar o contexto (sem alterações aqui)
            var historicoCompras = await _context.Pedidos
                .Where(p => p.ClienteID == clienteId && p.Status == "ENTREGUE")
                .SelectMany(p => p.ItensPedido)
                .Select(ip => ip.Produto.Nome)
                .Distinct()
                .ToListAsync();

            var catalogoProdutos = await _context.Produtos
                .Where(p => p.Ativo)
                .Select(p => p.Nome)
                .ToListAsync();

            // 2. Montar o Prompt para o Gemini, agora incluindo o histórico do chat
            var apiKey = _configuration["Gemini:ApiKey"];
            var prompt = MontarPrompt(historicoCompras, catalogoProdutos, perguntaCompleta.Texto, perguntaCompleta.Historico); // Passa o histórico

            // 3. Chamar a API do Gemini (sem alterações aqui)
            var apiUrl = $"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key={apiKey}";
            var requestBody = new
            {
                contents = new[]
                {
            new { parts = new[] { new { text = prompt } } }
        }
            };

            var content = new StringContent(JsonSerializer.Serialize(requestBody), Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync(apiUrl, content);

            if (!response.IsSuccessStatusCode)
            {
                var errorContent = await response.Content.ReadAsStringAsync();
                return BadRequest($"Não foi possível obter uma recomendação no momento. Erro: {errorContent}");
            }

            // 4. Processar a resposta e retornar para o front-end (sem alterações aqui)
            var jsonResponse = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
            var iaResponseText = jsonResponse.RootElement
                                             .GetProperty("candidates")[0]
                                             .GetProperty("content")
                                             .GetProperty("parts")[0]
                                             .GetProperty("text")
                                             .GetString();

            return Ok(new { resposta = iaResponseText });
        }

        private string MontarPrompt(List<string> compras, List<string> catalogo, string pergunta, List<ChatMessage> historicoChat) // Alterado para receber o histórico
        {
            var historico = compras.Any() ? string.Join(", ", compras) : "O cliente ainda não possui compras.";
            var catalogoDisponivel = string.Join("\n- ", catalogo);

            // Constrói a parte do histórico da conversa para o prompt
            var historicoDaConversa = new StringBuilder();
            if (historicoChat != null && historicoChat.Any())
            {
                historicoDaConversa.AppendLine("\n**Histórico da Conversa Atual:**");
                foreach (var mensagem in historicoChat)
                {
                    var autor = mensagem.Role == "user" ? "Cliente" : "Assistente";
                    historicoDaConversa.AppendLine($"- {autor}: {mensagem.Text}");
                }
            }

            return $@"
                Você é um assistente especialista em vendas de jogos de um e-commerce. Sua função é dar recomendações personalizadas e manter uma conversa fluida.

                **Regras:**
                - Seja amigável, direto e prestativo.
                - Responda apenas sobre jogos. Se o usuário perguntar sobre outro assunto (ex: status do pedido, devoluções), diga educadamente que você só pode ajudar com recomendações de jogos e sugira que ele procure a seção apropriada do site.
                - Baseie suas recomendações no histórico de compras do cliente, no catálogo de produtos disponíveis e no histórico da conversa atual.
                - **IMPORTANTE:** Recomende APENAS jogos que estão na lista 'Catálogo de Produtos Disponíveis' abaixo.
                - Mantenha as respostas curtas, com no máximo 3 frases.

                **Contexto do Cliente:**
                - Histórico de Compras: {historico}

                **Catálogo de Produtos Disponíveis:**
                - {catalogoDisponivel}
                {historicoDaConversa}
                **Nova Pergunta do Cliente:**
                '{pergunta}'
            ";
        }
    }

    public class ChatMessage
    {
        public string Role { get; set; }
        public string Text { get; set; }
    }

    public class PerguntaViewModel
    {
        public string Texto { get; set; }
        public List<ChatMessage> Historico { get; set; }
    }
}