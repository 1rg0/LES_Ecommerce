using System.ComponentModel.DataAnnotations;

namespace Ecommerce_Jogos.Models
{
    public class EntradaEstoqueViewModel
    {
        [Required(ErrorMessage = "É obrigatório selecionar um produto.")]
        [Display(Name = "Produto")]
        public int ProdutoID { get; set; }

        [Required(ErrorMessage = "É obrigatório selecionar um fornecedor.")]
        [Display(Name = "Fornecedor")]
        public int FornecedorID { get; set; }

        [Required(ErrorMessage = "A quantidade é obrigatória.")]
        [Range(1, int.MaxValue, ErrorMessage = "A quantidade deve ser maior que zero.")]
        public int Quantidade { get; set; }

        [Required(ErrorMessage = "O valor de custo é obrigatório.")]
        [DataType(DataType.Currency)]
        [Display(Name = "Valor de Custo (unidade)")]
        [Range(0.01, double.MaxValue, ErrorMessage = "O valor de custo deve ser maior que zero.")]
        public decimal ValorCusto { get; set; }

        [Required(ErrorMessage = "A data de entrada é obrigatória.")]
        [DataType(DataType.Date)]
        [Display(Name = "Data de Entrada")]
        public DateTime DataEntrada { get; set; } = DateTime.Now;
    }
}
