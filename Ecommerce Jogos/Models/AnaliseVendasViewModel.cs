using Microsoft.AspNetCore.Mvc.Rendering;

namespace Ecommerce_Jogos.Models
{
    public class AnaliseVendasViewModel
    {
        public List<SelectListItem> Produtos { get; set; } = new List<SelectListItem>();
        public List<SelectListItem> Categorias { get; set; } = new List<SelectListItem>();
    }
}
