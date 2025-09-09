namespace Ecommerce_Jogos.Models
{
    public class ItemTroca
    {
        public int TrocaID { get; set; }
        public int ItemPedidoPedidoID { get; set; }
        public int ItemPedidoProdutoID { get; set; }
        public virtual Troca Troca { get; set; }
        public virtual ItemPedido ItemPedido { get; set; }
    }
}
