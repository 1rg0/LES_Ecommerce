using System.ComponentModel.DataAnnotations;

namespace Ecommerce_Jogos.Models
{
    public class ClienteFormViewModel
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "O nome é obrigatório")]
        [Display(Name = "Nome Completo")]
        public string NomeCompleto { get; set; }

        [Required(ErrorMessage = "O CPF é obrigatório")]
        public string CPF { get; set; }

        [Required(ErrorMessage = "O gênero é obrigatório")]
        public string Genero { get; set; }

        [Required(ErrorMessage = "A data de nascimento é obrigatória")]
        [Display(Name = "Data de Nascimento")]
        [DataType(DataType.Date)]
        public DateTime DataNascimento { get; set; }

        [Required(ErrorMessage = "O tipo de telefone é obrigatório")]
        [Display(Name = "Tipo de Telefone")]
        public int Tipo_TelefoneID { get; set; }

        [Required(ErrorMessage = "O DDD é obrigatório")]
        [StringLength(2, MinimumLength = 2, ErrorMessage = "O DDD deve ter 2 dígitos")]
        public string DDD { get; set; }

        [Required(ErrorMessage = "O número é obrigatório")]
        [Display(Name = "Número")]
        [StringLength(10, MinimumLength = 10, ErrorMessage = "O número deve ter entre 9 dígitos")]
        public string Numero { get; set; }

        [Required(ErrorMessage = "O e-mail é obrigatório")]
        [EmailAddress(ErrorMessage = "Formato de e-mail inválido")]
        public string Email { get; set; }

        [Required(ErrorMessage = "A senha é obrigatória")]
        [DataType(DataType.Password)]
        [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$",
            ErrorMessage = "A senha deve ter no mínimo 8 caracteres, contendo letras maiúsculas, minúsculas, números e um caractere especial.")]
        public string Senha { get; set; }

        [Required(ErrorMessage = "A confirmação de senha é obrigatória")]
        [Display(Name = "Confirmar Senha")]
        [DataType(DataType.Password)]
        [Compare("Senha", ErrorMessage = "As senhas não conferem.")]
        public string ConfirmarSenha { get; set; }

        public List<Endereco> Enderecos { get; set; } = new List<Endereco>();
        public List<Cartao> Cartoes { get; set; } = new List<Cartao>();
    }
}