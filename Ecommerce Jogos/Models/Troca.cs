namespace Ecommerce_Jogos.Models
{
    public class Troca
    {
        public int ID { get; set; }
        public int PedidoID { get; set; }
        public int ClienteID { get; set; }
        public DateTime DataSolicitacao { get; set; }
        public string Motivo { get; set; }
        public string StatusTroca { get; set; }
        public virtual Pedido Pedido { get; set; }
        public virtual Cliente Cliente { get; set; }
        public virtual ICollection<ItemTroca> ItensTroca { get; set; } = new List<ItemTroca>();
    }
}
