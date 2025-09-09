using System.ComponentModel.DataAnnotations;

namespace Ecommerce_Jogos.Models
{
    public class EnderecoEdicaoViewModel
    {
        public int ID { get; set; }
        public int ClienteID { get; set; }

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

        [Required(ErrorMessage = "O logradouro é obrigatório!")]
        [Display(Name = "Logradouro")]
        public string Logradouro { get; set; }

        [Required(ErrorMessage = "O número é obrigatório!")]
        [Display(Name = "Número")]
        public string Numero { get; set; }

        [Required(ErrorMessage = "O bairro é obrigatório!")]
        [Display(Name = "Bairro")]
        public string Bairro { get; set; }

        [Required(ErrorMessage = "O CEP é obrigatório!")]
        [Display(Name = "CEP")]
        [StringLength(9, MinimumLength = 9, ErrorMessage = "O CEP deve ter exatamente 8 dígitos.")]
        public string CEP { get; set; }

        [Display(Name = "Observações (Complemento)")]
        public string? Observacao { get; set; }
    }
}
