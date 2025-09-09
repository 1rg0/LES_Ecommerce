namespace Ecommerce_Jogos.Models
{
    public class Estado
    {
        public int ID { get; set; }
        public required Pais Pais { get; set; }
        public required string Nome { get; set; }
        public required string UF { get; set; }

    }
}
