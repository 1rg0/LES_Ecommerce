namespace Ecommerce_Jogos.Models
{
    public class CheckoutViewModel
    {
        public CarrinhoViewModel Carrinho { get; set; }

        public List<Endereco> Enderecos { get; set; }

        public List<Cartao> Cartoes { get; set; }

        public int EnderecoSelecionadoId { get; set; }
        public List<PagamentoViewModel> PagamentosComCartao { get; set; } = new List<PagamentoViewModel>();
        public List<string> CuponsAplicados { get; set; } = new List<string>();

        public string? CupomCodigo { get; set; }
        public decimal ValorDesconto { get; set; }
    }

    public class PagamentoViewModel
    {
        public int CartaoId { get; set; }
        public decimal Valor { get; set; }
    }
}
