using System.ComponentModel.DataAnnotations;

namespace Ecommerce_Jogos.Models
{
    public class TelefoneCadastroViewModel
    {
        public int ClienteID { get; set; }

        [Display(Name = "Cliente")]
        public string? ClienteNome { get; set; }

        [Required(ErrorMessage = "O tipo de telefone é obrigatório")]
        [Display(Name = "Tipo de Telefone")]
        public int Tipo_TelefoneID { get; set; }

        [Required(ErrorMessage = "O DDD é obrigatório")]
        [StringLength(2, MinimumLength = 2, ErrorMessage = "O DDD deve ter 2 dígitos")]
        public string DDD { get; set; }

        [Required(ErrorMessage = "O número é obrigatório")]
        [StringLength(9, MinimumLength = 8, ErrorMessage = "O número deve ter entre 8 e 9 dígitos")]
        [Display(Name = "Número")]
        public string Numero { get; set; }
    }
}
