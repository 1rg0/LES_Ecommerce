using System.Collections.Generic;

namespace Ecommerce_Jogos.Models
{
    public class EnderecoIndexViewModel
    {
        public int ClienteID { get; set; }
        public string ClienteNome { get; set; }
        public List<Endereco> Enderecos { get; set; }
    }
}