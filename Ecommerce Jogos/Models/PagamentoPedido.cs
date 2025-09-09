namespace Ecommerce_Jogos.Models
{
    public class PagamentoPedido
    {
        public int ID { get; set; }
        public int PedidoID { get; set; }
        public int CartaoID { get; set; }

        public decimal ValorPago { get; set; }

        public virtual Pedido Pedido { get; set; }
        public virtual Cartao Cartao { get; set; }
    }
}
