using System.ComponentModel.DataAnnotations;

namespace Ecommerce_Jogos.Models
{
    public class CartaoCadastroViewModel
    {
        public int ClienteID { get; set; }
        public string? ClienteNome { get; set; }

        [Required(ErrorMessage = "O número do cartão é obrigatório")]
        [Display(Name = "Número do Cartão")]
        [RegularExpression(@"^(\s*\d\s*){16}$", ErrorMessage = "O número do cartão deve conter exatamente 16 dígitos.")]
        public string NumeroCartao { get; set; }

        [Required(ErrorMessage = "O nome impresso no cartão é obrigatório")]
        [Display(Name = "Nome Impresso no Cartão")]
        public string NomeImpresso { get; set; }

        [Required(ErrorMessage = "A data de validade é obrigatória")]
        [Display(Name = "Data de Validade")]
        [RegularExpression(@"^(0[1-9]|1[0-2])\/\d{4}$", ErrorMessage = "Formato inválido. Use MM/AAAA.")]
        public string DataValidade { get; set; }

        [Required(ErrorMessage = "A bandeira é obrigatória")]
        public string Bandeira { get; set; }

        [Required(ErrorMessage = "O código de segurança é obrigatório")]
        [Display(Name = "Código de Segurança (CVV)")]
        public string CodigoSeguranca { get; set; }

        [Display(Name = "Definir como cartão preferencial")]
        public bool Preferencial { get; set; }
    }
}
