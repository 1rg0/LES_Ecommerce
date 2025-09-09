namespace Ecommerce_Jogos.Models
{
    public class Cartao
    {
        public int ID { get; set; }
        public required string NomeImpresso { get; set; }
        public  required string UltimosQuatroDigitos { get; set; }
        public required string DataValidade { get; set; }
        public required string Bandeira { get; set; }
        public bool Preferencial { get; set; }

        public int ClienteID { get; set; }
        public Cliente? Cliente { get; set; }
    }
}
