namespace Ecommerce_Jogos.Models
{
    public class Categoria
    {
        public int ID { get; set; }
        public required string Nome { get; set; }
        public required string Descricao { get; set; }

        public ICollection<Produto> Produtos { get; set; }

        public Categoria()
        {
            Produtos = new HashSet<Produto>();
        }
    }
}