namespace Ecommerce_Jogos.Models
{
    public class Administrador
    {
        public int Id { get; set; }
        public required string NomeCompleto { get; set; }
        public required string Email { get; set; }
        public required string SenhaHash { get; set; }
        public required string Funcao { get; set; }
    }
}
