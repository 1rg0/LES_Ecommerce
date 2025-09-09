namespace Ecommerce_Jogos.Models
{
    public class Fornecedor
    {
        public int ID { get; set; }
        public required string Nome { get; set; }
        public required string CNPJ { get; set; }
        public required string EmailContato { get; set; }
    }
}
