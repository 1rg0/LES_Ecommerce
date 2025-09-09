using Microsoft.AspNetCore.Mvc.Rendering;

namespace Ecommerce_Jogos.Models
{
    public class CatalogoViewModel
    {
        public List<Produto> Produtos { get; set; }

        public SelectList Plataformas { get; set; }
        public List<Categoria> Categorias { get; set; }

        public string? SearchString { get; set; }
        public int? PlataformaId { get; set; }
        public int[]? CategoriaIds { get; set; }
    }
}
