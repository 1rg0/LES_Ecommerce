using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;

namespace Ecommerce_Jogos.Models
{
    public class ClienteEdicaoViewModel
    {
        public int ClienteID { get; set; }
        public int EnderecoID { get; set; }
        public int TelefoneID { get; set; }

        [Required(ErrorMessage = "O nome é obrigatório!")]
        [Display(Name = "Nome Completo")]
        public string NomeCompleto { get; set; }

        [Required(ErrorMessage = "O CPF é obrigatório!")]
        [Display(Name = "CPF")]
        public string CPF { get; set; }

        [Required(ErrorMessage = "O gênero é obrigatório!")]
        [Display(Name = "Gênero")]
        public string Genero { get; set; }

        [Required(ErrorMessage = "A data de nascimento é obrigatória!")]
        [DataType(DataType.Date)]
        [Display(Name = "Data de Nascimento")]
        public DateTime DataNascimento { get; set; }

        [Required(ErrorMessage = "O tipo de telefone é obrigatório!")]
        [Display(Name = "Tipo de Telefone")]
        public int Tipo_TelefoneID { get; set; }

        [Required(ErrorMessage = "O DDD é obrigatório!")]
        [Display(Name = "DDD")]
        public string DDD { get; set; }

        [Required(ErrorMessage = "O número de telefone é obrigatório!")]
        [Display(Name = "Número de Telefone")]
        public string NumeroTelefone { get; set; }

        [Required(ErrorMessage = "O e-mail é obrigatório!")]
        [EmailAddress]
        [Display(Name = "E-mail")]
        public string Email { get; set; }


        [Required(ErrorMessage = "O apelido é obrigatório!")]
        [Display(Name = "Apelido")]
        public string Apelido { get; set; }

        [Required(ErrorMessage = "O tipo de endereço é obrigatório!")]
        [Display(Name = "Tipo de Endereço")]
        public int Tipo_EnderecoID { get; set; }

        [Required(ErrorMessage = "O tipo de residência é obrigatório!")]
        [Display(Name = "Tipo de Residência")]
        public int Tipo_ResidenciaID { get; set; }

        [Required(ErrorMessage = "O tipo de logradouro é obrigatório!")]
        [Display(Name = "Tipo de Logradouro")]
        public int Tipo_LogradouroID { get; set; }

        [Required(ErrorMessage = "A cidade é obrigatória!")]
        [Display(Name = "Cidade")]
        public int CidadeID { get; set; }

        [Required(ErrorMessage = "O CEP é obrigatório!")]
        [Display(Name = "CEP")]
        [StringLength(9, MinimumLength = 9, ErrorMessage = "O CEP deve ter exatamente 8 dígitos.")]
        public string CEP { get; set; }

        [Required(ErrorMessage = "O logradouro é obrigatório!")]
        [Display(Name = "Logradouro")]
        public string Logradouro { get; set; }

        [Required(ErrorMessage = "O número é obrigatório!")]
        [Display(Name = "Número")]
        public string Numero { get; set; }

        [Required(ErrorMessage = "O bairro é obrigatório!")]
        [Display(Name = "Bairro")]
        public string Bairro { get; set; }

        [Display(Name = "Observações (Complemento)")]
        public string? Observacao { get; set; }
    }
}
