using System.ComponentModel.DataAnnotations;

namespace Ecommerce_Jogos.Models
{
    public class ProdutoEditViewModel
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "O título do jogo é obrigatório")]
        [Display(Name = "Título do Jogo")]
        public string Nome { get; set; }

        [Display(Name = "Sinopse")]
        public string? Sinopse { get; set; }

        [Required(ErrorMessage = "A plataforma é obrigatória")]
        [Display(Name = "Plataforma")]
        public int PlataformaID { get; set; }

        [Required(ErrorMessage = "O ano de lançamento é obrigatório")]
        [Display(Name = "Ano de Lançamento")]
        [Range(1970, 2027, ErrorMessage = "O ano de lançamento deve ser um valor válido.")]
        public int AnoLancamento { get; set; }

        [Required(ErrorMessage = "A desenvolvedora do jogo é obrigatória")]
        [Display(Name = "Desenvolvedora")]
        public int DesenvolvedoraID { get; set; }

        [Required(ErrorMessage = "A publicadora do jogo é obrigatória")]
        [Display(Name = "Publicadora")]
        public int PublicadoraID { get; set; }

        [Display(Name = "Edição")]
        public string? Edicao { get; set; }

        [Display(Name = "URL da Imagem da Capa")]
        [Url(ErrorMessage = "A URL fornecida não é válida.")]
        public string? URLImagem { get; set; }

        [Required(ErrorMessage = "A altura do produto é obrigatória")]
        [Display(Name = "Altura (cm)")]
        public string AlturaCm { get; set; }

        [Required(ErrorMessage = "A largura do produto é obrigatória")]
        [Display(Name = "Largura (cm)")]
        public string LarguraCm { get; set; }

        [Required(ErrorMessage = "A profundida do produto é obrigatória")]
        [Display(Name = "Profundidade (cm)")]
        public string ProfundidadeCm { get; set; }

        [Required(ErrorMessage = "O peso do produto é obrigatório")]
        [Display(Name = "Peso (gramas)")]
        public string PesoGramas { get; set; }

        [Required(ErrorMessage = "Selecione ao menos uma categoria.")]
        public List<int> CategoriaIDs { get; set; } = new List<int>();

        [Required(ErrorMessage = "O grupo de precificação é obrigatório")]
        [Display(Name = "Grupo de Precificação")]
        public int GrupoPrecificacaoID { get; set; }

        [Required(ErrorMessage = "O código de barras é obrigatório")]
        [Display(Name = "Código de Barras")]
        public string CodigoBarras { get; set; }

        [Required(ErrorMessage = "O preço de custo é obrigatório.")]
        [Display(Name = "Preço de Custo")]
        public string PrecoCusto { get; set; }

        [Required(ErrorMessage = "O preço de venda é obrigatório.")]
        [Display(Name = "Preço de Venda")]
        public string PrecoVenda { get; set; }

        public bool UsuarioIsGerente { get; set; }
        public decimal MargemLucro { get; set; }
    }
}