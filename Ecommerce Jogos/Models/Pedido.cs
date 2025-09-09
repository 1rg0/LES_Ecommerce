namespace Ecommerce_Jogos.Models
{
    public class Pedido
    {
        public int ID { get; set; }
        public DateTime DataPedido { get; set; }
        public decimal ValorTotal { get; set; }
        public required string Status { get; set; }

        public int ClienteID { get; set; }
        public virtual Cliente Cliente { get; set; }

        public int EnderecoID { get; set; }
        public virtual Endereco Endereco { get; set; }

        public virtual List<ItemPedido> ItensPedido { get; set; } = new List<ItemPedido>();
        public virtual ICollection<Troca> Trocas { get; set; } = new List<Troca>();
    }
}
