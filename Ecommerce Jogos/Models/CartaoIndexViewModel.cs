using System.Collections.Generic;

namespace Ecommerce_Jogos.Models
{
    public class CartaoIndexViewModel
    {
        public int ClienteID { get; set; }
        public string ClienteNome { get; set; }
        public List<Cartao> Cartoes { get; set; }
    }
}