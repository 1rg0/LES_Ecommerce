namespace Ecommerce_Jogos.Models
{
    public class Endereco
    {
        public int ID { get; set; }
        public required string Apelido { get; set; }
        public required string Logradouro { get; set; }
        public required string Numero { get; set; }
        public required string Bairro { get; set; }
        public required string CEP { get; set; }
        public string? Observacao { get; set; }

        public int ClienteID { get; set; }
        public Cliente? Cliente { get; set; }

        public int CidadeID { get; set; }
        public Cidade? Cidade { get; set; }

        public int Tipo_EnderecoID { get; set; }
        public TipoEndereco? Tipo_Endereco { get; set; }

        public int Tipo_LogradouroID { get; set; }
        public TipoLogradouro? Tipo_Logradouro { get; set; }

        public int Tipo_ResidenciaID { get; set; }
        public TipoResidencia? Tipo_Residencia { get; set; }
    }
}
