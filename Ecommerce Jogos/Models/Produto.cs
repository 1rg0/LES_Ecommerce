namespace Ecommerce_Jogos.Models
{
    public class Produto
    {
        public int ID { get; set; }
        public required string Nome { get; set; }
        public string? URLImagem { get; set; }
        public int AnoLancamento { get; set; }
        public required string Edicao { get; set; }
        public string? Sinopse { get; set; }
        public required string CodigoBarras { get; set; }
        public decimal AlturaCm { get; set; }
        public decimal LarguraCm { get; set; }
        public decimal ProfundidadeCm { get; set; }
        public decimal PesoGramas { get; set; }

        public decimal PrecoCusto { get; set; }
        public decimal PrecoVenda {  get; set; }

        public bool Ativo { get; set; }

        public int PlataformaID { get; set; }
        public Plataforma? Plataforma { get; set; }

        public int DesenvolvedoraID { get; set; }
        public Desenvolvedora? Desenvolvedora { get; set; }

        public int PublicadoraID { get; set; }
        public Publicadora? Publicadora { get; set; }

        public int GrupoPrecificacaoID { get; set; }
        public GrupoPrecificacao? GrupoPrecificacao { get; set; }

        public ICollection<Categoria> Categorias { get; set; }

        public Produto()
        {
            Categorias = new HashSet<Categoria>();
        }
    }
}
