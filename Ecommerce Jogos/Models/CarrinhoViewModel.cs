namespace Ecommerce_Jogos.Models
{
    public class CarrinhoItemViewModel
    {
        public int ProdutoId { get; set; }
        public string NomeProduto { get; set; }
        public int Quantidade { get; set; }
        public decimal PrecoUnitario { get; set; }
        public string UrlImagem { get; set; }
        public decimal Subtotal => Quantidade * PrecoUnitario;
    }

    public class CarrinhoViewModel
    {
        public List<CarrinhoItemViewModel> Itens { get; set; } = new List<CarrinhoItemViewModel>();
        public decimal Total => Itens.Sum(i => i.Subtotal);
    }
}
