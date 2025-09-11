namespace Ecommerce_Jogos.Models
{
    public class Notificacao
    {
        public int Id { get; set; }
        public int ClienteID { get; set; }
        public string Mensagem { get; set; }
        public string? Url { get; set; }
        public DateTime DataCriacao { get; set; }
        public bool Lida { get; set; }

        public virtual Cliente Cliente { get; set; }
    }
}
