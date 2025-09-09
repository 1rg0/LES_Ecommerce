using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ecommerce_Jogos.Models
{
    public class Cliente
    {
        public int Id { get; set; }
        public required string NomeCompleto { get; set; }
        public required string CPF { get; set; }
        public required string Genero { get; set; }
        public DateTime DataNascimento { get; set; }
        public required string Email { get; set; }
        public required string SenhaHash { get; set; }
        public bool Ativo { get; set; }
        public int? Ranking { get; set; }

        public ICollection<Endereco> Enderecos { get; set; }
        public ICollection<Telefone> Telefones { get; set; }
        public ICollection<Cartao> Cartoes { get; set; }
        public ICollection<Pedido> Pedidos { get; set; }

        public Cliente()
        {
            Enderecos = new HashSet<Endereco>();
            Telefones = new HashSet<Telefone>();
            Cartoes = new HashSet<Cartao>();
            Pedidos = new HashSet<Pedido>();
        }
    }
}
