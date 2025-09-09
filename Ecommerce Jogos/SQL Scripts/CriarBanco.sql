CREATE DATABASE  IF NOT EXISTS `ecommerce_jogos` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `ecommerce_jogos`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: ecommerce_jogos
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `administrador`
--

DROP TABLE IF EXISTS `administrador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrador` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Funcao` varchar(50) NOT NULL,
  `NomeCompleto` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `SenhaHash` varchar(255) NOT NULL,
  `Ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cartao`
--

DROP TABLE IF EXISTS `cartao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cartao` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ClienteID` int NOT NULL,
  `NomeImpresso` varchar(100) NOT NULL,
  `UltimosQuatroDigitos` varchar(4) NOT NULL,
  `Bandeira` varchar(45) NOT NULL,
  `Preferencial` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `fk_Cartao_Cliente_idx` (`ClienteID`),
  CONSTRAINT `fk_Cartao_Cliente` FOREIGN KEY (`ClienteID`) REFERENCES `cliente` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `categoria`
--

DROP TABLE IF EXISTS `categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoria` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(50) NOT NULL,
  `Descricao` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cidade`
--

DROP TABLE IF EXISTS `cidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cidade` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EstadoID` int NOT NULL,
  `Nome` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_Cidade_Estado_idx` (`EstadoID`),
  CONSTRAINT `fk_Cidade_Estado` FOREIGN KEY (`EstadoID`) REFERENCES `estado` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `NomeCompleto` varchar(100) NOT NULL,
  `CPF` varchar(14) NOT NULL,
  `Genero` varchar(20) NOT NULL,
  `DataNascimento` date NOT NULL,
  `Email` varchar(100) NOT NULL,
  `SenhaHash` varchar(255) NOT NULL,
  `Ativo` tinyint(1) NOT NULL DEFAULT '1',
  `Ranking` int DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Email_UNIQUE` (`Email`),
  UNIQUE KEY `CPF_UNIQUE` (`CPF`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `desenvolvedora`
--

DROP TABLE IF EXISTS `desenvolvedora`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `desenvolvedora` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Nome` (`Nome`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `endereco`
--

DROP TABLE IF EXISTS `endereco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `endereco` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ClienteID` int NOT NULL,
  `Apelido` varchar(50) DEFAULT NULL,
  `Tipo_EnderecoID` int NOT NULL,
  `Tipo_ResidenciaID` int NOT NULL,
  `Tipo_LogradouroID` int NOT NULL,
  `CidadeID` int NOT NULL,
  `Logradouro` varchar(255) NOT NULL,
  `Numero` varchar(10) NOT NULL,
  `Bairro` varchar(100) NOT NULL,
  `CEP` varchar(9) NOT NULL,
  `Observacao` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_Endereco_Cliente_idx` (`ClienteID`),
  KEY `fk_Endereco_TipoEnd_idx` (`Tipo_EnderecoID`),
  KEY `fk_Endereco_TipoRes_idx` (`Tipo_ResidenciaID`),
  KEY `fk_Endereco_TipoLog_idx` (`Tipo_LogradouroID`),
  KEY `fk_Endereco_Cidade_idx` (`CidadeID`),
  CONSTRAINT `fk_Endereco_Cidade` FOREIGN KEY (`CidadeID`) REFERENCES `cidade` (`ID`),
  CONSTRAINT `fk_Endereco_Cliente` FOREIGN KEY (`ClienteID`) REFERENCES `cliente` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_Endereco_TipoEnd` FOREIGN KEY (`Tipo_EnderecoID`) REFERENCES `tipo_endereco` (`ID`),
  CONSTRAINT `fk_Endereco_TipoLog` FOREIGN KEY (`Tipo_LogradouroID`) REFERENCES `tipo_logradouro` (`ID`),
  CONSTRAINT `fk_Endereco_TipoRes` FOREIGN KEY (`Tipo_ResidenciaID`) REFERENCES `tipo_residencia` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entradaestoque`
--

DROP TABLE IF EXISTS `entradaestoque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entradaestoque` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ProdutoID` int NOT NULL,
  `FornecedorID` int DEFAULT NULL,
  `Quantidade` int NOT NULL,
  `ValorCusto` decimal(10,2) NOT NULL,
  `DataEntrada` datetime NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `ProdutoID` (`ProdutoID`),
  KEY `FornecedorID` (`FornecedorID`),
  CONSTRAINT `entradaestoque_ibfk_1` FOREIGN KEY (`ProdutoID`) REFERENCES `produto` (`ID`),
  CONSTRAINT `entradaestoque_ibfk_2` FOREIGN KEY (`FornecedorID`) REFERENCES `fornecedor` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `estado`
--

DROP TABLE IF EXISTS `estado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PaisID` int NOT NULL,
  `Nome` varchar(45) NOT NULL,
  `UF` varchar(2) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_Estado_Pais_idx` (`PaisID`),
  CONSTRAINT `fk_Estado_Pais` FOREIGN KEY (`PaisID`) REFERENCES `pais` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fornecedor`
--

DROP TABLE IF EXISTS `fornecedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fornecedor` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(255) NOT NULL,
  `CNPJ` varchar(18) DEFAULT NULL,
  `EmailContato` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `CNPJ` (`CNPJ`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `grupoprecificacao`
--

DROP TABLE IF EXISTS `grupoprecificacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grupoprecificacao` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(100) NOT NULL,
  `MargemLucro` decimal(5,2) NOT NULL COMMENT 'Percentual de margem. Ex: 30.00 para 30%',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Nome` (`Nome`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `itempedido`
--

DROP TABLE IF EXISTS `itempedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `itempedido` (
  `PedidoID` int NOT NULL,
  `ProdutoID` int NOT NULL,
  `Quantidade` int NOT NULL,
  `PrecoUnitario` decimal(10,2) NOT NULL,
  PRIMARY KEY (`PedidoID`,`ProdutoID`),
  KEY `fk_ItemPedido_Produto_idx` (`ProdutoID`),
  CONSTRAINT `fk_ItemPedido_Pedido` FOREIGN KEY (`PedidoID`) REFERENCES `pedido` (`ID`),
  CONSTRAINT `fk_ItemPedido_Produto` FOREIGN KEY (`ProdutoID`) REFERENCES `produto` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logtransacoes`
--

DROP TABLE IF EXISTS `logtransacoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logtransacoes` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DataHoraOcorrencia` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data e hora em que a operação ocorreu.',
  `AdministradorID` int DEFAULT NULL COMMENT 'ID do usuário administrador que realizou a operação. Pode ser nulo para operações do sistema.',
  `TipoOperacao` varchar(20) NOT NULL COMMENT 'Tipo de operação: INSERÇÃO, ALTERAÇÃO, EXCLUSÃO.',
  `TabelaAfetada` varchar(100) NOT NULL COMMENT 'Nome da tabela que sofreu a alteração (ex: Produto, Cliente).',
  `RegistroID` int NOT NULL COMMENT 'Chave primária (ID) do registro que foi alterado na TabelaAfetada.',
  `DadosAntigos` text COMMENT 'Estado do registro ANTES da alteração, armazenado como JSON.',
  `DadosNovos` text COMMENT 'Estado do registro DEPOIS da alteração, armazenado como JSON.',
  `Motivo` varchar(255) DEFAULT NULL COMMENT 'Motivo opcional para a alteração, preenchido quando necessário.',
  PRIMARY KEY (`ID`),
  KEY `AdministradorID` (`AdministradorID`),
  CONSTRAINT `logtransacoes_ibfk_1` FOREIGN KEY (`AdministradorID`) REFERENCES `administrador` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Tabela para auditoria de todas as operações de escrita no banco de dados.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pais`
--

DROP TABLE IF EXISTS `pais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pais` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pedido`
--

DROP TABLE IF EXISTS `pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedido` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ClienteID` int NOT NULL,
  `DataPedido` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ValorTotal` decimal(10,2) NOT NULL,
  `Status` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_Pedido_Cliente_idx` (`ClienteID`),
  CONSTRAINT `fk_Pedido_Cliente` FOREIGN KEY (`ClienteID`) REFERENCES `cliente` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `plataforma`
--

DROP TABLE IF EXISTS `plataforma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plataforma` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(50) NOT NULL,
  `Empresa` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produto`
--

DROP TABLE IF EXISTS `produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produto` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PlataformaID` int NOT NULL,
  `Nome` varchar(100) NOT NULL,
  `URLImagem` varchar(500) DEFAULT NULL,
  `AnoLancamento` int NOT NULL,
  `Edicao` varchar(100) NOT NULL,
  `Sinopse` text,
  `CodigoBarras` varchar(100) DEFAULT NULL,
  `AlturaCm` decimal(10,2) DEFAULT NULL,
  `LarguraCm` decimal(10,2) DEFAULT NULL,
  `ProfundidadeCm` decimal(10,2) DEFAULT NULL,
  `PesoGramas` decimal(10,2) DEFAULT NULL,
  `PrecoCusto` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'Preço de custo padrão pago ao fornecedor.',
  `PrecoVenda` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'Preço de venda final para o cliente.',
  `Ativo` tinyint(1) NOT NULL DEFAULT '1',
  `DesenvolvedoraID` int DEFAULT NULL,
  `PublicadoraID` int DEFAULT NULL,
  `GrupoPrecificacaoID` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `CodigoBarras` (`CodigoBarras`),
  KEY `fk_Produto_Plataforma_idx` (`PlataformaID`),
  KEY `fk_Produto_Desenvolvedora` (`DesenvolvedoraID`),
  KEY `fk_Produto_Publicadora` (`PublicadoraID`),
  KEY `fk_Produto_GrupoPrecificacao` (`GrupoPrecificacaoID`),
  CONSTRAINT `fk_Produto_Desenvolvedora` FOREIGN KEY (`DesenvolvedoraID`) REFERENCES `desenvolvedora` (`ID`),
  CONSTRAINT `fk_Produto_GrupoPrecificacao` FOREIGN KEY (`GrupoPrecificacaoID`) REFERENCES `grupoprecificacao` (`ID`),
  CONSTRAINT `fk_Produto_Plataforma` FOREIGN KEY (`PlataformaID`) REFERENCES `plataforma` (`ID`),
  CONSTRAINT `fk_Produto_Publicadora` FOREIGN KEY (`PublicadoraID`) REFERENCES `publicadora` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `produtocategoria`
--

DROP TABLE IF EXISTS `produtocategoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtocategoria` (
  `ProdutoID` int NOT NULL,
  `CategoriaID` int NOT NULL,
  PRIMARY KEY (`ProdutoID`,`CategoriaID`),
  KEY `fk_ProdutoCategoria_Produto_idx` (`ProdutoID`),
  KEY `fk_ProdutoCategoria_Categoria_idx` (`CategoriaID`),
  CONSTRAINT `fk_ProdutoCategoria_Categoria` FOREIGN KEY (`CategoriaID`) REFERENCES `categoria` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_ProdutoCategoria_Produto` FOREIGN KEY (`ProdutoID`) REFERENCES `produto` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `publicadora`
--

DROP TABLE IF EXISTS `publicadora`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publicadora` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Nome` (`Nome`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `telefone`
--

DROP TABLE IF EXISTS `telefone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `telefone` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ClienteID` int NOT NULL,
  `Tipo_TelefoneID` int NOT NULL,
  `DDD` varchar(2) NOT NULL,
  `Numero` varchar(10) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_Telefone_Cliente_idx` (`ClienteID`),
  KEY `fk_Telefone_Tipo_idx` (`Tipo_TelefoneID`),
  CONSTRAINT `fk_Telefone_Cliente` FOREIGN KEY (`ClienteID`) REFERENCES `cliente` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_Telefone_Tipo` FOREIGN KEY (`Tipo_TelefoneID`) REFERENCES `tipo_telefone` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tipo_endereco`
--

DROP TABLE IF EXISTS `tipo_endereco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_endereco` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Tipo` varchar(45) NOT NULL COMMENT 'Ex: Entrega, Cobrança',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tipo_logradouro`
--

DROP TABLE IF EXISTS `tipo_logradouro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_logradouro` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Tipo` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tipo_residencia`
--

DROP TABLE IF EXISTS `tipo_residencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_residencia` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Tipo` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tipo_telefone`
--

DROP TABLE IF EXISTS `tipo_telefone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_telefone` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Tipo` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-27 15:25:55
