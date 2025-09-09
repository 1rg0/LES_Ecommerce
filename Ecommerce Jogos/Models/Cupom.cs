using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ecommerce_Jogos.Models
{
    public class Cupom
    {
        public int ID { get; set; }

        [Required(ErrorMessage = "O código do cupom é obrigatório.")]
        [StringLength(50)]
        public string Codigo { get; set; }

        [Required(ErrorMessage = "O tipo do cupom é obrigatório.")]
        [StringLength(20)]
        public string Tipo { get; set; }

        [Required]
        [Column(TypeName = "decimal(10, 2)")]
        public decimal Valor { get; set; }

        public DateTime DataCriacao { get; set; }

        public DateTime? DataValidade { get; set; }

        public bool Ativo { get; set; } = true;

        public int? ClienteID { get; set; }

        public int? PedidoOrigemID { get; set; }

        public int? PedidoUsoID { get; set; }


        public virtual Cliente Cliente { get; set; }

        public virtual Pedido PedidoOrigem { get; set; }

        public virtual Pedido PedidoUso { get; set; }
    }
}