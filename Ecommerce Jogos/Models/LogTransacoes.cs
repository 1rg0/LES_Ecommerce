using System.ComponentModel.DataAnnotations;

namespace Ecommerce_Jogos.Models
{
    public class LogTransacoes
    {
        public int ID { get; set; }

        public DateTime DataHoraOcorrencia { get; set; }

        public int? AdministradorID { get; set; }

        [Required]
        [StringLength(20)]
        public required string TipoOperacao { get; set; }

        [Required]
        [StringLength(100)]
        public required string TabelaAfetada { get; set; }

        public int RegistroID { get; set; }

        public string? DadosAntigos { get; set; }

        public required string DadosNovos { get; set; }

        [StringLength(255)]
        public string? Motivo { get; set; }

        public virtual Administrador? Administrador { get; set; }
    }
}
