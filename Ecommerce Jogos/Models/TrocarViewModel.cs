using System.ComponentModel.DataAnnotations;

namespace Ecommerce_Jogos.Models
{
    public class TrocarViewModel
    {

    }
    public class SolicitarTrocaViewModel
    {
        public int PedidoId { get; set; }
        public List<ItemParaTrocaViewModel> ItensParaTroca { get; set; } = new List<ItemParaTrocaViewModel>();

        [Required(ErrorMessage = "O motivo da troca é obrigatório.")]
        [MinLength(10, ErrorMessage = "Por favor, detalhe um pouco mais o motivo da troca.")]
        public string Motivo { get; set; }

        public List<string> ItensSelecionados { get; set; } = new List<string>();
    }

    public class ItemParaTrocaViewModel
    {
        public int ProdutoId { get; set; }
        public string NomeProduto { get; set; }
        public string UrlImagem { get; set; }
        public string ItemPedidoChave { get; set; }
    }
}
