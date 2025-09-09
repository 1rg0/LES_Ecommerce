namespace Ecommerce_Jogos.Models
{
    public class Cidade
    {
        public int ID { get; set; }
        public required Estado Estado { get; set; }
        public required string Nome { get; set; }
    }
}
