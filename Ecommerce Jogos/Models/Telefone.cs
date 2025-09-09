namespace Ecommerce_Jogos.Models
{
    public class Telefone
    {
        public int ID { get; set; }
        public required string DDD { get; set; }
        public required string Numero { get; set; }

        public int ClienteID { get; set; }
        public Cliente? Cliente { get; set; }

        public int Tipo_TelefoneID { get; set; }
        public TipoTelefone? Tipo_Telefone { get; set; }
    }
}
