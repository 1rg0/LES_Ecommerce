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
-- Dumping data for table `administrador`
--

LOCK TABLES `administrador` WRITE;
/*!40000 ALTER TABLE `administrador` DISABLE KEYS */;
INSERT INTO `administrador` VALUES (1,'Administrador','Admin Master','admin@ecommerce.com','$2a$11$sTOsCMEhL8.5HZvz.XVn9eBK2seOwkzrOGnvgkuWlJbgKKXOW4HyW',1);
/*!40000 ALTER TABLE `administrador` ENABLE KEYS */;
UNLOCK TABLES;

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
  `DataValidade` varchar(7) NOT NULL COMMENT 'Data de validade no formato MM/AAAA',
  `Preferencial` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `fk_Cartao_Cliente_idx` (`ClienteID`),
  CONSTRAINT `fk_Cartao_Cliente` FOREIGN KEY (`ClienteID`) REFERENCES `cliente` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cartao`
--

LOCK TABLES `cartao` WRITE;
/*!40000 ALTER TABLE `cartao` DISABLE KEYS */;
INSERT INTO `cartao` VALUES (1,1,'Igor F de Matos','3456','Visa','12/2026',1);
/*!40000 ALTER TABLE `cartao` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `categoria`
--

LOCK TABLES `categoria` WRITE;
/*!40000 ALTER TABLE `categoria` DISABLE KEYS */;
INSERT INTO `categoria` VALUES (1,'Ação','Jogos focados em desafios físicos, incluindo combate, plataforma e exploração.'),(2,'Aventura','Jogos que enfatizam a exploração e a resolução de quebra-cabeças em uma narrativa.'),(3,'RPG','Jogos de interpretação de papéis com foco no desenvolvimento de personagens e histórias complexas.'),(4,'Esportes','Simulações de esportes do mundo real, como futebol, basquete e automobilismo.'),(5,'Corrida','Jogos centrados em competições de velocidade com veículos.'),(6,'Estratégia','Jogos que exigem planejamento e tomada de decisões táticas para alcançar a vitória.'),(7,'Luta','Jogos de combate um contra um entre um número limitado de personagens.'),(8,'Tiro','Jogos com combate baseado em armas de fogo, em primeira ou terceira pessoa (FPS/TPS).'),(9,'Terror de Sobrevivivência','Jogos que buscam assustar o jogador, geralmente com recursos limitados e atmosfera tensa.'),(10,'Plataforma','Jogos cujo principal desafio é pular e escalar entre plataformas suspensas.'),(11,'Mundo Aberto','Jogos que apresentam um vasto mapa explorável com missões principais e secundárias não-lineares.'),(12,'Simulação','Jogos que recriam atividades e sistemas do mundo real com o máximo de fidelidade possível.');
/*!40000 ALTER TABLE `categoria` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `cidade`
--

LOCK TABLES `cidade` WRITE;
/*!40000 ALTER TABLE `cidade` DISABLE KEYS */;
INSERT INTO `cidade` VALUES (1,25,'Suzano'),(2,25,'Mogi das Cruzes'),(3,25,'São Paulo'),(4,19,'Niterói'),(5,19,'Rio de Janeiro');
/*!40000 ALTER TABLE `cidade` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'Igor Fernandes de Matos','472.468.138-10','Masculino','2000-09-06','igor.teste@gmail.com','$2a$11$myr3QVLMnQ1iAYJ5MNOzkOpwNwgUT37zM1yPjQy5udWJRfa/9qyYi',1,NULL);
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `desenvolvedora`
--

LOCK TABLES `desenvolvedora` WRITE;
/*!40000 ALTER TABLE `desenvolvedora` DISABLE KEYS */;
INSERT INTO `desenvolvedora` VALUES (17,'Bandai Namco Entertainment'),(12,'Bethesda Game Studios'),(9,'Capcom'),(5,'CD Projekt Red'),(3,'FromSoftware'),(14,'Game Freak'),(8,'Guerrilla Games'),(7,'Insomniac Games'),(1,'Naughty Dog'),(6,'Nintendo EPD'),(13,'Playground Games'),(4,'Rockstar North'),(2,'Santa Monica Studio'),(10,'Square Enix'),(11,'Team Cherry'),(15,'Treyarch'),(16,'Ubisoft');
/*!40000 ALTER TABLE `desenvolvedora` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `endereco`
--

LOCK TABLES `endereco` WRITE;
/*!40000 ALTER TABLE `endereco` DISABLE KEYS */;
INSERT INTO `endereco` VALUES (1,1,'Cobranca',2,1,1,1,'X','100','Bairro A','12345-678',''),(2,1,'Casa',1,1,4,1,'Celestino Rodrigues','321','Jardim Imperador','08673-230','');
/*!40000 ALTER TABLE `endereco` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entradaestoque`
--

LOCK TABLES `entradaestoque` WRITE;
/*!40000 ALTER TABLE `entradaestoque` DISABLE KEYS */;
INSERT INTO `entradaestoque` VALUES (1,1,1,5,200.00,'2025-08-31 00:00:00'),(2,2,2,5,200.00,'2025-08-31 00:00:00'),(3,3,3,10,300.00,'2025-08-31 00:00:00'),(4,4,4,2,100.00,'2025-08-31 00:00:00'),(5,5,5,10,120.00,'2025-08-31 00:00:00'),(6,6,1,10,200.00,'2025-08-31 00:00:00'),(7,7,2,5,200.00,'2025-08-31 00:00:00'),(8,8,3,5,300.00,'2025-08-31 00:00:00'),(9,9,5,2,100.00,'2025-08-31 00:00:00'),(10,10,3,2,100.00,'2025-08-31 00:00:00'),(12,1,NULL,-1,0.00,'2025-08-31 17:56:59'),(13,1,NULL,-1,0.00,'2025-08-31 18:05:48'),(14,3,NULL,-2,0.00,'2025-08-31 18:07:03'),(15,4,NULL,-1,0.00,'2025-08-31 18:07:26'),(16,5,NULL,-1,0.00,'2025-08-31 18:07:26'),(17,6,NULL,-1,0.00,'2025-08-31 18:07:26');
/*!40000 ALTER TABLE `entradaestoque` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `estado`
--

LOCK TABLES `estado` WRITE;
/*!40000 ALTER TABLE `estado` DISABLE KEYS */;
INSERT INTO `estado` VALUES (1,1,'Acre','AC'),(2,1,'Alagoas','AL'),(3,1,'Amapá','AP'),(4,1,'Amazonas','AM'),(5,1,'Bahia','BA'),(6,1,'Ceará','CE'),(7,1,'Distrito Federal','DF'),(8,1,'Espírito Santo','ES'),(9,1,'Goiás','GO'),(10,1,'Maranhão','MA'),(11,1,'Mato Grosso','MT'),(12,1,'Mato Grosso do Sul','MS'),(13,1,'Minas Gerais','MG'),(14,1,'Pará','PA'),(15,1,'Paraíba','PB'),(16,1,'Paraná','PR'),(17,1,'Pernambuco','PE'),(18,1,'Piauí','PI'),(19,1,'Rio de Janeiro','RJ'),(20,1,'Rio Grande do Norte','RN'),(21,1,'Rio Grande do Sul','RS'),(22,1,'Rondônia','RO'),(23,1,'Roraima','RR'),(24,1,'Santa Catarina','SC'),(25,1,'São Paulo','SP'),(26,1,'Sergipe','SE'),(27,1,'Tocantins','TO');
/*!40000 ALTER TABLE `estado` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `fornecedor`
--

LOCK TABLES `fornecedor` WRITE;
/*!40000 ALTER TABLE `fornecedor` DISABLE KEYS */;
INSERT INTO `fornecedor` VALUES (1,'Games Brasil Distribuidora','12.345.678/0001-99','contato@gamesbrasildist.com.br'),(2,'Import Action Games','23.456.789/0001-88','sales@importaction.com'),(3,'Indie Nexus Hub','34.567.890/0001-77','parcerias@indienexus.com.br'),(4,'Player One Acessórios','45.678.901/0001-66','vendas@playeroneacessorios.com'),(5,'SP Games Logística','56.789.012/0001-55','logistica@spgames.com.br');
/*!40000 ALTER TABLE `fornecedor` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `grupoprecificacao`
--

LOCK TABLES `grupoprecificacao` WRITE;
/*!40000 ALTER TABLE `grupoprecificacao` DISABLE KEYS */;
INSERT INTO `grupoprecificacao` VALUES (1,'Lançamento AAA',40.00),(2,'Padrão',60.00),(3,'Promoção',25.50),(4,'Econômico (Hits)',75.00),(5,'Edição Especial',45.00);
/*!40000 ALTER TABLE `grupoprecificacao` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `itempedido`
--

LOCK TABLES `itempedido` WRITE;
/*!40000 ALTER TABLE `itempedido` DISABLE KEYS */;
INSERT INTO `itempedido` VALUES (1,1,1,280.00),(2,1,1,280.00),(3,3,2,420.00),(4,4,1,140.00),(4,5,1,168.00),(4,6,1,280.00);
/*!40000 ALTER TABLE `itempedido` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Tabela para auditoria de todas as operações de escrita no banco de dados.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logtransacoes`
--

LOCK TABLES `logtransacoes` WRITE;
/*!40000 ALTER TABLE `logtransacoes` DISABLE KEYS */;
INSERT INTO `logtransacoes` VALUES (1,'2025-08-31 15:07:36',1,'INSERÇÃO','Cliente',1,NULL,'{\"Cliente\":{\"Id\":1,\"NomeCompleto\":\"Igor Fernandes de Matos\",\"CPF\":\"472.468.138-10\",\"Genero\":\"Masculino\",\"DataNascimento\":\"2000-09-06T00:00:00\",\"Email\":\"igor.teste@gmail.com\",\"SenhaHash\":\"$2a$11$myr3QVLMnQ1iAYJ5MNOzkOpwNwgUT37zM1yPjQy5udWJRfa/9qyYi\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":1,\"Apelido\":\"Cobranca\",\"Logradouro\":\"X\",\"Numero\":\"100\",\"Bairro\":\"Bairro A\",\"CEP\":\"12345-678\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":1,\"DDD\":\"11\",\"Numero\":\"98765-4321\",\"ClienteID\":1,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":1,\"NomeImpresso\":\"Igor F de Matos\",\"UltimosQuatroDigitos\":\"3456\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":1,\"Cliente\":null}],\"Pedidos\":[]},\"Telefones\":[{\"ID\":1,\"DDD\":\"11\",\"Numero\":\"98765-4321\",\"ClienteID\":1,\"Cliente\":{\"Id\":1,\"NomeCompleto\":\"Igor Fernandes de Matos\",\"CPF\":\"472.468.138-10\",\"Genero\":\"Masculino\",\"DataNascimento\":\"2000-09-06T00:00:00\",\"Email\":\"igor.teste@gmail.com\",\"SenhaHash\":\"$2a$11$myr3QVLMnQ1iAYJ5MNOzkOpwNwgUT37zM1yPjQy5udWJRfa/9qyYi\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":1,\"Apelido\":\"Cobranca\",\"Logradouro\":\"X\",\"Numero\":\"100\",\"Bairro\":\"Bairro A\",\"CEP\":\"12345-678\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[null],\"Cartoes\":[{\"ID\":1,\"NomeImpresso\":\"Igor F de Matos\",\"UltimosQuatroDigitos\":\"3456\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":1,\"Cliente\":null}],\"Pedidos\":[]},\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Enderecos\":[{\"ID\":1,\"Apelido\":\"Cobranca\",\"Logradouro\":\"X\",\"Numero\":\"100\",\"Bairro\":\"Bairro A\",\"CEP\":\"12345-678\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":{\"Id\":1,\"NomeCompleto\":\"Igor Fernandes de Matos\",\"CPF\":\"472.468.138-10\",\"Genero\":\"Masculino\",\"DataNascimento\":\"2000-09-06T00:00:00\",\"Email\":\"igor.teste@gmail.com\",\"SenhaHash\":\"$2a$11$myr3QVLMnQ1iAYJ5MNOzkOpwNwgUT37zM1yPjQy5udWJRfa/9qyYi\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[null,{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":1,\"DDD\":\"11\",\"Numero\":\"98765-4321\",\"ClienteID\":1,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":1,\"NomeImpresso\":\"Igor F de Matos\",\"UltimosQuatroDigitos\":\"3456\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":1,\"Cliente\":null}],\"Pedidos\":[]},\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":{\"Id\":1,\"NomeCompleto\":\"Igor Fernandes de Matos\",\"CPF\":\"472.468.138-10\",\"Genero\":\"Masculino\",\"DataNascimento\":\"2000-09-06T00:00:00\",\"Email\":\"igor.teste@gmail.com\",\"SenhaHash\":\"$2a$11$myr3QVLMnQ1iAYJ5MNOzkOpwNwgUT37zM1yPjQy5udWJRfa/9qyYi\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":1,\"Apelido\":\"Cobranca\",\"Logradouro\":\"X\",\"Numero\":\"100\",\"Bairro\":\"Bairro A\",\"CEP\":\"12345-678\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},null],\"Telefones\":[{\"ID\":1,\"DDD\":\"11\",\"Numero\":\"98765-4321\",\"ClienteID\":1,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":1,\"NomeImpresso\":\"Igor F de Matos\",\"UltimosQuatroDigitos\":\"3456\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":1,\"Cliente\":null}],\"Pedidos\":[]},\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Cartoes\":[{\"ID\":1,\"NomeImpresso\":\"Igor F de Matos\",\"UltimosQuatroDigitos\":\"3456\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":1,\"Cliente\":{\"Id\":1,\"NomeCompleto\":\"Igor Fernandes de Matos\",\"CPF\":\"472.468.138-10\",\"Genero\":\"Masculino\",\"DataNascimento\":\"2000-09-06T00:00:00\",\"Email\":\"igor.teste@gmail.com\",\"SenhaHash\":\"$2a$11$myr3QVLMnQ1iAYJ5MNOzkOpwNwgUT37zM1yPjQy5udWJRfa/9qyYi\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":1,\"Apelido\":\"Cobranca\",\"Logradouro\":\"X\",\"Numero\":\"100\",\"Bairro\":\"Bairro A\",\"CEP\":\"12345-678\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":1,\"DDD\":\"11\",\"Numero\":\"98765-4321\",\"ClienteID\":1,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[null],\"Pedidos\":[]}}]}',NULL),(2,'2025-08-31 15:10:04',1,'INSERÇÃO','Produto',1,NULL,'{\"ID\":1,\"Nome\":\"God of War Ragnar\\u00F6k\",\"URLImagem\":\"https://m.media-amazon.com/images/I/819bwWHNMJL.jpg\",\"AnoLancamento\":2022,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"UM FUTURO N\\u00C3O ESCRITO\\r\\nAtreus busca conhecimento para entender a profecia de \\u0022\\u0022Loki\\u0022\\u0022 e definir o papel dele no Ragnar\\u00F6k. Kratos deve se desacorrentar do medo de repetir erros do passado para ser o pai que Atreus precisa.\",\"CodigoBarras\":\"SKU1\",\"AlturaCm\":1,\"LarguraCm\":1,\"ProfundidadeCm\":1,\"PesoGramas\":1,\"PrecoCusto\":0,\"PrecoVenda\":0,\"Ativo\":true,\"PlataformaID\":1,\"Plataforma\":null,\"DesenvolvedoraID\":2,\"Desenvolvedora\":null,\"PublicadoraID\":1,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":2,\"Nome\":\"Aventura\",\"Descricao\":\"Jogos que enfatizam a explora\\u00E7\\u00E3o e a resolu\\u00E7\\u00E3o de quebra-cabe\\u00E7as em uma narrativa.\",\"Produtos\":[null]},{\"ID\":3,\"Nome\":\"RPG\",\"Descricao\":\"Jogos de interpreta\\u00E7\\u00E3o de pap\\u00E9is com foco no desenvolvimento de personagens e hist\\u00F3rias complexas.\",\"Produtos\":[null]},{\"ID\":11,\"Nome\":\"Mundo Aberto\",\"Descricao\":\"Jogos que apresentam um vasto mapa explor\\u00E1vel com miss\\u00F5es principais e secund\\u00E1rias n\\u00E3o-lineares.\",\"Produtos\":[null]}]}',NULL),(3,'2025-08-31 15:12:11',1,'INSERÇÃO','Produto',2,NULL,'{\"ID\":2,\"Nome\":\"Starfield\",\"URLImagem\":\"https://http2.mlstatic.com/D_NQ_NP_776642-MLU73417729993_122023-O.webp\",\"AnoLancamento\":2023,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"Em Starfield, a hist\\u00F3ria mais importante \\u00E9 a que voc\\u00EA conta com seu personagem. Comece a jornada personalizando sua apar\\u00EAncia e decidindo seu hist\\u00F3rico e atributos. Voc\\u00EA ser\\u00E1 um explorador experiente, um diplomata charmoso, um ciberita furtivo ou algo completamente diferente? A escolha \\u00E9 sua. Decida quem voc\\u00EA ser\\u00E1 e o que se tornar\\u00E1.\",\"CodigoBarras\":\"SKU2\",\"AlturaCm\":1,\"LarguraCm\":1,\"ProfundidadeCm\":1,\"PesoGramas\":1,\"PrecoCusto\":0,\"PrecoVenda\":0,\"Ativo\":true,\"PlataformaID\":3,\"Plataforma\":null,\"DesenvolvedoraID\":12,\"Desenvolvedora\":null,\"PublicadoraID\":12,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":2,\"Nome\":\"Aventura\",\"Descricao\":\"Jogos que enfatizam a explora\\u00E7\\u00E3o e a resolu\\u00E7\\u00E3o de quebra-cabe\\u00E7as em uma narrativa.\",\"Produtos\":[null]},{\"ID\":3,\"Nome\":\"RPG\",\"Descricao\":\"Jogos de interpreta\\u00E7\\u00E3o de pap\\u00E9is com foco no desenvolvimento de personagens e hist\\u00F3rias complexas.\",\"Produtos\":[null]},{\"ID\":8,\"Nome\":\"Tiro\",\"Descricao\":\"Jogos com combate baseado em armas de fogo, em primeira ou terceira pessoa (FPS/TPS).\",\"Produtos\":[null]},{\"ID\":11,\"Nome\":\"Mundo Aberto\",\"Descricao\":\"Jogos que apresentam um vasto mapa explor\\u00E1vel com miss\\u00F5es principais e secund\\u00E1rias n\\u00E3o-lineares.\",\"Produtos\":[null]}]}',NULL),(4,'2025-08-31 15:14:17',1,'INSERÇÃO','Produto',3,NULL,'{\"ID\":3,\"Nome\":\"Pokemon Legends Arceus\",\"URLImagem\":\"https://m.media-amazon.com/images/I/71bhNf8QiOS.jpg\",\"AnoLancamento\":2022,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"Prepare-se para um novo tipo de grande aventura Pok\\u00E9mon em Pok\\u00E9mon Legends: Arceus, um jogo totalmente novo da Game Freak que combina a\\u00E7\\u00E3o e explora\\u00E7\\u00E3o com as ra\\u00EDzes de RPG da s\\u00E9rie Pok\\u00E9mon. Embarque em miss\\u00F5es de pesquisa na antiga regi\\u00E3o de Hisui. Explore extens\\u00F5es naturais para capturar Pok\\u00E9mon selvagens, aprendendo seu comportamento, aproximando-se sorrateiramente e jogando uma Pok\\u00E9 Ball bem direcionada. Voc\\u00EA tamb\\u00E9m pode jogar a Pok\\u00E9 Ball contendo seu Pok\\u00E9mon aliado perto de um Pok\\u00E9mon selvagem para entrar na batalha sem problemas.\",\"CodigoBarras\":\"SKU3\",\"AlturaCm\":1,\"LarguraCm\":1,\"ProfundidadeCm\":1,\"PesoGramas\":1,\"PrecoCusto\":0,\"PrecoVenda\":0,\"Ativo\":true,\"PlataformaID\":5,\"Plataforma\":null,\"DesenvolvedoraID\":6,\"Desenvolvedora\":null,\"PublicadoraID\":2,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":2,\"Nome\":\"Aventura\",\"Descricao\":\"Jogos que enfatizam a explora\\u00E7\\u00E3o e a resolu\\u00E7\\u00E3o de quebra-cabe\\u00E7as em uma narrativa.\",\"Produtos\":[null]},{\"ID\":3,\"Nome\":\"RPG\",\"Descricao\":\"Jogos de interpreta\\u00E7\\u00E3o de pap\\u00E9is com foco no desenvolvimento de personagens e hist\\u00F3rias complexas.\",\"Produtos\":[null]},{\"ID\":11,\"Nome\":\"Mundo Aberto\",\"Descricao\":\"Jogos que apresentam um vasto mapa explor\\u00E1vel com miss\\u00F5es principais e secund\\u00E1rias n\\u00E3o-lineares.\",\"Produtos\":[null]}]}',NULL),(5,'2025-08-31 15:17:56',1,'INSERÇÃO','Produto',4,NULL,'{\"ID\":4,\"Nome\":\"Call of Duty: Black Ops 3\",\"URLImagem\":\"https://m.media-amazon.com/images/I/81bwynfO98L.jpg\",\"AnoLancamento\":2015,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"Call of Duty: Black Ops III \\u00E9 o jogo mais profundo e ambicioso da s\\u00E9rie ao combinar tr\\u00EAs modos de jogo \\u00FAnicos: campanha, multijogador e Zombies. A campanha foi criada para ser partilhada por 4 jogadores online ou desfrutada a solo numa emocionante experi\\u00EAncia cinem\\u00E1tica. O multijogador ser\\u00E1 o mais profundo e gratificante da s\\u00E9rie, com novas formas para subir de n\\u00EDvel, modificar a personagem e prepar\\u00E1-la para a batalha. J\\u00E1 o modo Zombies proporciona uma nova experi\\u00EAncia com uma narrativa dedicada. Este t\\u00EDtulo introduz um n\\u00EDvel de inova\\u00E7\\u00E3o sem precedentes incluindo cen\\u00E1rios arrasadores, armamento e habilidades in\\u00E9ditos e a introdu\\u00E7\\u00E3o de um novo sistema de movimento fluido e melhorado.\",\"CodigoBarras\":\"SKU4\",\"AlturaCm\":1,\"LarguraCm\":1,\"ProfundidadeCm\":1,\"PesoGramas\":1,\"PrecoCusto\":0,\"PrecoVenda\":0,\"Ativo\":true,\"PlataformaID\":4,\"Plataforma\":null,\"DesenvolvedoraID\":8,\"Desenvolvedora\":null,\"PublicadoraID\":12,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":8,\"Nome\":\"Tiro\",\"Descricao\":\"Jogos com combate baseado em armas de fogo, em primeira ou terceira pessoa (FPS/TPS).\",\"Produtos\":[null]},{\"ID\":12,\"Nome\":\"Simula\\u00E7\\u00E3o\",\"Descricao\":\"Jogos que recriam atividades e sistemas do mundo real com o m\\u00E1ximo de fidelidade poss\\u00EDvel.\",\"Produtos\":[null]}]}',NULL),(6,'2025-08-31 15:19:58',1,'INSERÇÃO','Produto',5,NULL,'{\"ID\":5,\"Nome\":\"Resident Evil 2\",\"URLImagem\":\"https://m.media-amazon.com/images/I/71qWdMRpNGL.jpg\",\"AnoLancamento\":2019,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"Em Resident Evil 2, a a\\u00E7\\u00E3o cl\\u00E1ssica, explora\\u00E7\\u00E3o tensa e a jogabilidade de resolver quebra-cabe\\u00E7as que definiu a s\\u00E9rie Resident Evil retorna. Os jogadores se juntam ao policial novato, Leon S. Kennedy, e \\u00E0 estudante universit\\u00E1ria, Claire Redfield, que acabam juntos por uma epidemia desastrosa em Raccoon City que transformou sua popula\\u00E7\\u00E3o em zumbis mortais. Leon e Claire possuem suas pr\\u00F3prias campanhas separadas, permitindo que os jogadores vejam a hist\\u00F3ria da perspectiva de ambos os personagens. O destino desses dois personagens favoritos dos f\\u00E3s est\\u00E1 nas m\\u00E3os dos jogadores conforme eles trabalham juntos para sobreviver e descobrir o que est\\u00E1 por tr\\u00E1s do terr\\u00EDvel ataque \\u00E0 cidade. Ser\\u00E1 que eles sair\\u00E3o com vida?\",\"CodigoBarras\":\"SKU5\",\"AlturaCm\":1,\"LarguraCm\":1,\"ProfundidadeCm\":1,\"PesoGramas\":1,\"PrecoCusto\":0,\"PrecoVenda\":0,\"Ativo\":true,\"PlataformaID\":2,\"Plataforma\":null,\"DesenvolvedoraID\":9,\"Desenvolvedora\":null,\"PublicadoraID\":1,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":8,\"Nome\":\"Tiro\",\"Descricao\":\"Jogos com combate baseado em armas de fogo, em primeira ou terceira pessoa (FPS/TPS).\",\"Produtos\":[null]},{\"ID\":9,\"Nome\":\"Terror de Sobreviviv\\u00EAncia\",\"Descricao\":\"Jogos que buscam assustar o jogador, geralmente com recursos limitados e atmosfera tensa.\",\"Produtos\":[null]}]}',NULL),(7,'2025-08-31 15:22:11',1,'INSERÇÃO','Produto',6,NULL,'{\"ID\":6,\"Nome\":\"Marvel\\u0027s Spider-Man 2\",\"URLImagem\":\"https://m.media-amazon.com/images/I/81Zh-3T1enL.jpg\",\"AnoLancamento\":2023,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"Uma cidade sitiada!\\r\\nOs Spiders Peter Parker e Miles Morales encaram a maior prova de for\\u00E7a com e sem suas m\\u00E1scaras enquanto lutam para salvar a cidade, um ao outro e as pessoas que amam do monstruoso Venom e da nova e perigosa amea\\u00E7a: os simbiontes.\",\"CodigoBarras\":\"SKU6\",\"AlturaCm\":1,\"LarguraCm\":1,\"ProfundidadeCm\":1,\"PesoGramas\":1,\"PrecoCusto\":0,\"PrecoVenda\":0,\"Ativo\":true,\"PlataformaID\":1,\"Plataforma\":null,\"DesenvolvedoraID\":7,\"Desenvolvedora\":null,\"PublicadoraID\":1,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":2,\"Nome\":\"Aventura\",\"Descricao\":\"Jogos que enfatizam a explora\\u00E7\\u00E3o e a resolu\\u00E7\\u00E3o de quebra-cabe\\u00E7as em uma narrativa.\",\"Produtos\":[null]},{\"ID\":7,\"Nome\":\"Luta\",\"Descricao\":\"Jogos de combate um contra um entre um n\\u00FAmero limitado de personagens.\",\"Produtos\":[null]},{\"ID\":11,\"Nome\":\"Mundo Aberto\",\"Descricao\":\"Jogos que apresentam um vasto mapa explor\\u00E1vel com miss\\u00F5es principais e secund\\u00E1rias n\\u00E3o-lineares.\",\"Produtos\":[null]}]}',NULL),(8,'2025-08-31 15:25:44',1,'INSERÇÃO','Produto',7,NULL,'{\"ID\":7,\"Nome\":\"Forza Horizon 5\",\"URLImagem\":\"https://media.gamestop.com/i/gamestop/11148773.jpg\",\"AnoLancamento\":2021,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"Sua Maior Aventura Horizon espera por voc\\u00EA! Explore as paisagens vibrantes de mundo aberto do M\\u00E9xico, com divers\\u00E3o e velocidade sem limites em um mundo em constante evolu\\u00E7\\u00E3o, incluindo centenas dos melhores carros do mundo.\",\"CodigoBarras\":\"SKU7\",\"AlturaCm\":1,\"LarguraCm\":1,\"ProfundidadeCm\":1,\"PesoGramas\":1,\"PrecoCusto\":0,\"PrecoVenda\":0,\"Ativo\":true,\"PlataformaID\":3,\"Plataforma\":null,\"DesenvolvedoraID\":13,\"Desenvolvedora\":null,\"PublicadoraID\":3,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":2,\"Nome\":\"Aventura\",\"Descricao\":\"Jogos que enfatizam a explora\\u00E7\\u00E3o e a resolu\\u00E7\\u00E3o de quebra-cabe\\u00E7as em uma narrativa.\",\"Produtos\":[null]},{\"ID\":4,\"Nome\":\"Esportes\",\"Descricao\":\"Simula\\u00E7\\u00F5es de esportes do mundo real, como futebol, basquete e automobilismo.\",\"Produtos\":[null]},{\"ID\":5,\"Nome\":\"Corrida\",\"Descricao\":\"Jogos centrados em competi\\u00E7\\u00F5es de velocidade com ve\\u00EDculos.\",\"Produtos\":[null]}]}',NULL),(9,'2025-08-31 15:27:49',1,'INSERÇÃO','Produto',8,NULL,'{\"ID\":8,\"Nome\":\"The Legend of Zelda: Tears of Kingdom\",\"URLImagem\":\"https://images.kabum.com.br/produtos/fotos/sync_mirakl/464339/xlarge/Jogo-The-Legend-Of-Zelda-Tears-Of-The-Kingdom-Nintendo-Switch-Midia-F-sica_1751918394.jpg\",\"AnoLancamento\":2023,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"VIVA ESTA AVENTURA INCOMPAR\\u00C1VEL. Uma aventura \\u00E9pica pela terra e pelos c\\u00E9us de Hyrule aguarda em The Legend of Zelda: Tears of the Kingdom, para o console Nintendo Switch. A aventura ser\\u00E1 criada por voc\\u00EA, em um mundo alimentado pela sua imagina\\u00E7\\u00E3o.\",\"CodigoBarras\":\"SKU8\",\"AlturaCm\":1,\"LarguraCm\":1,\"ProfundidadeCm\":1,\"PesoGramas\":1,\"PrecoCusto\":0,\"PrecoVenda\":0,\"Ativo\":true,\"PlataformaID\":5,\"Plataforma\":null,\"DesenvolvedoraID\":6,\"Desenvolvedora\":null,\"PublicadoraID\":2,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":2,\"Nome\":\"Aventura\",\"Descricao\":\"Jogos que enfatizam a explora\\u00E7\\u00E3o e a resolu\\u00E7\\u00E3o de quebra-cabe\\u00E7as em uma narrativa.\",\"Produtos\":[null]},{\"ID\":3,\"Nome\":\"RPG\",\"Descricao\":\"Jogos de interpreta\\u00E7\\u00E3o de pap\\u00E9is com foco no desenvolvimento de personagens e hist\\u00F3rias complexas.\",\"Produtos\":[null]},{\"ID\":11,\"Nome\":\"Mundo Aberto\",\"Descricao\":\"Jogos que apresentam um vasto mapa explor\\u00E1vel com miss\\u00F5es principais e secund\\u00E1rias n\\u00E3o-lineares.\",\"Produtos\":[null]}]}',NULL),(10,'2025-08-31 15:33:50',1,'INSERÇÃO','Produto',9,NULL,'{\"ID\":9,\"Nome\":\"Assassin\\u0027s Creed Unity\",\"URLImagem\":\"https://cdn.awsli.com.br/600x450/138/138431/produto/7988193/df7d2c8e0b.jpg\",\"AnoLancamento\":2014,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"UM NOVO HER\\u00D3I IMPLAC\\u00C1VEL PARA UM NOVO MUNDO BRUTAL\\r\\nJogue como Arno, um tipo de assassino totalmente novo, mais letal que seus antecessores. Cace suas presas com uma gama de novas armas, tais como a L\\u00E2mina Fantasma, uma L\\u00E2mina Oculta com a capacidade de disparar como uma besta.\",\"CodigoBarras\":\"SKU9\",\"AlturaCm\":1,\"LarguraCm\":1,\"ProfundidadeCm\":1,\"PesoGramas\":1,\"PrecoCusto\":0,\"PrecoVenda\":0,\"Ativo\":true,\"PlataformaID\":4,\"Plataforma\":null,\"DesenvolvedoraID\":13,\"Desenvolvedora\":null,\"PublicadoraID\":7,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":2,\"Nome\":\"Aventura\",\"Descricao\":\"Jogos que enfatizam a explora\\u00E7\\u00E3o e a resolu\\u00E7\\u00E3o de quebra-cabe\\u00E7as em uma narrativa.\",\"Produtos\":[null]},{\"ID\":7,\"Nome\":\"Luta\",\"Descricao\":\"Jogos de combate um contra um entre um n\\u00FAmero limitado de personagens.\",\"Produtos\":[null]},{\"ID\":10,\"Nome\":\"Plataforma\",\"Descricao\":\"Jogos cujo principal desafio \\u00E9 pular e escalar entre plataformas suspensas.\",\"Produtos\":[null]},{\"ID\":11,\"Nome\":\"Mundo Aberto\",\"Descricao\":\"Jogos que apresentam um vasto mapa explor\\u00E1vel com miss\\u00F5es principais e secund\\u00E1rias n\\u00E3o-lineares.\",\"Produtos\":[null]}]}',NULL),(11,'2025-08-31 15:36:20',1,'INSERÇÃO','Produto',10,NULL,'{\"ID\":10,\"Nome\":\"Digimon Story: Cyber Sleuth\",\"URLImagem\":\"https://m.media-amazon.com/images/I/81ws0fAQ2NL.jpg\",\"AnoLancamento\":2017,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"MUNDOS V\\u00CDVIDOS E IMERSIVOS\\r\\nEmbarque em uma aventura emocionante onde a linha entre o mundo real e o mundo digital \\u00E9 turva.\",\"CodigoBarras\":\"SKU10\",\"AlturaCm\":1,\"LarguraCm\":1,\"ProfundidadeCm\":1,\"PesoGramas\":1,\"PrecoCusto\":0,\"PrecoVenda\":0,\"Ativo\":true,\"PlataformaID\":2,\"Plataforma\":null,\"DesenvolvedoraID\":10,\"Desenvolvedora\":null,\"PublicadoraID\":4,\"Publicadora\":null,\"GrupoPrecificacaoID\":3,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":2,\"Nome\":\"Aventura\",\"Descricao\":\"Jogos que enfatizam a explora\\u00E7\\u00E3o e a resolu\\u00E7\\u00E3o de quebra-cabe\\u00E7as em uma narrativa.\",\"Produtos\":[null]},{\"ID\":3,\"Nome\":\"RPG\",\"Descricao\":\"Jogos de interpreta\\u00E7\\u00E3o de pap\\u00E9is com foco no desenvolvimento de personagens e hist\\u00F3rias complexas.\",\"Produtos\":[null]}]}',NULL),(12,'2025-08-31 17:01:55',1,'ALTERAÇÃO','Produto',2,'{\"ID\":2,\"Nome\":\"Starfield\",\"URLImagem\":\"https://http2.mlstatic.com/D_NQ_NP_776642-MLU73417729993_122023-O.webp\",\"AnoLancamento\":2023,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"Em Starfield, a hist\\u00F3ria mais importante \\u00E9 a que voc\\u00EA conta com seu personagem. Comece a jornada personalizando sua apar\\u00EAncia e decidindo seu hist\\u00F3rico e atributos. Voc\\u00EA ser\\u00E1 um explorador experiente, um diplomata charmoso, um ciberita furtivo ou algo completamente diferente? A escolha \\u00E9 sua. Decida quem voc\\u00EA ser\\u00E1 e o que se tornar\\u00E1.\",\"CodigoBarras\":\"SKU2\",\"AlturaCm\":1.00,\"LarguraCm\":1.00,\"ProfundidadeCm\":1.00,\"PesoGramas\":1.00,\"PrecoCusto\":200.00,\"PrecoVenda\":280.00,\"Ativo\":true,\"PlataformaID\":3,\"Plataforma\":null,\"DesenvolvedoraID\":12,\"Desenvolvedora\":null,\"PublicadoraID\":12,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":2,\"Nome\":\"Aventura\",\"Descricao\":\"Jogos que enfatizam a explora\\u00E7\\u00E3o e a resolu\\u00E7\\u00E3o de quebra-cabe\\u00E7as em uma narrativa.\",\"Produtos\":[null]},{\"ID\":3,\"Nome\":\"RPG\",\"Descricao\":\"Jogos de interpreta\\u00E7\\u00E3o de pap\\u00E9is com foco no desenvolvimento de personagens e hist\\u00F3rias complexas.\",\"Produtos\":[null]},{\"ID\":8,\"Nome\":\"Tiro\",\"Descricao\":\"Jogos com combate baseado em armas de fogo, em primeira ou terceira pessoa (FPS/TPS).\",\"Produtos\":[null]},{\"ID\":11,\"Nome\":\"Mundo Aberto\",\"Descricao\":\"Jogos que apresentam um vasto mapa explor\\u00E1vel com miss\\u00F5es principais e secund\\u00E1rias n\\u00E3o-lineares.\",\"Produtos\":[null]}]}','{\"ID\":2,\"Nome\":\"Starfield\",\"URLImagem\":\"https://http2.mlstatic.com/D_NQ_NP_776642-MLU73417729993_122023-O.webp\",\"AnoLancamento\":2023,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"Em Starfield, a hist\\u00F3ria mais importante \\u00E9 a que voc\\u00EA conta com seu personagem. Comece a jornada personalizando sua apar\\u00EAncia e decidindo seu hist\\u00F3rico e atributos. Voc\\u00EA ser\\u00E1 um explorador experiente, um diplomata charmoso, um ciberita furtivo ou algo completamente diferente? A escolha \\u00E9 sua. Decida quem voc\\u00EA ser\\u00E1 e o que se tornar\\u00E1.\",\"CodigoBarras\":\"SKU2\",\"AlturaCm\":1.00,\"LarguraCm\":1.00,\"ProfundidadeCm\":1.00,\"PesoGramas\":1.00,\"PrecoCusto\":200.00,\"PrecoVenda\":280.00,\"Ativo\":true,\"PlataformaID\":3,\"Plataforma\":null,\"DesenvolvedoraID\":12,\"Desenvolvedora\":null,\"PublicadoraID\":11,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":{\"ID\":1,\"Nome\":\"Lan\\u00E7amento AAA\",\"MargemLucro\":40.00},\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":2,\"Nome\":\"Aventura\",\"Descricao\":\"Jogos que enfatizam a explora\\u00E7\\u00E3o e a resolu\\u00E7\\u00E3o de quebra-cabe\\u00E7as em uma narrativa.\",\"Produtos\":[null]},{\"ID\":3,\"Nome\":\"RPG\",\"Descricao\":\"Jogos de interpreta\\u00E7\\u00E3o de pap\\u00E9is com foco no desenvolvimento de personagens e hist\\u00F3rias complexas.\",\"Produtos\":[null]},{\"ID\":8,\"Nome\":\"Tiro\",\"Descricao\":\"Jogos com combate baseado em armas de fogo, em primeira ou terceira pessoa (FPS/TPS).\",\"Produtos\":[null]},{\"ID\":11,\"Nome\":\"Mundo Aberto\",\"Descricao\":\"Jogos que apresentam um vasto mapa explor\\u00E1vel com miss\\u00F5es principais e secund\\u00E1rias n\\u00E3o-lineares.\",\"Produtos\":[null]}]}',NULL),(13,'2025-08-31 17:13:47',1,'ALTERAÇÃO','Produto',3,'{\"ID\":3,\"Nome\":\"Pokemon Legends Arceus\",\"URLImagem\":\"https://m.media-amazon.com/images/I/71bhNf8QiOS.jpg\",\"AnoLancamento\":2022,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"Prepare-se para um novo tipo de grande aventura Pok\\u00E9mon em Pok\\u00E9mon Legends: Arceus, um jogo totalmente novo da Game Freak que combina a\\u00E7\\u00E3o e explora\\u00E7\\u00E3o com as ra\\u00EDzes de RPG da s\\u00E9rie Pok\\u00E9mon. Embarque em miss\\u00F5es de pesquisa na antiga regi\\u00E3o de Hisui. Explore extens\\u00F5es naturais para capturar Pok\\u00E9mon selvagens, aprendendo seu comportamento, aproximando-se sorrateiramente e jogando uma Pok\\u00E9 Ball bem direcionada. Voc\\u00EA tamb\\u00E9m pode jogar a Pok\\u00E9 Ball contendo seu Pok\\u00E9mon aliado perto de um Pok\\u00E9mon selvagem para entrar na batalha sem problemas.\",\"CodigoBarras\":\"SKU3\",\"AlturaCm\":1.00,\"LarguraCm\":1.00,\"ProfundidadeCm\":1.00,\"PesoGramas\":1.00,\"PrecoCusto\":300.00,\"PrecoVenda\":420.00,\"Ativo\":true,\"PlataformaID\":5,\"Plataforma\":null,\"DesenvolvedoraID\":6,\"Desenvolvedora\":null,\"PublicadoraID\":2,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":2,\"Nome\":\"Aventura\",\"Descricao\":\"Jogos que enfatizam a explora\\u00E7\\u00E3o e a resolu\\u00E7\\u00E3o de quebra-cabe\\u00E7as em uma narrativa.\",\"Produtos\":[null]},{\"ID\":3,\"Nome\":\"RPG\",\"Descricao\":\"Jogos de interpreta\\u00E7\\u00E3o de pap\\u00E9is com foco no desenvolvimento de personagens e hist\\u00F3rias complexas.\",\"Produtos\":[null]},{\"ID\":11,\"Nome\":\"Mundo Aberto\",\"Descricao\":\"Jogos que apresentam um vasto mapa explor\\u00E1vel com miss\\u00F5es principais e secund\\u00E1rias n\\u00E3o-lineares.\",\"Produtos\":[null]}]}','{\"ID\":3,\"Nome\":\"Pokemon Legends Arceus\",\"URLImagem\":\"https://m.media-amazon.com/images/I/71bhNf8QiOS.jpg\",\"AnoLancamento\":2022,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"Prepare-se para um novo tipo de grande aventura Pok\\u00E9mon em Pok\\u00E9mon Legends: Arceus, um jogo totalmente novo da Game Freak que combina a\\u00E7\\u00E3o e explora\\u00E7\\u00E3o com as ra\\u00EDzes de RPG da s\\u00E9rie Pok\\u00E9mon. Embarque em miss\\u00F5es de pesquisa na antiga regi\\u00E3o de Hisui. Explore extens\\u00F5es naturais para capturar Pok\\u00E9mon selvagens, aprendendo seu comportamento, aproximando-se sorrateiramente e jogando uma Pok\\u00E9 Ball bem direcionada. Voc\\u00EA tamb\\u00E9m pode jogar a Pok\\u00E9 Ball contendo seu Pok\\u00E9mon aliado perto de um Pok\\u00E9mon selvagem para entrar na batalha sem problemas.\",\"CodigoBarras\":\"SKU3\",\"AlturaCm\":1.00,\"LarguraCm\":1.00,\"ProfundidadeCm\":1.00,\"PesoGramas\":1.00,\"PrecoCusto\":300.00,\"PrecoVenda\":420.00,\"Ativo\":true,\"PlataformaID\":5,\"Plataforma\":null,\"DesenvolvedoraID\":14,\"Desenvolvedora\":null,\"PublicadoraID\":2,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":{\"ID\":1,\"Nome\":\"Lan\\u00E7amento AAA\",\"MargemLucro\":40.00},\"Categorias\":[{\"ID\":2,\"Nome\":\"Aventura\",\"Descricao\":\"Jogos que enfatizam a explora\\u00E7\\u00E3o e a resolu\\u00E7\\u00E3o de quebra-cabe\\u00E7as em uma narrativa.\",\"Produtos\":[null]},{\"ID\":3,\"Nome\":\"RPG\",\"Descricao\":\"Jogos de interpreta\\u00E7\\u00E3o de pap\\u00E9is com foco no desenvolvimento de personagens e hist\\u00F3rias complexas.\",\"Produtos\":[null]},{\"ID\":11,\"Nome\":\"Mundo Aberto\",\"Descricao\":\"Jogos que apresentam um vasto mapa explor\\u00E1vel com miss\\u00F5es principais e secund\\u00E1rias n\\u00E3o-lineares.\",\"Produtos\":[null]}]}',NULL),(14,'2025-08-31 17:13:53',1,'ALTERAÇÃO','Produto',4,'{\"ID\":4,\"Nome\":\"Call of Duty: Black Ops 3\",\"URLImagem\":\"https://m.media-amazon.com/images/I/81bwynfO98L.jpg\",\"AnoLancamento\":2015,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"Call of Duty: Black Ops III \\u00E9 o jogo mais profundo e ambicioso da s\\u00E9rie ao combinar tr\\u00EAs modos de jogo \\u00FAnicos: campanha, multijogador e Zombies. A campanha foi criada para ser partilhada por 4 jogadores online ou desfrutada a solo numa emocionante experi\\u00EAncia cinem\\u00E1tica. O multijogador ser\\u00E1 o mais profundo e gratificante da s\\u00E9rie, com novas formas para subir de n\\u00EDvel, modificar a personagem e prepar\\u00E1-la para a batalha. J\\u00E1 o modo Zombies proporciona uma nova experi\\u00EAncia com uma narrativa dedicada. Este t\\u00EDtulo introduz um n\\u00EDvel de inova\\u00E7\\u00E3o sem precedentes incluindo cen\\u00E1rios arrasadores, armamento e habilidades in\\u00E9ditos e a introdu\\u00E7\\u00E3o de um novo sistema de movimento fluido e melhorado.\",\"CodigoBarras\":\"SKU4\",\"AlturaCm\":1.00,\"LarguraCm\":1.00,\"ProfundidadeCm\":1.00,\"PesoGramas\":1.00,\"PrecoCusto\":100.00,\"PrecoVenda\":140.00,\"Ativo\":true,\"PlataformaID\":4,\"Plataforma\":null,\"DesenvolvedoraID\":8,\"Desenvolvedora\":null,\"PublicadoraID\":12,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":8,\"Nome\":\"Tiro\",\"Descricao\":\"Jogos com combate baseado em armas de fogo, em primeira ou terceira pessoa (FPS/TPS).\",\"Produtos\":[null]},{\"ID\":12,\"Nome\":\"Simula\\u00E7\\u00E3o\",\"Descricao\":\"Jogos que recriam atividades e sistemas do mundo real com o m\\u00E1ximo de fidelidade poss\\u00EDvel.\",\"Produtos\":[null]}]}','{\"ID\":4,\"Nome\":\"Call of Duty: Black Ops 3\",\"URLImagem\":\"https://m.media-amazon.com/images/I/81bwynfO98L.jpg\",\"AnoLancamento\":2015,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"Call of Duty: Black Ops III \\u00E9 o jogo mais profundo e ambicioso da s\\u00E9rie ao combinar tr\\u00EAs modos de jogo \\u00FAnicos: campanha, multijogador e Zombies. A campanha foi criada para ser partilhada por 4 jogadores online ou desfrutada a solo numa emocionante experi\\u00EAncia cinem\\u00E1tica. O multijogador ser\\u00E1 o mais profundo e gratificante da s\\u00E9rie, com novas formas para subir de n\\u00EDvel, modificar a personagem e prepar\\u00E1-la para a batalha. J\\u00E1 o modo Zombies proporciona uma nova experi\\u00EAncia com uma narrativa dedicada. Este t\\u00EDtulo introduz um n\\u00EDvel de inova\\u00E7\\u00E3o sem precedentes incluindo cen\\u00E1rios arrasadores, armamento e habilidades in\\u00E9ditos e a introdu\\u00E7\\u00E3o de um novo sistema de movimento fluido e melhorado.\",\"CodigoBarras\":\"SKU4\",\"AlturaCm\":1.00,\"LarguraCm\":1.00,\"ProfundidadeCm\":1.00,\"PesoGramas\":1.00,\"PrecoCusto\":100.00,\"PrecoVenda\":140.00,\"Ativo\":true,\"PlataformaID\":4,\"Plataforma\":null,\"DesenvolvedoraID\":15,\"Desenvolvedora\":null,\"PublicadoraID\":12,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":{\"ID\":1,\"Nome\":\"Lan\\u00E7amento AAA\",\"MargemLucro\":40.00},\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":8,\"Nome\":\"Tiro\",\"Descricao\":\"Jogos com combate baseado em armas de fogo, em primeira ou terceira pessoa (FPS/TPS).\",\"Produtos\":[null]},{\"ID\":12,\"Nome\":\"Simula\\u00E7\\u00E3o\",\"Descricao\":\"Jogos que recriam atividades e sistemas do mundo real com o m\\u00E1ximo de fidelidade poss\\u00EDvel.\",\"Produtos\":[null]}]}',NULL),(15,'2025-08-31 17:14:01',1,'ALTERAÇÃO','Produto',5,'{\"ID\":5,\"Nome\":\"Resident Evil 2\",\"URLImagem\":\"https://m.media-amazon.com/images/I/71qWdMRpNGL.jpg\",\"AnoLancamento\":2019,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"Em Resident Evil 2, a a\\u00E7\\u00E3o cl\\u00E1ssica, explora\\u00E7\\u00E3o tensa e a jogabilidade de resolver quebra-cabe\\u00E7as que definiu a s\\u00E9rie Resident Evil retorna. Os jogadores se juntam ao policial novato, Leon S. Kennedy, e \\u00E0 estudante universit\\u00E1ria, Claire Redfield, que acabam juntos por uma epidemia desastrosa em Raccoon City que transformou sua popula\\u00E7\\u00E3o em zumbis mortais. Leon e Claire possuem suas pr\\u00F3prias campanhas separadas, permitindo que os jogadores vejam a hist\\u00F3ria da perspectiva de ambos os personagens. O destino desses dois personagens favoritos dos f\\u00E3s est\\u00E1 nas m\\u00E3os dos jogadores conforme eles trabalham juntos para sobreviver e descobrir o que est\\u00E1 por tr\\u00E1s do terr\\u00EDvel ataque \\u00E0 cidade. Ser\\u00E1 que eles sair\\u00E3o com vida?\",\"CodigoBarras\":\"SKU5\",\"AlturaCm\":1.00,\"LarguraCm\":1.00,\"ProfundidadeCm\":1.00,\"PesoGramas\":1.00,\"PrecoCusto\":120.00,\"PrecoVenda\":168.00,\"Ativo\":true,\"PlataformaID\":2,\"Plataforma\":null,\"DesenvolvedoraID\":9,\"Desenvolvedora\":null,\"PublicadoraID\":1,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":8,\"Nome\":\"Tiro\",\"Descricao\":\"Jogos com combate baseado em armas de fogo, em primeira ou terceira pessoa (FPS/TPS).\",\"Produtos\":[null]},{\"ID\":9,\"Nome\":\"Terror de Sobreviviv\\u00EAncia\",\"Descricao\":\"Jogos que buscam assustar o jogador, geralmente com recursos limitados e atmosfera tensa.\",\"Produtos\":[null]}]}','{\"ID\":5,\"Nome\":\"Resident Evil 2\",\"URLImagem\":\"https://m.media-amazon.com/images/I/71qWdMRpNGL.jpg\",\"AnoLancamento\":2019,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"Em Resident Evil 2, a a\\u00E7\\u00E3o cl\\u00E1ssica, explora\\u00E7\\u00E3o tensa e a jogabilidade de resolver quebra-cabe\\u00E7as que definiu a s\\u00E9rie Resident Evil retorna. Os jogadores se juntam ao policial novato, Leon S. Kennedy, e \\u00E0 estudante universit\\u00E1ria, Claire Redfield, que acabam juntos por uma epidemia desastrosa em Raccoon City que transformou sua popula\\u00E7\\u00E3o em zumbis mortais. Leon e Claire possuem suas pr\\u00F3prias campanhas separadas, permitindo que os jogadores vejam a hist\\u00F3ria da perspectiva de ambos os personagens. O destino desses dois personagens favoritos dos f\\u00E3s est\\u00E1 nas m\\u00E3os dos jogadores conforme eles trabalham juntos para sobreviver e descobrir o que est\\u00E1 por tr\\u00E1s do terr\\u00EDvel ataque \\u00E0 cidade. Ser\\u00E1 que eles sair\\u00E3o com vida?\",\"CodigoBarras\":\"SKU5\",\"AlturaCm\":1.00,\"LarguraCm\":1.00,\"ProfundidadeCm\":1.00,\"PesoGramas\":1.00,\"PrecoCusto\":120.00,\"PrecoVenda\":168.00,\"Ativo\":true,\"PlataformaID\":2,\"Plataforma\":null,\"DesenvolvedoraID\":9,\"Desenvolvedora\":null,\"PublicadoraID\":15,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":{\"ID\":1,\"Nome\":\"Lan\\u00E7amento AAA\",\"MargemLucro\":40.00},\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":8,\"Nome\":\"Tiro\",\"Descricao\":\"Jogos com combate baseado em armas de fogo, em primeira ou terceira pessoa (FPS/TPS).\",\"Produtos\":[null]},{\"ID\":9,\"Nome\":\"Terror de Sobreviviv\\u00EAncia\",\"Descricao\":\"Jogos que buscam assustar o jogador, geralmente com recursos limitados e atmosfera tensa.\",\"Produtos\":[null]}]}',NULL),(16,'2025-08-31 17:14:23',1,'ALTERAÇÃO','Produto',9,'{\"ID\":9,\"Nome\":\"Assassin\\u0027s Creed Unity\",\"URLImagem\":\"https://cdn.awsli.com.br/600x450/138/138431/produto/7988193/df7d2c8e0b.jpg\",\"AnoLancamento\":2014,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"UM NOVO HER\\u00D3I IMPLAC\\u00C1VEL PARA UM NOVO MUNDO BRUTAL\\r\\nJogue como Arno, um tipo de assassino totalmente novo, mais letal que seus antecessores. Cace suas presas com uma gama de novas armas, tais como a L\\u00E2mina Fantasma, uma L\\u00E2mina Oculta com a capacidade de disparar como uma besta.\",\"CodigoBarras\":\"SKU9\",\"AlturaCm\":1.00,\"LarguraCm\":1.00,\"ProfundidadeCm\":1.00,\"PesoGramas\":1.00,\"PrecoCusto\":100.00,\"PrecoVenda\":140.00,\"Ativo\":true,\"PlataformaID\":4,\"Plataforma\":null,\"DesenvolvedoraID\":13,\"Desenvolvedora\":null,\"PublicadoraID\":7,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":2,\"Nome\":\"Aventura\",\"Descricao\":\"Jogos que enfatizam a explora\\u00E7\\u00E3o e a resolu\\u00E7\\u00E3o de quebra-cabe\\u00E7as em uma narrativa.\",\"Produtos\":[null]},{\"ID\":7,\"Nome\":\"Luta\",\"Descricao\":\"Jogos de combate um contra um entre um n\\u00FAmero limitado de personagens.\",\"Produtos\":[null]},{\"ID\":10,\"Nome\":\"Plataforma\",\"Descricao\":\"Jogos cujo principal desafio \\u00E9 pular e escalar entre plataformas suspensas.\",\"Produtos\":[null]},{\"ID\":11,\"Nome\":\"Mundo Aberto\",\"Descricao\":\"Jogos que apresentam um vasto mapa explor\\u00E1vel com miss\\u00F5es principais e secund\\u00E1rias n\\u00E3o-lineares.\",\"Produtos\":[null]}]}','{\"ID\":9,\"Nome\":\"Assassin\\u0027s Creed Unity\",\"URLImagem\":\"https://cdn.awsli.com.br/600x450/138/138431/produto/7988193/df7d2c8e0b.jpg\",\"AnoLancamento\":2014,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"UM NOVO HER\\u00D3I IMPLAC\\u00C1VEL PARA UM NOVO MUNDO BRUTAL\\r\\nJogue como Arno, um tipo de assassino totalmente novo, mais letal que seus antecessores. Cace suas presas com uma gama de novas armas, tais como a L\\u00E2mina Fantasma, uma L\\u00E2mina Oculta com a capacidade de disparar como uma besta.\",\"CodigoBarras\":\"SKU9\",\"AlturaCm\":1.00,\"LarguraCm\":1.00,\"ProfundidadeCm\":1.00,\"PesoGramas\":1.00,\"PrecoCusto\":100.00,\"PrecoVenda\":140.00,\"Ativo\":true,\"PlataformaID\":4,\"Plataforma\":null,\"DesenvolvedoraID\":16,\"Desenvolvedora\":null,\"PublicadoraID\":7,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":{\"ID\":1,\"Nome\":\"Lan\\u00E7amento AAA\",\"MargemLucro\":40.00},\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":2,\"Nome\":\"Aventura\",\"Descricao\":\"Jogos que enfatizam a explora\\u00E7\\u00E3o e a resolu\\u00E7\\u00E3o de quebra-cabe\\u00E7as em uma narrativa.\",\"Produtos\":[null]},{\"ID\":7,\"Nome\":\"Luta\",\"Descricao\":\"Jogos de combate um contra um entre um n\\u00FAmero limitado de personagens.\",\"Produtos\":[null]},{\"ID\":10,\"Nome\":\"Plataforma\",\"Descricao\":\"Jogos cujo principal desafio \\u00E9 pular e escalar entre plataformas suspensas.\",\"Produtos\":[null]},{\"ID\":11,\"Nome\":\"Mundo Aberto\",\"Descricao\":\"Jogos que apresentam um vasto mapa explor\\u00E1vel com miss\\u00F5es principais e secund\\u00E1rias n\\u00E3o-lineares.\",\"Produtos\":[null]}]}',NULL),(17,'2025-08-31 17:14:29',1,'ALTERAÇÃO','Produto',10,'{\"ID\":10,\"Nome\":\"Digimon Story: Cyber Sleuth\",\"URLImagem\":\"https://m.media-amazon.com/images/I/81ws0fAQ2NL.jpg\",\"AnoLancamento\":2017,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"MUNDOS V\\u00CDVIDOS E IMERSIVOS\\r\\nEmbarque em uma aventura emocionante onde a linha entre o mundo real e o mundo digital \\u00E9 turva.\",\"CodigoBarras\":\"SKU10\",\"AlturaCm\":1.00,\"LarguraCm\":1.00,\"ProfundidadeCm\":1.00,\"PesoGramas\":1.00,\"PrecoCusto\":100.00,\"PrecoVenda\":125.50,\"Ativo\":true,\"PlataformaID\":2,\"Plataforma\":null,\"DesenvolvedoraID\":10,\"Desenvolvedora\":null,\"PublicadoraID\":4,\"Publicadora\":null,\"GrupoPrecificacaoID\":3,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":2,\"Nome\":\"Aventura\",\"Descricao\":\"Jogos que enfatizam a explora\\u00E7\\u00E3o e a resolu\\u00E7\\u00E3o de quebra-cabe\\u00E7as em uma narrativa.\",\"Produtos\":[null]},{\"ID\":3,\"Nome\":\"RPG\",\"Descricao\":\"Jogos de interpreta\\u00E7\\u00E3o de pap\\u00E9is com foco no desenvolvimento de personagens e hist\\u00F3rias complexas.\",\"Produtos\":[null]}]}','{\"ID\":10,\"Nome\":\"Digimon Story: Cyber Sleuth\",\"URLImagem\":\"https://m.media-amazon.com/images/I/81ws0fAQ2NL.jpg\",\"AnoLancamento\":2017,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"MUNDOS V\\u00CDVIDOS E IMERSIVOS\\r\\nEmbarque em uma aventura emocionante onde a linha entre o mundo real e o mundo digital \\u00E9 turva.\",\"CodigoBarras\":\"SKU10\",\"AlturaCm\":1.00,\"LarguraCm\":1.00,\"ProfundidadeCm\":1.00,\"PesoGramas\":1.00,\"PrecoCusto\":100.00,\"PrecoVenda\":125.50,\"Ativo\":true,\"PlataformaID\":2,\"Plataforma\":null,\"DesenvolvedoraID\":17,\"Desenvolvedora\":null,\"PublicadoraID\":4,\"Publicadora\":null,\"GrupoPrecificacaoID\":3,\"GrupoPrecificacao\":{\"ID\":3,\"Nome\":\"Promo\\u00E7\\u00E3o\",\"MargemLucro\":25.50},\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":2,\"Nome\":\"Aventura\",\"Descricao\":\"Jogos que enfatizam a explora\\u00E7\\u00E3o e a resolu\\u00E7\\u00E3o de quebra-cabe\\u00E7as em uma narrativa.\",\"Produtos\":[null]},{\"ID\":3,\"Nome\":\"RPG\",\"Descricao\":\"Jogos de interpreta\\u00E7\\u00E3o de pap\\u00E9is com foco no desenvolvimento de personagens e hist\\u00F3rias complexas.\",\"Produtos\":[null]}]}',NULL),(18,'2025-08-31 17:14:39',1,'ALTERAÇÃO','Produto',4,'{\"ID\":4,\"Nome\":\"Call of Duty: Black Ops 3\",\"URLImagem\":\"https://m.media-amazon.com/images/I/81bwynfO98L.jpg\",\"AnoLancamento\":2015,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"Call of Duty: Black Ops III \\u00E9 o jogo mais profundo e ambicioso da s\\u00E9rie ao combinar tr\\u00EAs modos de jogo \\u00FAnicos: campanha, multijogador e Zombies. A campanha foi criada para ser partilhada por 4 jogadores online ou desfrutada a solo numa emocionante experi\\u00EAncia cinem\\u00E1tica. O multijogador ser\\u00E1 o mais profundo e gratificante da s\\u00E9rie, com novas formas para subir de n\\u00EDvel, modificar a personagem e prepar\\u00E1-la para a batalha. J\\u00E1 o modo Zombies proporciona uma nova experi\\u00EAncia com uma narrativa dedicada. Este t\\u00EDtulo introduz um n\\u00EDvel de inova\\u00E7\\u00E3o sem precedentes incluindo cen\\u00E1rios arrasadores, armamento e habilidades in\\u00E9ditos e a introdu\\u00E7\\u00E3o de um novo sistema de movimento fluido e melhorado.\",\"CodigoBarras\":\"SKU4\",\"AlturaCm\":1.00,\"LarguraCm\":1.00,\"ProfundidadeCm\":1.00,\"PesoGramas\":1.00,\"PrecoCusto\":100.00,\"PrecoVenda\":140.00,\"Ativo\":true,\"PlataformaID\":4,\"Plataforma\":null,\"DesenvolvedoraID\":15,\"Desenvolvedora\":null,\"PublicadoraID\":12,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":null,\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":8,\"Nome\":\"Tiro\",\"Descricao\":\"Jogos com combate baseado em armas de fogo, em primeira ou terceira pessoa (FPS/TPS).\",\"Produtos\":[null]},{\"ID\":12,\"Nome\":\"Simula\\u00E7\\u00E3o\",\"Descricao\":\"Jogos que recriam atividades e sistemas do mundo real com o m\\u00E1ximo de fidelidade poss\\u00EDvel.\",\"Produtos\":[null]}]}','{\"ID\":4,\"Nome\":\"Call of Duty: Black Ops 3\",\"URLImagem\":\"https://m.media-amazon.com/images/I/81bwynfO98L.jpg\",\"AnoLancamento\":2015,\"Edicao\":\"Edi\\u00E7\\u00E3o Padr\\u00E3o\",\"Sinopse\":\"Call of Duty: Black Ops III \\u00E9 o jogo mais profundo e ambicioso da s\\u00E9rie ao combinar tr\\u00EAs modos de jogo \\u00FAnicos: campanha, multijogador e Zombies. A campanha foi criada para ser partilhada por 4 jogadores online ou desfrutada a solo numa emocionante experi\\u00EAncia cinem\\u00E1tica. O multijogador ser\\u00E1 o mais profundo e gratificante da s\\u00E9rie, com novas formas para subir de n\\u00EDvel, modificar a personagem e prepar\\u00E1-la para a batalha. J\\u00E1 o modo Zombies proporciona uma nova experi\\u00EAncia com uma narrativa dedicada. Este t\\u00EDtulo introduz um n\\u00EDvel de inova\\u00E7\\u00E3o sem precedentes incluindo cen\\u00E1rios arrasadores, armamento e habilidades in\\u00E9ditos e a introdu\\u00E7\\u00E3o de um novo sistema de movimento fluido e melhorado.\",\"CodigoBarras\":\"SKU4\",\"AlturaCm\":1.00,\"LarguraCm\":1.00,\"ProfundidadeCm\":1.00,\"PesoGramas\":1.00,\"PrecoCusto\":100.00,\"PrecoVenda\":140.00,\"Ativo\":true,\"PlataformaID\":4,\"Plataforma\":null,\"DesenvolvedoraID\":15,\"Desenvolvedora\":null,\"PublicadoraID\":13,\"Publicadora\":null,\"GrupoPrecificacaoID\":1,\"GrupoPrecificacao\":{\"ID\":1,\"Nome\":\"Lan\\u00E7amento AAA\",\"MargemLucro\":40.00},\"Categorias\":[{\"ID\":1,\"Nome\":\"A\\u00E7\\u00E3o\",\"Descricao\":\"Jogos focados em desafios f\\u00EDsicos, incluindo combate, plataforma e explora\\u00E7\\u00E3o.\",\"Produtos\":[null]},{\"ID\":8,\"Nome\":\"Tiro\",\"Descricao\":\"Jogos com combate baseado em armas de fogo, em primeira ou terceira pessoa (FPS/TPS).\",\"Produtos\":[null]},{\"ID\":12,\"Nome\":\"Simula\\u00E7\\u00E3o\",\"Descricao\":\"Jogos que recriam atividades e sistemas do mundo real com o m\\u00E1ximo de fidelidade poss\\u00EDvel.\",\"Produtos\":[null]}]}',NULL),(19,'2025-08-31 17:56:59',NULL,'INSERÇÃO','Pedido',1,NULL,'{\"ID\":1,\"DataPedido\":\"2025-08-31T17:56:58.4801775-03:00\",\"ValorTotal\":280.00,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null}',NULL),(20,'2025-08-31 18:05:49',NULL,'INSERÇÃO','Pedido',2,NULL,'{\"ID\":2,\"DataPedido\":\"2025-08-31T18:05:48.3640334-03:00\",\"ValorTotal\":280.00,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null,\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":280.00,\"PedidoID\":2,\"Pedido\":null,\"ProdutoID\":1,\"Produto\":null}]}',NULL),(21,'2025-08-31 18:07:03',NULL,'INSERÇÃO','Pedido',3,NULL,'{\"ID\":3,\"DataPedido\":\"2025-08-31T18:07:02.8383678-03:00\",\"ValorTotal\":840.00,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null,\"ItensPedido\":[{\"Quantidade\":2,\"PrecoUnitario\":420.00,\"PedidoID\":3,\"Pedido\":null,\"ProdutoID\":3,\"Produto\":null}]}',NULL),(22,'2025-08-31 18:07:26',NULL,'INSERÇÃO','Pedido',4,NULL,'{\"ID\":4,\"DataPedido\":\"2025-08-31T18:07:25.8639247-03:00\",\"ValorTotal\":588.00,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null,\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":140.00,\"PedidoID\":4,\"Pedido\":null,\"ProdutoID\":4,\"Produto\":null},{\"Quantidade\":1,\"PrecoUnitario\":168.00,\"PedidoID\":4,\"Pedido\":null,\"ProdutoID\":5,\"Produto\":null},{\"Quantidade\":1,\"PrecoUnitario\":280.00,\"PedidoID\":4,\"Pedido\":null,\"ProdutoID\":6,\"Produto\":null}]}',NULL);
/*!40000 ALTER TABLE `logtransacoes` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `pais`
--

LOCK TABLES `pais` WRITE;
/*!40000 ALTER TABLE `pais` DISABLE KEYS */;
INSERT INTO `pais` VALUES (1,'Brasil');
/*!40000 ALTER TABLE `pais` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido`
--

LOCK TABLES `pedido` WRITE;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
INSERT INTO `pedido` VALUES (1,1,'2025-08-31 17:56:58',280.00,'EM PROCESSAMENTO'),(2,1,'2025-08-31 18:05:48',280.00,'EM PROCESSAMENTO'),(3,1,'2025-08-31 18:07:03',840.00,'EM PROCESSAMENTO'),(4,1,'2025-08-31 18:07:26',588.00,'EM PROCESSAMENTO');
/*!40000 ALTER TABLE `pedido` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `plataforma`
--

LOCK TABLES `plataforma` WRITE;
/*!40000 ALTER TABLE `plataforma` DISABLE KEYS */;
INSERT INTO `plataforma` VALUES (1,'PlayStation 5','Sony'),(2,'PlayStation 4','Sony'),(3,'Xbox Series X|S','Microsoft'),(4,'Xbox One','Microsoft'),(5,'Nintendo Switch','Nintendo');
/*!40000 ALTER TABLE `plataforma` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto`
--

LOCK TABLES `produto` WRITE;
/*!40000 ALTER TABLE `produto` DISABLE KEYS */;
INSERT INTO `produto` VALUES (1,1,'God of War Ragnarök','https://m.media-amazon.com/images/I/819bwWHNMJL.jpg',2022,'Edição Padrão','UM FUTURO NÃO ESCRITO\r\nAtreus busca conhecimento para entender a profecia de \"\"Loki\"\" e definir o papel dele no Ragnarök. Kratos deve se desacorrentar do medo de repetir erros do passado para ser o pai que Atreus precisa.','SKU1',1.00,1.00,1.00,1.00,200.00,280.00,1,2,1,1),(2,3,'Starfield','https://http2.mlstatic.com/D_NQ_NP_776642-MLU73417729993_122023-O.webp',2023,'Edição Padrão','Em Starfield, a história mais importante é a que você conta com seu personagem. Comece a jornada personalizando sua aparência e decidindo seu histórico e atributos. Você será um explorador experiente, um diplomata charmoso, um ciberita furtivo ou algo completamente diferente? A escolha é sua. Decida quem você será e o que se tornará.','SKU2',1.00,1.00,1.00,1.00,200.00,280.00,1,12,11,1),(3,5,'Pokemon Legends Arceus','https://m.media-amazon.com/images/I/71bhNf8QiOS.jpg',2022,'Edição Padrão','Prepare-se para um novo tipo de grande aventura Pokémon em Pokémon Legends: Arceus, um jogo totalmente novo da Game Freak que combina ação e exploração com as raízes de RPG da série Pokémon. Embarque em missões de pesquisa na antiga região de Hisui. Explore extensões naturais para capturar Pokémon selvagens, aprendendo seu comportamento, aproximando-se sorrateiramente e jogando uma Poké Ball bem direcionada. Você também pode jogar a Poké Ball contendo seu Pokémon aliado perto de um Pokémon selvagem para entrar na batalha sem problemas.','SKU3',1.00,1.00,1.00,1.00,300.00,420.00,1,14,2,1),(4,4,'Call of Duty: Black Ops 3','https://m.media-amazon.com/images/I/81bwynfO98L.jpg',2015,'Edição Padrão','Call of Duty: Black Ops III é o jogo mais profundo e ambicioso da série ao combinar três modos de jogo únicos: campanha, multijogador e Zombies. A campanha foi criada para ser partilhada por 4 jogadores online ou desfrutada a solo numa emocionante experiência cinemática. O multijogador será o mais profundo e gratificante da série, com novas formas para subir de nível, modificar a personagem e prepará-la para a batalha. Já o modo Zombies proporciona uma nova experiência com uma narrativa dedicada. Este título introduz um nível de inovação sem precedentes incluindo cenários arrasadores, armamento e habilidades inéditos e a introdução de um novo sistema de movimento fluido e melhorado.','SKU4',1.00,1.00,1.00,1.00,100.00,140.00,1,15,13,1),(5,2,'Resident Evil 2','https://m.media-amazon.com/images/I/71qWdMRpNGL.jpg',2019,'Edição Padrão','Em Resident Evil 2, a ação clássica, exploração tensa e a jogabilidade de resolver quebra-cabeças que definiu a série Resident Evil retorna. Os jogadores se juntam ao policial novato, Leon S. Kennedy, e à estudante universitária, Claire Redfield, que acabam juntos por uma epidemia desastrosa em Raccoon City que transformou sua população em zumbis mortais. Leon e Claire possuem suas próprias campanhas separadas, permitindo que os jogadores vejam a história da perspectiva de ambos os personagens. O destino desses dois personagens favoritos dos fãs está nas mãos dos jogadores conforme eles trabalham juntos para sobreviver e descobrir o que está por trás do terrível ataque à cidade. Será que eles sairão com vida?','SKU5',1.00,1.00,1.00,1.00,120.00,168.00,1,9,15,1),(6,1,'Marvel\'s Spider-Man 2','https://m.media-amazon.com/images/I/81Zh-3T1enL.jpg',2023,'Edição Padrão','Uma cidade sitiada!\r\nOs Spiders Peter Parker e Miles Morales encaram a maior prova de força com e sem suas máscaras enquanto lutam para salvar a cidade, um ao outro e as pessoas que amam do monstruoso Venom e da nova e perigosa ameaça: os simbiontes.','SKU6',1.00,1.00,1.00,1.00,200.00,280.00,1,7,1,1),(7,3,'Forza Horizon 5','https://media.gamestop.com/i/gamestop/11148773.jpg',2021,'Edição Padrão','Sua Maior Aventura Horizon espera por você! Explore as paisagens vibrantes de mundo aberto do México, com diversão e velocidade sem limites em um mundo em constante evolução, incluindo centenas dos melhores carros do mundo.','SKU7',1.00,1.00,1.00,1.00,200.00,280.00,1,13,3,1),(8,5,'The Legend of Zelda: Tears of Kingdom','https://images.kabum.com.br/produtos/fotos/sync_mirakl/464339/xlarge/Jogo-The-Legend-Of-Zelda-Tears-Of-The-Kingdom-Nintendo-Switch-Midia-F-sica_1751918394.jpg',2023,'Edição Padrão','VIVA ESTA AVENTURA INCOMPARÁVEL. Uma aventura épica pela terra e pelos céus de Hyrule aguarda em The Legend of Zelda: Tears of the Kingdom, para o console Nintendo Switch. A aventura será criada por você, em um mundo alimentado pela sua imaginação.','SKU8',1.00,1.00,1.00,1.00,300.00,420.00,1,6,2,1),(9,4,'Assassin\'s Creed Unity','https://cdn.awsli.com.br/600x450/138/138431/produto/7988193/df7d2c8e0b.jpg',2014,'Edição Padrão','UM NOVO HERÓI IMPLACÁVEL PARA UM NOVO MUNDO BRUTAL\r\nJogue como Arno, um tipo de assassino totalmente novo, mais letal que seus antecessores. Cace suas presas com uma gama de novas armas, tais como a Lâmina Fantasma, uma Lâmina Oculta com a capacidade de disparar como uma besta.','SKU9',1.00,1.00,1.00,1.00,100.00,140.00,1,16,7,1),(10,2,'Digimon Story: Cyber Sleuth','https://m.media-amazon.com/images/I/81ws0fAQ2NL.jpg',2017,'Edição Padrão','MUNDOS VÍVIDOS E IMERSIVOS\r\nEmbarque em uma aventura emocionante onde a linha entre o mundo real e o mundo digital é turva.','SKU10',1.00,1.00,1.00,1.00,100.00,125.50,1,17,4,3);
/*!40000 ALTER TABLE `produto` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `produtocategoria`
--

LOCK TABLES `produtocategoria` WRITE;
/*!40000 ALTER TABLE `produtocategoria` DISABLE KEYS */;
INSERT INTO `produtocategoria` VALUES (1,1),(1,2),(1,3),(1,11),(2,1),(2,2),(2,3),(2,8),(2,11),(3,2),(3,3),(3,11),(4,1),(4,8),(4,12),(5,1),(5,8),(5,9),(6,1),(6,2),(6,7),(6,11),(7,2),(7,4),(7,5),(8,1),(8,2),(8,3),(8,11),(9,1),(9,2),(9,7),(9,10),(9,11),(10,1),(10,2),(10,3);
/*!40000 ALTER TABLE `produtocategoria` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publicadora`
--

LOCK TABLES `publicadora` WRITE;
/*!40000 ALTER TABLE `publicadora` DISABLE KEYS */;
INSERT INTO `publicadora` VALUES (13,'Activision'),(4,'Bandai Namco Entertainment'),(11,'Bethesda Softworks'),(15,'Capcom'),(6,'Electronic Arts (EA)'),(3,'Microsoft (Xbox Game Studios)'),(12,'Microsoft Studios'),(2,'Nintendo'),(9,'Sega'),(1,'Sony Interactive Entertainment'),(5,'Take-Two Interactive'),(10,'Team Cherry'),(14,'Treyarch'),(7,'Ubisoft'),(8,'Warner Bros. Games');
/*!40000 ALTER TABLE `publicadora` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `telefone`
--

LOCK TABLES `telefone` WRITE;
/*!40000 ALTER TABLE `telefone` DISABLE KEYS */;
INSERT INTO `telefone` VALUES (1,1,1,'11','98765-4321');
/*!40000 ALTER TABLE `telefone` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `tipo_endereco`
--

LOCK TABLES `tipo_endereco` WRITE;
/*!40000 ALTER TABLE `tipo_endereco` DISABLE KEYS */;
INSERT INTO `tipo_endereco` VALUES (1,'Entrega'),(2,'Cobrança');
/*!40000 ALTER TABLE `tipo_endereco` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `tipo_logradouro`
--

LOCK TABLES `tipo_logradouro` WRITE;
/*!40000 ALTER TABLE `tipo_logradouro` DISABLE KEYS */;
INSERT INTO `tipo_logradouro` VALUES (1,'Rua'),(2,'Avenida'),(3,'Praça'),(4,'Alameda'),(5,'Travessa'),(6,'Estrada');
/*!40000 ALTER TABLE `tipo_logradouro` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `tipo_residencia`
--

LOCK TABLES `tipo_residencia` WRITE;
/*!40000 ALTER TABLE `tipo_residencia` DISABLE KEYS */;
INSERT INTO `tipo_residencia` VALUES (1,'Casa'),(2,'Apartamento'),(3,'Condomínio'),(4,'Comercial');
/*!40000 ALTER TABLE `tipo_residencia` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Dumping data for table `tipo_telefone`
--

LOCK TABLES `tipo_telefone` WRITE;
/*!40000 ALTER TABLE `tipo_telefone` DISABLE KEYS */;
INSERT INTO `tipo_telefone` VALUES (1,'Celular'),(2,'Residencial'),(3,'Comercial');
/*!40000 ALTER TABLE `tipo_telefone` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-31 19:58:52
