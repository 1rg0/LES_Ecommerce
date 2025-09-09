namespace Ecommerce_Jogos.Models
{
    public class GrupoPrecificacao
    {
        public int ID { get; set; }
        public required string Nome { get; set; }
        public decimal MargemLucro { get; set; }
    }
}
