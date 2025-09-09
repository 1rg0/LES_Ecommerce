using Ecommerce_Jogos.Models;
using Microsoft.EntityFrameworkCore;

namespace Ecommerce_Jogos.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {

        }

        public DbSet<Administrador> Administradores { get; set; }
        public DbSet<Cliente> Clientes { get; set; }
        public DbSet<Endereco> Enderecos { get; set; }
        public DbSet<TipoEndereco> TiposEndereco { get; set; }
        public DbSet<TipoLogradouro> TiposLogradouro { get; set; }
        public DbSet<TipoResidencia> TiposResidencia { get; set; }
        public DbSet<Pais> Paises { get; set; }
        public DbSet<Estado> Estados { get; set; }
        public DbSet<Cidade> Cidades { get; set; }
        public DbSet<Telefone> Telefones { get; set; }
        public DbSet<TipoTelefone> TiposTelefone { get; set; }
        public DbSet<Cartao> Cartoes { get; set; }
        public DbSet<Pedido> Pedidos { get; set; }
        public DbSet<ItemPedido> ItensPedido { get; set; }
        public DbSet<Produto> Produtos { get; set; }
        public DbSet<Categoria> Categorias { get; set; }
        public DbSet<Plataforma> Plataformas { get; set; }
        public DbSet<Desenvolvedora> Desenvolvedoras { get; set; }
        public DbSet<Publicadora> Publicadoras { get; set; }
        public DbSet<GrupoPrecificacao> GruposPrecificacao { get; set; }
        public DbSet<ProdutoCategoria> ProdutoCategorias { get; set; }

        public DbSet<EntradaEstoque> EntradasEstoque {  get; set; }
        public DbSet<Fornecedor> Fornecedores { get; set; }

        public DbSet<LogTransacoes> LogTransacoes { get; set; }

        public DbSet<Cupom> Cupons { get; set; }

        public DbSet<Troca> Trocas { get; set; }
        public DbSet<ItemTroca> ItensTroca { get; set; }

        public DbSet<PagamentoPedido> PagamentosPedido { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Administrador>().ToTable("Administrador");

            modelBuilder.Entity<Cliente>().ToTable("Cliente");

            modelBuilder.Entity<Endereco>().ToTable("Endereco");
            modelBuilder.Entity<TipoEndereco>().ToTable("Tipo_Endereco");
            modelBuilder.Entity<TipoLogradouro>().ToTable("Tipo_Logradouro");
            modelBuilder.Entity<TipoResidencia>().ToTable("Tipo_Residencia");
            modelBuilder.Entity<Pais>().ToTable("Pais");
            modelBuilder.Entity<Estado>().ToTable("Estado");
            modelBuilder.Entity<Cidade>().ToTable("Cidade");

            modelBuilder.Entity<Telefone>().ToTable("Telefone");
            modelBuilder.Entity<TipoTelefone>().ToTable("Tipo_Telefone");

            modelBuilder.Entity<Cartao>().ToTable("Cartao");

            modelBuilder.Entity<Pedido>().ToTable("Pedido");
            modelBuilder.Entity<ItemPedido>().ToTable("ItemPedido");

            modelBuilder.Entity<Produto>().ToTable("Produto");
            modelBuilder.Entity<Categoria>().ToTable("Categoria");
            modelBuilder.Entity<Plataforma>().ToTable("Plataforma");
            modelBuilder.Entity<Desenvolvedora>().ToTable("Desenvolvedora");
            modelBuilder.Entity<Publicadora>().ToTable("Publicadora");
            modelBuilder.Entity<GrupoPrecificacao>().ToTable("GrupoPrecificacao");

            modelBuilder.Entity<EntradaEstoque>().ToTable("EntradaEstoque");
            modelBuilder.Entity<Fornecedor>().ToTable("Fornecedor");

            modelBuilder.Entity<LogTransacoes>().ToTable("LogTransacoes");

            modelBuilder.Entity<Cupom>().ToTable("Cupom");

            modelBuilder.Entity<Troca>().ToTable("Troca");

            modelBuilder.Entity<PagamentoPedido>().ToTable("PagamentoPedido");

            modelBuilder.Entity<ItemPedido>()
                .HasKey(ip => new { ip.PedidoID, ip.ProdutoID });

            modelBuilder.Entity<ProdutoCategoria>()
                .HasKey(pc => new { pc.ProdutoID, pc.CategoriaID });

            modelBuilder.Entity<Produto>()
                .HasMany(p => p.Categorias)
                .WithMany(c => c.Produtos)
                .UsingEntity<ProdutoCategoria>(j => j.ToTable("ProdutoCategoria"));

            modelBuilder.Entity<ItemTroca>().ToTable("ItemTroca")
                .HasKey(it => new { it.TrocaID, it.ItemPedidoPedidoID, it.ItemPedidoProdutoID });
        }
    }
}
