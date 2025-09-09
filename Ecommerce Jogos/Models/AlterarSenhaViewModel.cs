using System.ComponentModel.DataAnnotations;

namespace Ecommerce_Jogos.Models
{
    public class AlterarSenhaViewModel
    {
        public int ClienteID { get; set; }

        [Required(ErrorMessage = "A senha atual é obrigatória.")]
        [DataType(DataType.Password)]
        [Display(Name = "Senha Atual")]
        public string SenhaAtual { get; set; }

        [Required(ErrorMessage = "A nova senha é obrigatória.")]
        [DataType(DataType.Password)]
        [Display(Name = "Nova Senha")]
        [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$",
            ErrorMessage = "A senha deve ter no mínimo 8 caracteres, contendo letras maiúsculas, minúsculas, números e um caractere especial.")]
        public string NovaSenha { get; set; }

        [DataType(DataType.Password)]
        [Display(Name = "Confirmar Nova Senha")]
        [Compare("NovaSenha", ErrorMessage = "A nova senha e a confirmação não conferem.")]
        public string ConfirmarNovaSenha { get; set; }
    }
}