using System;
using System.ComponentModel.DataAnnotations;

namespace Ecommerce_Jogos.Models
{
    public class EstoqueBloqueado
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int ProdutoID { get; set; }
        public virtual Produto Produto { get; set; }

        public int? ClienteID { get; set; }
        public virtual Cliente Cliente { get; set; }

        [MaxLength(100)]
        public string SessaoId { get; set; }

        [Required]
        public int QuantidadeBloqueada { get; set; }

        [Required]
        public DateTime DataBloqueio { get; set; }

        [Required]
        public DateTime DataExpiracao { get; set; }
    }
}