namespace Ecommerce_Jogos.Models
{
    public class EntradaEstoque
    {
        public int ID { get; set; }
        public required int Quantidade { get; set; }
        public required decimal ValorCusto { get; set; }
        public required DateTime DataEntrada { get; set; }

        public int ProdutoID { get; set; }
        public int? FornecedorID { get; set; }

    }
}
