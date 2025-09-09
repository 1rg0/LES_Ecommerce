using System.ComponentModel.DataAnnotations;

namespace Ecommerce_Jogos.Models
{
    public class TrocarViewModel
    {

    }
    // Arquivo: Models/TrocaViewModel.cs
    public class SolicitarTrocaViewModel
    {
        public int PedidoId { get; set; }
        public List<ItemParaTrocaViewModel> ItensParaTroca { get; set; } = new List<ItemParaTrocaViewModel>();

        [Required(ErrorMessage = "O motivo da troca é obrigatório.")]
        [MinLength(10, ErrorMessage = "Por favor, detalhe um pouco mais o motivo da troca.")]
        public string Motivo { get; set; }

        // Guarda os IDs dos itens que o cliente selecionou
        public List<string> ItensSelecionados { get; set; } = new List<string>();
    }

    public class ItemParaTrocaViewModel
    {
        public int ProdutoId { get; set; }
        public string NomeProduto { get; set; }
        public string UrlImagem { get; set; }
        // Usamos uma string para a chave composta "PedidoId_ProdutoId"
        public string ItemPedidoChave { get; set; }
    }
}
