namespace Ecommerce_Jogos.Models
{
    public class ItemPedido
    {
        public int Quantidade { get; set; }
        public decimal PrecoUnitario { get; set; }

        public int PedidoID { get; set; }
        public Pedido? Pedido { get; set; }

        public int ProdutoID { get; set; }
        public Produto? Produto { get; set; }
    }
}
