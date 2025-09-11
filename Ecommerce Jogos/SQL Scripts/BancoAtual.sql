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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cartao`
--

LOCK TABLES `cartao` WRITE;
/*!40000 ALTER TABLE `cartao` DISABLE KEYS */;
INSERT INTO `cartao` VALUES (1,1,'Igor F de Matos','3456','Visa','12/2026',1),(2,1,'Igor','4444','Visa','12/2026',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
-- Table structure for table `cupom`
--

DROP TABLE IF EXISTS `cupom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cupom` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Codigo` varchar(50) NOT NULL COMMENT 'O código que o cliente digita (ex: TROCA123 ou NATAL20).',
  `Tipo` varchar(20) NOT NULL COMMENT 'Pode ser "TROCA" ou "PROMOCIONAL".',
  `Valor` decimal(10,2) NOT NULL COMMENT 'O valor do cupom em Reais.',
  `DataCriacao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DataValidade` datetime DEFAULT NULL COMMENT 'Data de expiração do cupom, se aplicável.',
  `Ativo` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Indica se o cupom pode ser utilizado.',
  `ClienteID` int DEFAULT NULL COMMENT 'Se for um cupom de troca, vincula ao cliente específico.',
  `PedidoOrigemID` int DEFAULT NULL COMMENT 'Se for um cupom de troca, indica o pedido que gerou a troca.',
  `PedidoUsoID` int DEFAULT NULL COMMENT 'Indica em qual pedido este cupom foi utilizado.',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Codigo` (`Codigo`),
  KEY `ClienteID` (`ClienteID`),
  KEY `PedidoOrigemID` (`PedidoOrigemID`),
  KEY `PedidoUsoID` (`PedidoUsoID`),
  CONSTRAINT `cupom_ibfk_1` FOREIGN KEY (`ClienteID`) REFERENCES `cliente` (`ID`),
  CONSTRAINT `cupom_ibfk_2` FOREIGN KEY (`PedidoOrigemID`) REFERENCES `pedido` (`ID`),
  CONSTRAINT `cupom_ibfk_3` FOREIGN KEY (`PedidoUsoID`) REFERENCES `pedido` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Armazena cupons de troca e promocionais.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cupom`
--

LOCK TABLES `cupom` WRITE;
/*!40000 ALTER TABLE `cupom` DISABLE KEYS */;
INSERT INTO `cupom` VALUES (1,'CUPOM1','PROMOCIONAL',15.00,'2025-09-07 13:08:15','2025-12-31 23:59:59',1,NULL,NULL,NULL),(2,'CUPOM2','PROMOCIONAL',50.00,'2025-09-07 13:08:15','2025-10-31 23:59:59',1,NULL,NULL,NULL),(4,'TROCA-1-638928525209082389','TROCA',280.00,'2025-09-07 14:35:21',NULL,0,1,1,6);
/*!40000 ALTER TABLE `cupom` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entradaestoque`
--

LOCK TABLES `entradaestoque` WRITE;
/*!40000 ALTER TABLE `entradaestoque` DISABLE KEYS */;
INSERT INTO `entradaestoque` VALUES (1,1,1,10,200.00,'2025-09-07 00:00:00'),(3,1,NULL,-1,0.00,'2025-09-07 13:01:47'),(4,1,NULL,-1,0.00,'2025-09-07 13:02:17'),(5,2,2,10,200.00,'2025-09-07 00:00:00'),(6,3,3,10,300.00,'2025-09-07 00:00:00'),(7,4,4,5,150.00,'2025-09-07 00:00:00'),(8,5,5,5,150.00,'2025-09-07 00:00:00'),(9,6,1,10,200.00,'2025-09-07 00:00:00'),(10,7,2,10,200.00,'2025-09-07 00:00:00'),(11,8,3,10,300.00,'2025-09-07 00:00:00'),(12,9,4,5,100.00,'2025-09-07 00:00:00'),(13,10,5,5,100.00,'2025-09-07 00:00:00'),(14,1,NULL,-1,0.00,'2025-09-07 14:07:59'),(15,1,NULL,-1,0.00,'2025-09-07 14:18:29'),(16,1,NULL,-1,0.00,'2025-09-07 14:24:52'),(17,1,NULL,1,0.00,'2025-09-07 14:35:21'),(18,3,NULL,-1,0.00,'2025-09-07 14:36:29'),(19,5,NULL,-1,0.00,'2025-09-10 14:15:51'),(20,9,NULL,-1,0.00,'2025-09-10 14:18:55'),(21,4,NULL,-1,0.00,'2025-09-10 14:33:56'),(22,8,NULL,-1,0.00,'2025-09-10 14:34:54'),(23,8,NULL,1,0.00,'2025-09-10 14:34:56'),(24,9,NULL,-1,0.00,'2025-09-10 14:48:48'),(25,9,NULL,1,0.00,'2025-09-10 14:48:50'),(26,7,NULL,-1,0.00,'2025-09-10 14:51:52'),(27,7,NULL,1,0.00,'2025-09-10 14:51:54'),(28,2,NULL,-1,0.00,'2025-09-10 14:56:07'),(29,2,NULL,1,0.00,'2025-09-10 14:56:10');
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
INSERT INTO `itempedido` VALUES (1,1,1,280.00),(2,1,1,280.00),(3,1,1,280.00),(4,1,1,280.00),(5,1,1,280.00),(6,3,1,420.00),(7,5,1,210.00),(8,9,1,140.00),(9,4,1,210.00),(10,8,1,420.00),(11,9,1,140.00),(12,7,1,280.00),(13,2,1,280.00);
/*!40000 ALTER TABLE `itempedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itemtroca`
--

DROP TABLE IF EXISTS `itemtroca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `itemtroca` (
  `TrocaID` int NOT NULL,
  `ItemPedidoPedidoID` int NOT NULL,
  `ItemPedidoProdutoID` int NOT NULL,
  PRIMARY KEY (`TrocaID`,`ItemPedidoPedidoID`,`ItemPedidoProdutoID`),
  KEY `ItemPedidoPedidoID` (`ItemPedidoPedidoID`,`ItemPedidoProdutoID`),
  CONSTRAINT `itemtroca_ibfk_1` FOREIGN KEY (`TrocaID`) REFERENCES `troca` (`ID`),
  CONSTRAINT `itemtroca_ibfk_2` FOREIGN KEY (`ItemPedidoPedidoID`, `ItemPedidoProdutoID`) REFERENCES `itempedido` (`PedidoID`, `ProdutoID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itemtroca`
--

LOCK TABLES `itemtroca` WRITE;
/*!40000 ALTER TABLE `itemtroca` DISABLE KEYS */;
INSERT INTO `itemtroca` VALUES (1,1,1);
/*!40000 ALTER TABLE `itemtroca` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Tabela para auditoria de todas as operações de escrita no banco de dados.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logtransacoes`
--

LOCK TABLES `logtransacoes` WRITE;
/*!40000 ALTER TABLE `logtransacoes` DISABLE KEYS */;
INSERT INTO `logtransacoes` VALUES (1,'2025-09-07 13:01:47',NULL,'INSERÇÃO','Pedido',1,NULL,'{\"ID\":1,\"DataPedido\":\"2025-09-07T13:01:46.6475784-03:00\",\"ValorTotal\":290.50,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null,\"EnderecoID\":2,\"Endereco\":{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":{\"ID\":1,\"Estado\":{\"ID\":25,\"Pais\":null,\"Nome\":\"S\\u00E3o Paulo\",\"UF\":\"SP\"},\"Nome\":\"Suzano\"},\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":280.00,\"PedidoID\":1,\"Pedido\":null,\"ProdutoID\":1,\"Produto\":null}],\"Trocas\":[]}',NULL),(2,'2025-09-07 13:02:17',NULL,'INSERÇÃO','Pedido',2,NULL,'{\"ID\":2,\"DataPedido\":\"2025-09-07T13:02:17.0592888-03:00\",\"ValorTotal\":290.50,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null,\"EnderecoID\":1,\"Endereco\":{\"ID\":1,\"Apelido\":\"Cobranca\",\"Logradouro\":\"X\",\"Numero\":\"100\",\"Bairro\":\"Bairro A\",\"CEP\":\"12345-678\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":{\"ID\":1,\"Estado\":{\"ID\":25,\"Pais\":null,\"Nome\":\"S\\u00E3o Paulo\",\"UF\":\"SP\"},\"Nome\":\"Suzano\"},\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":280.00,\"PedidoID\":2,\"Pedido\":null,\"ProdutoID\":1,\"Produto\":null}],\"Trocas\":[]}',NULL),(3,'2025-09-07 14:07:59',NULL,'INSERÇÃO','Pedido',3,NULL,'{\"ID\":3,\"DataPedido\":\"2025-09-07T14:07:59.2916508-03:00\",\"ValorTotal\":290.50,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null,\"EnderecoID\":2,\"Endereco\":{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":{\"ID\":1,\"Estado\":{\"ID\":25,\"Pais\":null,\"Nome\":\"S\\u00E3o Paulo\",\"UF\":\"SP\"},\"Nome\":\"Suzano\"},\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":280.00,\"PedidoID\":3,\"Pedido\":null,\"ProdutoID\":1,\"Produto\":null}],\"Trocas\":[]}',NULL),(4,'2025-09-07 14:18:29',NULL,'INSERÇÃO','Pedido',4,NULL,'{\"ID\":4,\"DataPedido\":\"2025-09-07T14:18:29.0854505-03:00\",\"ValorTotal\":275.50,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null,\"EnderecoID\":2,\"Endereco\":{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":{\"ID\":1,\"Estado\":{\"ID\":25,\"Pais\":null,\"Nome\":\"S\\u00E3o Paulo\",\"UF\":\"SP\"},\"Nome\":\"Suzano\"},\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":280.00,\"PedidoID\":4,\"Pedido\":null,\"ProdutoID\":1,\"Produto\":null}],\"Trocas\":[]}',NULL),(5,'2025-09-07 14:24:52',NULL,'INSERÇÃO','Pedido',5,NULL,'{\"ID\":5,\"DataPedido\":\"2025-09-07T14:24:52.3392691-03:00\",\"ValorTotal\":240.50,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null,\"EnderecoID\":2,\"Endereco\":{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":{\"ID\":1,\"Estado\":{\"ID\":25,\"Pais\":null,\"Nome\":\"S\\u00E3o Paulo\",\"UF\":\"SP\"},\"Nome\":\"Suzano\"},\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":280.00,\"PedidoID\":5,\"Pedido\":null,\"ProdutoID\":1,\"Produto\":null}],\"Trocas\":[]}',NULL),(6,'2025-09-07 14:34:36',1,'ALTERAÇÃO','Pedido',1,'{\"Status\":\"EM PROCESSAMENTO\"}','{\"Status\":\"EM TRANSITO\"}','Pedido despachado pelo administrador'),(7,'2025-09-07 14:34:39',1,'ALTERAÇÃO','Pedido',1,'{\"Status\":\"EM TRANSITO\"}','{\"Status\":\"ENTREGUE\"}','Entrega confirmada pelo administrador'),(8,'2025-09-07 14:34:59',NULL,'ALTERAÇÃO','Pedido',1,'{\"Status\":\"ENTREGUE\"}','{\"Status\":\"EM TROCA\"}','Solicitação de troca criada pelo cliente'),(9,'2025-09-07 14:35:15',1,'ALTERAÇÃO','Pedido',1,'{\"Status\":\"EM TROCA\"}','{\"Status\":\"TROCA AUTORIZADA\"}','Troca autorizada pelo administrador'),(10,'2025-09-07 14:35:21',1,'ALTERAÇÃO','Pedido',1,'{\"Status\":\"TROCA AUTORIZADA\"}','{\"Status\":\"TROCADO\"}','Recebimento de troca confirmado'),(11,'2025-09-07 14:35:21',1,'INSERÇÃO','Cupom',4,NULL,'{\"ID\":4,\"Codigo\":\"TROCA-1-638928525209082389\",\"Tipo\":\"TROCA\",\"Valor\":280.00,\"DataCriacao\":\"2025-09-07T14:35:20.9084647-03:00\",\"DataValidade\":null,\"Ativo\":true,\"ClienteID\":1,\"PedidoOrigemID\":1,\"PedidoUsoID\":null,\"Cliente\":{\"Id\":1,\"NomeCompleto\":\"Igor Fernandes de Matos\",\"CPF\":\"472.468.138-10\",\"Genero\":\"Masculino\",\"DataNascimento\":\"2000-09-06T00:00:00\",\"Email\":\"igor.teste@gmail.com\",\"SenhaHash\":\"$2a$11$myr3QVLMnQ1iAYJ5MNOzkOpwNwgUT37zM1yPjQy5udWJRfa/9qyYi\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[],\"Telefones\":[],\"Cartoes\":[],\"Pedidos\":[{\"ID\":1,\"DataPedido\":\"2025-09-07T13:01:47\",\"ValorTotal\":290.50,\"Status\":\"TROCADO\",\"ClienteID\":1,\"Cliente\":null,\"EnderecoID\":2,\"Endereco\":null,\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":280.00,\"PedidoID\":1,\"Pedido\":null,\"ProdutoID\":1,\"Produto\":null}],\"Trocas\":[{\"ID\":1,\"PedidoID\":1,\"ClienteID\":1,\"DataSolicitacao\":\"2025-09-07T14:34:59\",\"Motivo\":\"Teste cupom de troca\",\"StatusTroca\":\"FINALIZADA\",\"Pedido\":null,\"Cliente\":null,\"ItensTroca\":[{\"TrocaID\":1,\"ItemPedidoPedidoID\":1,\"ItemPedidoProdutoID\":1,\"Troca\":null,\"ItemPedido\":{\"Quantidade\":1,\"PrecoUnitario\":280.00,\"PedidoID\":1,\"Pedido\":null,\"ProdutoID\":1,\"Produto\":null}}]}]}]},\"PedidoOrigem\":{\"ID\":1,\"DataPedido\":\"2025-09-07T13:01:47\",\"ValorTotal\":290.50,\"Status\":\"TROCADO\",\"ClienteID\":1,\"Cliente\":{\"Id\":1,\"NomeCompleto\":\"Igor Fernandes de Matos\",\"CPF\":\"472.468.138-10\",\"Genero\":\"Masculino\",\"DataNascimento\":\"2000-09-06T00:00:00\",\"Email\":\"igor.teste@gmail.com\",\"SenhaHash\":\"$2a$11$myr3QVLMnQ1iAYJ5MNOzkOpwNwgUT37zM1yPjQy5udWJRfa/9qyYi\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[],\"Telefones\":[],\"Cartoes\":[],\"Pedidos\":[null]},\"EnderecoID\":2,\"Endereco\":null,\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":280.00,\"PedidoID\":1,\"Pedido\":null,\"ProdutoID\":1,\"Produto\":null}],\"Trocas\":[{\"ID\":1,\"PedidoID\":1,\"ClienteID\":1,\"DataSolicitacao\":\"2025-09-07T14:34:59\",\"Motivo\":\"Teste cupom de troca\",\"StatusTroca\":\"FINALIZADA\",\"Pedido\":null,\"Cliente\":{\"Id\":1,\"NomeCompleto\":\"Igor Fernandes de Matos\",\"CPF\":\"472.468.138-10\",\"Genero\":\"Masculino\",\"DataNascimento\":\"2000-09-06T00:00:00\",\"Email\":\"igor.teste@gmail.com\",\"SenhaHash\":\"$2a$11$myr3QVLMnQ1iAYJ5MNOzkOpwNwgUT37zM1yPjQy5udWJRfa/9qyYi\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[],\"Telefones\":[],\"Cartoes\":[],\"Pedidos\":[null]},\"ItensTroca\":[{\"TrocaID\":1,\"ItemPedidoPedidoID\":1,\"ItemPedidoProdutoID\":1,\"Troca\":null,\"ItemPedido\":{\"Quantidade\":1,\"PrecoUnitario\":280.00,\"PedidoID\":1,\"Pedido\":null,\"ProdutoID\":1,\"Produto\":null}}]}]},\"PedidoUso\":null}','Gerado a partir da troca do pedido #1'),(12,'2025-09-07 14:36:29',NULL,'INATIVAÇÃO','Cupom',4,'{\"Ativo\":true,\"PedidoUsoID\":null}','{\"Ativo\":false,\"PedidoUsoID\":6}','Cupom de troca utilizado no pedido #6'),(13,'2025-09-07 14:36:29',NULL,'INSERÇÃO','Pedido',6,NULL,'{\"ID\":6,\"DataPedido\":\"2025-09-07T14:36:28.5073158-03:00\",\"ValorTotal\":135.50,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null,\"EnderecoID\":2,\"Endereco\":{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":{\"ID\":1,\"Estado\":{\"ID\":25,\"Pais\":null,\"Nome\":\"S\\u00E3o Paulo\",\"UF\":\"SP\"},\"Nome\":\"Suzano\"},\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":420.00,\"PedidoID\":6,\"Pedido\":null,\"ProdutoID\":3,\"Produto\":null}],\"Trocas\":[]}',NULL),(14,'2025-09-07 14:39:48',1,'ALTERAÇÃO','Pedido',2,'{\"Status\":\"EM PROCESSAMENTO\"}','{\"Status\":\"EM TRANSITO\"}','Pedido despachado pelo administrador'),(15,'2025-09-09 15:42:11',1,'INSERÇÃO','Cliente',2,NULL,'{\"Cliente\":{\"Id\":2,\"NomeCompleto\":\"Cliente Para Ativar f6f4\",\"CPF\":\"661.548.802-77\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"a66715748802@teste.com\",\"SenhaHash\":\"$2a$11$VqZNVVOJUXOIgMu4U5ZQ0eadk3E0BfVWo4LU5b77pIUacpj4tiz0G\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":3,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":2,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":4,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":2,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":2,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":2,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":3,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":2,\"Cliente\":null}],\"Pedidos\":[]},\"Telefones\":[{\"ID\":2,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":2,\"Cliente\":{\"Id\":2,\"NomeCompleto\":\"Cliente Para Ativar f6f4\",\"CPF\":\"661.548.802-77\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"a66715748802@teste.com\",\"SenhaHash\":\"$2a$11$VqZNVVOJUXOIgMu4U5ZQ0eadk3E0BfVWo4LU5b77pIUacpj4tiz0G\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":3,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":2,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":4,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":2,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[null],\"Cartoes\":[{\"ID\":3,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":2,\"Cliente\":null}],\"Pedidos\":[]},\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Enderecos\":[{\"ID\":3,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":2,\"Cliente\":{\"Id\":2,\"NomeCompleto\":\"Cliente Para Ativar f6f4\",\"CPF\":\"661.548.802-77\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"a66715748802@teste.com\",\"SenhaHash\":\"$2a$11$VqZNVVOJUXOIgMu4U5ZQ0eadk3E0BfVWo4LU5b77pIUacpj4tiz0G\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[null,{\"ID\":4,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":2,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":2,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":2,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":3,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":2,\"Cliente\":null}],\"Pedidos\":[]},\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":4,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":2,\"Cliente\":{\"Id\":2,\"NomeCompleto\":\"Cliente Para Ativar f6f4\",\"CPF\":\"661.548.802-77\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"a66715748802@teste.com\",\"SenhaHash\":\"$2a$11$VqZNVVOJUXOIgMu4U5ZQ0eadk3E0BfVWo4LU5b77pIUacpj4tiz0G\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":3,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":2,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},null],\"Telefones\":[{\"ID\":2,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":2,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":3,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":2,\"Cliente\":null}],\"Pedidos\":[]},\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Cartoes\":[{\"ID\":3,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":2,\"Cliente\":{\"Id\":2,\"NomeCompleto\":\"Cliente Para Ativar f6f4\",\"CPF\":\"661.548.802-77\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"a66715748802@teste.com\",\"SenhaHash\":\"$2a$11$VqZNVVOJUXOIgMu4U5ZQ0eadk3E0BfVWo4LU5b77pIUacpj4tiz0G\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":3,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":2,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":4,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":2,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":2,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":2,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[null],\"Pedidos\":[]}}]}',NULL),(16,'2025-09-09 15:42:55',1,'INSERÇÃO','Cliente',3,NULL,'{\"Cliente\":{\"Id\":3,\"NomeCompleto\":\"Cliente Cadastro 5fe3\",\"CPF\":\"835.002.374-57\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"c83750502374@teste.com\",\"SenhaHash\":\"$2a$11$2Wwt9h9Hyxt3zy1a4ATDBuGKxNIIAs.58YK9xcAKX.0A/gTOEJzX2\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":5,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":3,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":6,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":3,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":3,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":3,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":4,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":3,\"Cliente\":null}],\"Pedidos\":[]},\"Telefones\":[{\"ID\":3,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":3,\"Cliente\":{\"Id\":3,\"NomeCompleto\":\"Cliente Cadastro 5fe3\",\"CPF\":\"835.002.374-57\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"c83750502374@teste.com\",\"SenhaHash\":\"$2a$11$2Wwt9h9Hyxt3zy1a4ATDBuGKxNIIAs.58YK9xcAKX.0A/gTOEJzX2\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":5,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":3,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":6,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":3,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[null],\"Cartoes\":[{\"ID\":4,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":3,\"Cliente\":null}],\"Pedidos\":[]},\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Enderecos\":[{\"ID\":5,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":3,\"Cliente\":{\"Id\":3,\"NomeCompleto\":\"Cliente Cadastro 5fe3\",\"CPF\":\"835.002.374-57\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"c83750502374@teste.com\",\"SenhaHash\":\"$2a$11$2Wwt9h9Hyxt3zy1a4ATDBuGKxNIIAs.58YK9xcAKX.0A/gTOEJzX2\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[null,{\"ID\":6,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":3,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":3,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":3,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":4,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":3,\"Cliente\":null}],\"Pedidos\":[]},\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":6,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":3,\"Cliente\":{\"Id\":3,\"NomeCompleto\":\"Cliente Cadastro 5fe3\",\"CPF\":\"835.002.374-57\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"c83750502374@teste.com\",\"SenhaHash\":\"$2a$11$2Wwt9h9Hyxt3zy1a4ATDBuGKxNIIAs.58YK9xcAKX.0A/gTOEJzX2\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":5,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":3,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},null],\"Telefones\":[{\"ID\":3,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":3,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":4,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":3,\"Cliente\":null}],\"Pedidos\":[]},\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Cartoes\":[{\"ID\":4,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":3,\"Cliente\":{\"Id\":3,\"NomeCompleto\":\"Cliente Cadastro 5fe3\",\"CPF\":\"835.002.374-57\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"c83750502374@teste.com\",\"SenhaHash\":\"$2a$11$2Wwt9h9Hyxt3zy1a4ATDBuGKxNIIAs.58YK9xcAKX.0A/gTOEJzX2\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":5,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":3,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":6,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":3,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":3,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":3,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[null],\"Pedidos\":[]}}]}',NULL),(17,'2025-09-09 15:43:05',1,'INSERÇÃO','Cliente',4,NULL,'{\"Cliente\":{\"Id\":4,\"NomeCompleto\":\"Cliente Para Editar 1e9b\",\"CPF\":\"710.727.016-85\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"e71507827016@teste.com\",\"SenhaHash\":\"$2a$11$fq3vYOD9DhHj/bAYcxjBoeaRGnHdJBcj4Spzkn1XLWpdUoGACXG7K\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":7,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":4,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":8,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":4,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":4,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":4,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":5,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":4,\"Cliente\":null}],\"Pedidos\":[]},\"Telefones\":[{\"ID\":4,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":4,\"Cliente\":{\"Id\":4,\"NomeCompleto\":\"Cliente Para Editar 1e9b\",\"CPF\":\"710.727.016-85\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"e71507827016@teste.com\",\"SenhaHash\":\"$2a$11$fq3vYOD9DhHj/bAYcxjBoeaRGnHdJBcj4Spzkn1XLWpdUoGACXG7K\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":7,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":4,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":8,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":4,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[null],\"Cartoes\":[{\"ID\":5,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":4,\"Cliente\":null}],\"Pedidos\":[]},\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Enderecos\":[{\"ID\":7,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":4,\"Cliente\":{\"Id\":4,\"NomeCompleto\":\"Cliente Para Editar 1e9b\",\"CPF\":\"710.727.016-85\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"e71507827016@teste.com\",\"SenhaHash\":\"$2a$11$fq3vYOD9DhHj/bAYcxjBoeaRGnHdJBcj4Spzkn1XLWpdUoGACXG7K\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[null,{\"ID\":8,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":4,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":4,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":4,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":5,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":4,\"Cliente\":null}],\"Pedidos\":[]},\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":8,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":4,\"Cliente\":{\"Id\":4,\"NomeCompleto\":\"Cliente Para Editar 1e9b\",\"CPF\":\"710.727.016-85\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"e71507827016@teste.com\",\"SenhaHash\":\"$2a$11$fq3vYOD9DhHj/bAYcxjBoeaRGnHdJBcj4Spzkn1XLWpdUoGACXG7K\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":7,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":4,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},null],\"Telefones\":[{\"ID\":4,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":4,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":5,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":4,\"Cliente\":null}],\"Pedidos\":[]},\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Cartoes\":[{\"ID\":5,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":4,\"Cliente\":{\"Id\":4,\"NomeCompleto\":\"Cliente Para Editar 1e9b\",\"CPF\":\"710.727.016-85\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"e71507827016@teste.com\",\"SenhaHash\":\"$2a$11$fq3vYOD9DhHj/bAYcxjBoeaRGnHdJBcj4Spzkn1XLWpdUoGACXG7K\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":7,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":4,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":8,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":4,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":4,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":4,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[null],\"Pedidos\":[]}}]}',NULL),(18,'2025-09-09 15:43:30',1,'INSERÇÃO','Cliente',5,NULL,'{\"Cliente\":{\"Id\":5,\"NomeCompleto\":\"Cliente Cartoes 0d47\",\"CPF\":\"741.284.458-10\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"car74012184458@teste.com\",\"SenhaHash\":\"$2a$11$TtYst0ZgreCc25pK.NsQseEJZly6OALeIHlz/J4a2P6Dk1SfxRnq.\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":9,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":5,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":10,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":5,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":5,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":5,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":6,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":5,\"Cliente\":null}],\"Pedidos\":[]},\"Telefones\":[{\"ID\":5,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":5,\"Cliente\":{\"Id\":5,\"NomeCompleto\":\"Cliente Cartoes 0d47\",\"CPF\":\"741.284.458-10\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"car74012184458@teste.com\",\"SenhaHash\":\"$2a$11$TtYst0ZgreCc25pK.NsQseEJZly6OALeIHlz/J4a2P6Dk1SfxRnq.\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":9,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":5,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":10,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":5,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[null],\"Cartoes\":[{\"ID\":6,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":5,\"Cliente\":null}],\"Pedidos\":[]},\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Enderecos\":[{\"ID\":9,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":5,\"Cliente\":{\"Id\":5,\"NomeCompleto\":\"Cliente Cartoes 0d47\",\"CPF\":\"741.284.458-10\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"car74012184458@teste.com\",\"SenhaHash\":\"$2a$11$TtYst0ZgreCc25pK.NsQseEJZly6OALeIHlz/J4a2P6Dk1SfxRnq.\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[null,{\"ID\":10,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":5,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":5,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":5,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":6,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":5,\"Cliente\":null}],\"Pedidos\":[]},\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":10,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":5,\"Cliente\":{\"Id\":5,\"NomeCompleto\":\"Cliente Cartoes 0d47\",\"CPF\":\"741.284.458-10\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"car74012184458@teste.com\",\"SenhaHash\":\"$2a$11$TtYst0ZgreCc25pK.NsQseEJZly6OALeIHlz/J4a2P6Dk1SfxRnq.\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":9,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":5,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},null],\"Telefones\":[{\"ID\":5,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":5,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":6,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":5,\"Cliente\":null}],\"Pedidos\":[]},\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Cartoes\":[{\"ID\":6,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":5,\"Cliente\":{\"Id\":5,\"NomeCompleto\":\"Cliente Cartoes 0d47\",\"CPF\":\"741.284.458-10\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"car74012184458@teste.com\",\"SenhaHash\":\"$2a$11$TtYst0ZgreCc25pK.NsQseEJZly6OALeIHlz/J4a2P6Dk1SfxRnq.\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":9,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":5,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":10,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":5,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":5,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":5,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[null],\"Pedidos\":[]}}]}',NULL),(19,'2025-09-09 15:43:45',1,'INSERÇÃO','Cliente',6,NULL,'{\"Cliente\":{\"Id\":6,\"NomeCompleto\":\"Cliente Enderecos 509c\",\"CPF\":\"253.123.007-54\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"end25431523007@teste.com\",\"SenhaHash\":\"$2a$11$Kcto6sWBjwxKwllBI9Tmw.Slm6oVwL7ouMbyl9jXwarXQbZhfebuu\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":11,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":6,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":12,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":6,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":6,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":6,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":7,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":6,\"Cliente\":null}],\"Pedidos\":[]},\"Telefones\":[{\"ID\":6,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":6,\"Cliente\":{\"Id\":6,\"NomeCompleto\":\"Cliente Enderecos 509c\",\"CPF\":\"253.123.007-54\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"end25431523007@teste.com\",\"SenhaHash\":\"$2a$11$Kcto6sWBjwxKwllBI9Tmw.Slm6oVwL7ouMbyl9jXwarXQbZhfebuu\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":11,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":6,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":12,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":6,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[null],\"Cartoes\":[{\"ID\":7,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":6,\"Cliente\":null}],\"Pedidos\":[]},\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Enderecos\":[{\"ID\":11,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":6,\"Cliente\":{\"Id\":6,\"NomeCompleto\":\"Cliente Enderecos 509c\",\"CPF\":\"253.123.007-54\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"end25431523007@teste.com\",\"SenhaHash\":\"$2a$11$Kcto6sWBjwxKwllBI9Tmw.Slm6oVwL7ouMbyl9jXwarXQbZhfebuu\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[null,{\"ID\":12,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":6,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":6,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":6,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":7,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":6,\"Cliente\":null}],\"Pedidos\":[]},\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":12,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":6,\"Cliente\":{\"Id\":6,\"NomeCompleto\":\"Cliente Enderecos 509c\",\"CPF\":\"253.123.007-54\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"end25431523007@teste.com\",\"SenhaHash\":\"$2a$11$Kcto6sWBjwxKwllBI9Tmw.Slm6oVwL7ouMbyl9jXwarXQbZhfebuu\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":11,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":6,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},null],\"Telefones\":[{\"ID\":6,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":6,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":7,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":6,\"Cliente\":null}],\"Pedidos\":[]},\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Cartoes\":[{\"ID\":7,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":6,\"Cliente\":{\"Id\":6,\"NomeCompleto\":\"Cliente Enderecos 509c\",\"CPF\":\"253.123.007-54\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"end25431523007@teste.com\",\"SenhaHash\":\"$2a$11$Kcto6sWBjwxKwllBI9Tmw.Slm6oVwL7ouMbyl9jXwarXQbZhfebuu\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":11,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":6,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":12,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":6,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":6,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":6,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[null],\"Pedidos\":[]}}]}',NULL),(20,'2025-09-09 15:43:47',1,'ALTERAÇÃO','Endereco',11,'{\"ID\":11,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":6,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}','{\"ID\":11,\"Apelido\":\"Apelido Editado Pelo Teste\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":null,\"ClienteID\":6,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}',NULL),(21,'2025-09-09 15:44:01',1,'INSERÇÃO','Cliente',7,NULL,'{\"Cliente\":{\"Id\":7,\"NomeCompleto\":\"Cliente Para Inativar 37aa\",\"CPF\":\"403.725.428-72\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"i40237725428@teste.com\",\"SenhaHash\":\"$2a$11$iZmUwORx20vN4ndJEWInZulVbqJZjigGaQfc6SROFJYGA0D3i7cBe\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":13,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":7,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":14,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":7,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":7,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":7,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":8,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":7,\"Cliente\":null}],\"Pedidos\":[]},\"Telefones\":[{\"ID\":7,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":7,\"Cliente\":{\"Id\":7,\"NomeCompleto\":\"Cliente Para Inativar 37aa\",\"CPF\":\"403.725.428-72\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"i40237725428@teste.com\",\"SenhaHash\":\"$2a$11$iZmUwORx20vN4ndJEWInZulVbqJZjigGaQfc6SROFJYGA0D3i7cBe\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":13,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":7,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":14,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":7,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[null],\"Cartoes\":[{\"ID\":8,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":7,\"Cliente\":null}],\"Pedidos\":[]},\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Enderecos\":[{\"ID\":13,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":7,\"Cliente\":{\"Id\":7,\"NomeCompleto\":\"Cliente Para Inativar 37aa\",\"CPF\":\"403.725.428-72\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"i40237725428@teste.com\",\"SenhaHash\":\"$2a$11$iZmUwORx20vN4ndJEWInZulVbqJZjigGaQfc6SROFJYGA0D3i7cBe\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[null,{\"ID\":14,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":7,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":7,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":7,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":8,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":7,\"Cliente\":null}],\"Pedidos\":[]},\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":14,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":7,\"Cliente\":{\"Id\":7,\"NomeCompleto\":\"Cliente Para Inativar 37aa\",\"CPF\":\"403.725.428-72\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"i40237725428@teste.com\",\"SenhaHash\":\"$2a$11$iZmUwORx20vN4ndJEWInZulVbqJZjigGaQfc6SROFJYGA0D3i7cBe\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":13,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":7,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},null],\"Telefones\":[{\"ID\":7,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":7,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[{\"ID\":8,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":7,\"Cliente\":null}],\"Pedidos\":[]},\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Cartoes\":[{\"ID\":8,\"NomeImpresso\":\"Teste Cartao\",\"UltimosQuatroDigitos\":\"4432\",\"DataValidade\":\"12/2026\",\"Bandeira\":\"Visa\",\"Preferencial\":true,\"ClienteID\":7,\"Cliente\":{\"Id\":7,\"NomeCompleto\":\"Cliente Para Inativar 37aa\",\"CPF\":\"403.725.428-72\",\"Genero\":\"Outro\",\"DataNascimento\":\"1990-01-01T00:00:00\",\"Email\":\"i40237725428@teste.com\",\"SenhaHash\":\"$2a$11$iZmUwORx20vN4ndJEWInZulVbqJZjigGaQfc6SROFJYGA0D3i7cBe\",\"Ativo\":true,\"Ranking\":null,\"Enderecos\":[{\"ID\":13,\"Apelido\":\"Endere\\u00E7o Para Editar\",\"Logradouro\":\"Cobran\\u00E7a\",\"Numero\":\"123\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-123\",\"Observacao\":\"\",\"ClienteID\":7,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":null,\"Tipo_EnderecoID\":2,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},{\"ID\":14,\"Apelido\":\"Endere\\u00E7o Para Excluir\",\"Logradouro\":\"Entrega\",\"Numero\":\"456\",\"Bairro\":\"Bairro\",\"CEP\":\"08777-124\",\"Observacao\":\"\",\"ClienteID\":7,\"Cliente\":null,\"CidadeID\":2,\"Cidade\":null,\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":1,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null}],\"Telefones\":[{\"ID\":7,\"DDD\":\"11\",\"Numero\":\"98764-3215\",\"ClienteID\":7,\"Cliente\":null,\"Tipo_TelefoneID\":1,\"Tipo_Telefone\":null}],\"Cartoes\":[null],\"Pedidos\":[]}}]}',NULL),(22,'2025-09-10 14:15:51',NULL,'INSERÇÃO','Pedido',7,NULL,'{\"ID\":7,\"DataPedido\":\"2025-09-10T14:15:50.8479589-03:00\",\"ValorTotal\":220.50,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null,\"EnderecoID\":2,\"Endereco\":{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":{\"ID\":1,\"Estado\":{\"ID\":25,\"Pais\":null,\"Nome\":\"S\\u00E3o Paulo\",\"UF\":\"SP\"},\"Nome\":\"Suzano\"},\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":210.00,\"PedidoID\":7,\"Pedido\":null,\"ProdutoID\":5,\"Produto\":null}],\"Trocas\":[]}',NULL),(23,'2025-09-10 14:18:55',NULL,'INSERÇÃO','Pedido',8,NULL,'{\"ID\":8,\"DataPedido\":\"2025-09-10T14:18:55.1451959-03:00\",\"ValorTotal\":150.50,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null,\"EnderecoID\":2,\"Endereco\":{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":{\"ID\":1,\"Estado\":{\"ID\":25,\"Pais\":null,\"Nome\":\"S\\u00E3o Paulo\",\"UF\":\"SP\"},\"Nome\":\"Suzano\"},\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":140.00,\"PedidoID\":8,\"Pedido\":null,\"ProdutoID\":9,\"Produto\":null}],\"Trocas\":[]}',NULL),(24,'2025-09-10 14:33:56',NULL,'INSERÇÃO','Pedido',9,NULL,'{\"ID\":9,\"DataPedido\":\"2025-09-10T14:33:56.1576851-03:00\",\"ValorTotal\":220.50,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null,\"EnderecoID\":2,\"Endereco\":{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":{\"ID\":1,\"Estado\":{\"ID\":25,\"Pais\":null,\"Nome\":\"S\\u00E3o Paulo\",\"UF\":\"SP\"},\"Nome\":\"Suzano\"},\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":210.00,\"PedidoID\":9,\"Pedido\":null,\"ProdutoID\":4,\"Produto\":null}],\"Trocas\":[]}',NULL),(25,'2025-09-10 14:33:58',NULL,'ALTERAÇÃO','Pedido',9,'{\"Status\":\"EM PROCESSAMENTO\"}','{\"Status\":\"APROVADA\"}','Simulação de resposta da operadora de cartão. Resultado: APROVADA'),(26,'2025-09-10 14:34:54',NULL,'INSERÇÃO','Pedido',10,NULL,'{\"ID\":10,\"DataPedido\":\"2025-09-10T14:34:54.3980511-03:00\",\"ValorTotal\":430.50,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null,\"EnderecoID\":2,\"Endereco\":{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":{\"ID\":1,\"Estado\":{\"ID\":25,\"Pais\":null,\"Nome\":\"S\\u00E3o Paulo\",\"UF\":\"SP\"},\"Nome\":\"Suzano\"},\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":420.00,\"PedidoID\":10,\"Pedido\":null,\"ProdutoID\":8,\"Produto\":null}],\"Trocas\":[]}',NULL),(27,'2025-09-10 14:34:56',NULL,'ALTERAÇÃO','Pedido',10,'{\"Status\":\"EM PROCESSAMENTO\"}','{\"Status\":\"REPROVADA\"}','Simulação de resposta da operadora de cartão. Resultado: REPROVADA'),(28,'2025-09-10 14:48:48',NULL,'INSERÇÃO','Pedido',11,NULL,'{\"ID\":11,\"DataPedido\":\"2025-09-10T14:48:48.2168839-03:00\",\"ValorTotal\":150.50,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null,\"EnderecoID\":2,\"Endereco\":{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":{\"ID\":1,\"Estado\":{\"ID\":25,\"Pais\":null,\"Nome\":\"S\\u00E3o Paulo\",\"UF\":\"SP\"},\"Nome\":\"Suzano\"},\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":140.00,\"PedidoID\":11,\"Pedido\":null,\"ProdutoID\":9,\"Produto\":null}],\"Trocas\":[]}',NULL),(29,'2025-09-10 14:48:50',NULL,'ALTERAÇÃO','Pedido',11,'{\"Status\":\"EM PROCESSAMENTO\"}','{\"Status\":\"REPROVADA\"}','Resposta do operadora do cartão'),(30,'2025-09-10 14:51:52',NULL,'INSERÇÃO','Pedido',12,NULL,'{\"ID\":12,\"DataPedido\":\"2025-09-10T14:51:51.8207821-03:00\",\"ValorTotal\":290.50,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null,\"EnderecoID\":2,\"Endereco\":{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":{\"ID\":1,\"Estado\":{\"ID\":25,\"Pais\":null,\"Nome\":\"S\\u00E3o Paulo\",\"UF\":\"SP\"},\"Nome\":\"Suzano\"},\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":280.00,\"PedidoID\":12,\"Pedido\":null,\"ProdutoID\":7,\"Produto\":null}],\"Trocas\":[]}',NULL),(31,'2025-09-10 14:51:54',NULL,'ALTERAÇÃO','Pedido',12,'{\"Status\":\"EM PROCESSAMENTO\"}','{\"Status\":\"REPROVADA\"}','Resposta do operadora do cartão'),(32,'2025-09-10 14:56:07',NULL,'INSERÇÃO','Pedido',13,NULL,'{\"ID\":13,\"DataPedido\":\"2025-09-10T14:56:07.3974716-03:00\",\"ValorTotal\":290.50,\"Status\":\"EM PROCESSAMENTO\",\"ClienteID\":1,\"Cliente\":null,\"EnderecoID\":2,\"Endereco\":{\"ID\":2,\"Apelido\":\"Casa\",\"Logradouro\":\"Celestino Rodrigues\",\"Numero\":\"321\",\"Bairro\":\"Jardim Imperador\",\"CEP\":\"08673-230\",\"Observacao\":\"\",\"ClienteID\":1,\"Cliente\":null,\"CidadeID\":1,\"Cidade\":{\"ID\":1,\"Estado\":{\"ID\":25,\"Pais\":null,\"Nome\":\"S\\u00E3o Paulo\",\"UF\":\"SP\"},\"Nome\":\"Suzano\"},\"Tipo_EnderecoID\":1,\"Tipo_Endereco\":null,\"Tipo_LogradouroID\":4,\"Tipo_Logradouro\":null,\"Tipo_ResidenciaID\":1,\"Tipo_Residencia\":null},\"ItensPedido\":[{\"Quantidade\":1,\"PrecoUnitario\":280.00,\"PedidoID\":13,\"Pedido\":null,\"ProdutoID\":2,\"Produto\":null}],\"Trocas\":[]}',NULL),(33,'2025-09-10 14:56:10',NULL,'ALTERAÇÃO','Pedido',13,'{\"Status\":\"EM PROCESSAMENTO\"}','{\"Status\":\"REPROVADA\"}','Resposta do operadora do cartão');
/*!40000 ALTER TABLE `logtransacoes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificacao`
--

DROP TABLE IF EXISTS `notificacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificacao` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ClienteID` int NOT NULL,
  `Mensagem` varchar(500) NOT NULL,
  `Url` varchar(255) DEFAULT NULL,
  `DataCriacao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Lida` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`Id`),
  KEY `FK_Notificacao_Cliente` (`ClienteID`),
  CONSTRAINT `FK_Notificacao_Cliente` FOREIGN KEY (`ClienteID`) REFERENCES `cliente` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificacao`
--

LOCK TABLES `notificacao` WRITE;
/*!40000 ALTER TABLE `notificacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagamentopedido`
--

DROP TABLE IF EXISTS `pagamentopedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagamentopedido` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PedidoID` int NOT NULL,
  `CartaoID` int NOT NULL,
  `ValorPago` decimal(10,2) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `PedidoID` (`PedidoID`),
  KEY `CartaoID` (`CartaoID`),
  CONSTRAINT `pagamentopedido_ibfk_1` FOREIGN KEY (`PedidoID`) REFERENCES `pedido` (`ID`),
  CONSTRAINT `pagamentopedido_ibfk_2` FOREIGN KEY (`CartaoID`) REFERENCES `cartao` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagamentopedido`
--

LOCK TABLES `pagamentopedido` WRITE;
/*!40000 ALTER TABLE `pagamentopedido` DISABLE KEYS */;
INSERT INTO `pagamentopedido` VALUES (2,1,1,290.50),(3,2,1,200.00),(4,2,2,90.50),(5,3,1,290.50),(6,4,1,200.00),(7,4,2,75.50),(8,5,1,200.00),(9,5,2,40.50),(10,6,1,135.50),(11,7,1,220.50),(12,8,2,150.50),(13,9,1,220.50),(14,10,2,430.50),(15,11,2,150.50),(16,12,2,290.50),(17,13,2,290.50);
/*!40000 ALTER TABLE `pagamentopedido` ENABLE KEYS */;
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
  `EnderecoID` int NOT NULL,
  `DataPedido` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ValorTotal` decimal(10,2) NOT NULL,
  `Status` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_Pedido_Cliente_idx` (`ClienteID`),
  KEY `FK_Pedido_Endereco` (`EnderecoID`),
  CONSTRAINT `fk_Pedido_Cliente` FOREIGN KEY (`ClienteID`) REFERENCES `cliente` (`ID`),
  CONSTRAINT `FK_Pedido_Endereco` FOREIGN KEY (`EnderecoID`) REFERENCES `endereco` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido`
--

LOCK TABLES `pedido` WRITE;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
INSERT INTO `pedido` VALUES (1,1,2,'2025-09-07 13:01:47',290.50,'TROCADO'),(2,1,1,'2025-09-07 13:02:17',290.50,'EM TRÂNSITO'),(3,1,2,'2025-09-07 14:07:59',290.50,'EM PROCESSAMENTO'),(4,1,2,'2025-09-07 14:18:29',275.50,'EM PROCESSAMENTO'),(5,1,2,'2025-09-07 14:24:52',240.50,'EM PROCESSAMENTO'),(6,1,2,'2025-09-07 14:36:29',135.50,'EM PROCESSAMENTO'),(7,1,2,'2025-09-10 14:15:51',220.50,'EM PROCESSAMENTO'),(8,1,2,'2025-09-10 14:18:55',150.50,'EM PROCESSAMENTO'),(9,1,2,'2025-09-10 14:33:56',220.50,'APROVADA'),(10,1,2,'2025-09-10 14:34:54',430.50,'REPROVADA'),(11,1,2,'2025-09-10 14:48:48',150.50,'REPROVADA'),(12,1,2,'2025-09-10 14:51:52',290.50,'REPROVADA'),(13,1,2,'2025-09-10 14:56:07',290.50,'REPROVADA');
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
INSERT INTO `produto` VALUES (1,1,'God of War Ragnarök','https://m.media-amazon.com/images/I/819bwWHNMJL.jpg',2022,'Edição Padrão','UM FUTURO NÃO ESCRITO\r\nAtreus busca conhecimento para entender a profecia de \"\"Loki\"\" e definir o papel dele no Ragnarök. Kratos deve se desacorrentar do medo de repetir erros do passado para ser o pai que Atreus precisa.','SKU1',1.00,1.00,1.00,1.00,200.00,280.00,1,2,1,1),(2,3,'Starfield','https://http2.mlstatic.com/D_NQ_NP_776642-MLU73417729993_122023-O.webp',2023,'Edição Padrão','Em Starfield, a história mais importante é a que você conta com seu personagem. Comece a jornada personalizando sua aparência e decidindo seu histórico e atributos. Você será um explorador experiente, um diplomata charmoso, um ciberita furtivo ou algo completamente diferente? A escolha é sua. Decida quem você será e o que se tornará.','SKU2',1.00,1.00,1.00,1.00,200.00,280.00,1,12,11,1),(3,5,'Pokemon Legends Arceus','https://m.media-amazon.com/images/I/71bhNf8QiOS.jpg',2022,'Edição Padrão','Prepare-se para um novo tipo de grande aventura Pokémon em Pokémon Legends: Arceus, um jogo totalmente novo da Game Freak que combina ação e exploração com as raízes de RPG da série Pokémon. Embarque em missões de pesquisa na antiga região de Hisui. Explore extensões naturais para capturar Pokémon selvagens, aprendendo seu comportamento, aproximando-se sorrateiramente e jogando uma Poké Ball bem direcionada. Você também pode jogar a Poké Ball contendo seu Pokémon aliado perto de um Pokémon selvagem para entrar na batalha sem problemas.','SKU3',1.00,1.00,1.00,1.00,300.00,420.00,1,14,2,1),(4,4,'Call of Duty: Black Ops 3','https://m.media-amazon.com/images/I/81bwynfO98L.jpg',2015,'Edição Padrão','Call of Duty: Black Ops III é o jogo mais profundo e ambicioso da série ao combinar três modos de jogo únicos: campanha, multijogador e Zombies. A campanha foi criada para ser partilhada por 4 jogadores online ou desfrutada a solo numa emocionante experiência cinemática. O multijogador será o mais profundo e gratificante da série, com novas formas para subir de nível, modificar a personagem e prepará-la para a batalha. Já o modo Zombies proporciona uma nova experiência com uma narrativa dedicada. Este título introduz um nível de inovação sem precedentes incluindo cenários arrasadores, armamento e habilidades inéditos e a introdução de um novo sistema de movimento fluido e melhorado.','SKU4',1.00,1.00,1.00,1.00,150.00,210.00,1,15,13,1),(5,2,'Resident Evil 2','https://m.media-amazon.com/images/I/71qWdMRpNGL.jpg',2019,'Edição Padrão','Em Resident Evil 2, a ação clássica, exploração tensa e a jogabilidade de resolver quebra-cabeças que definiu a série Resident Evil retorna. Os jogadores se juntam ao policial novato, Leon S. Kennedy, e à estudante universitária, Claire Redfield, que acabam juntos por uma epidemia desastrosa em Raccoon City que transformou sua população em zumbis mortais. Leon e Claire possuem suas próprias campanhas separadas, permitindo que os jogadores vejam a história da perspectiva de ambos os personagens. O destino desses dois personagens favoritos dos fãs está nas mãos dos jogadores conforme eles trabalham juntos para sobreviver e descobrir o que está por trás do terrível ataque à cidade. Será que eles sairão com vida?','SKU5',1.00,1.00,1.00,1.00,150.00,210.00,1,9,15,1),(6,1,'Marvel\'s Spider-Man 2','https://m.media-amazon.com/images/I/81Zh-3T1enL.jpg',2023,'Edição Padrão','Uma cidade sitiada!\r\nOs Spiders Peter Parker e Miles Morales encaram a maior prova de força com e sem suas máscaras enquanto lutam para salvar a cidade, um ao outro e as pessoas que amam do monstruoso Venom e da nova e perigosa ameaça: os simbiontes.','SKU6',1.00,1.00,1.00,1.00,200.00,280.00,1,7,1,1),(7,3,'Forza Horizon 5','https://media.gamestop.com/i/gamestop/11148773.jpg',2021,'Edição Padrão','Sua Maior Aventura Horizon espera por você! Explore as paisagens vibrantes de mundo aberto do México, com diversão e velocidade sem limites em um mundo em constante evolução, incluindo centenas dos melhores carros do mundo.','SKU7',1.00,1.00,1.00,1.00,200.00,280.00,1,13,3,1),(8,5,'The Legend of Zelda: Tears of Kingdom','https://images.kabum.com.br/produtos/fotos/sync_mirakl/464339/xlarge/Jogo-The-Legend-Of-Zelda-Tears-Of-The-Kingdom-Nintendo-Switch-Midia-F-sica_1751918394.jpg',2023,'Edição Padrão','VIVA ESTA AVENTURA INCOMPARÁVEL. Uma aventura épica pela terra e pelos céus de Hyrule aguarda em The Legend of Zelda: Tears of the Kingdom, para o console Nintendo Switch. A aventura será criada por você, em um mundo alimentado pela sua imaginação.','SKU8',1.00,1.00,1.00,1.00,300.00,420.00,1,6,2,1),(9,4,'Assassin\'s Creed Unity','https://cdn.awsli.com.br/600x450/138/138431/produto/7988193/df7d2c8e0b.jpg',2014,'Edição Padrão','UM NOVO HERÓI IMPLACÁVEL PARA UM NOVO MUNDO BRUTAL\r\nJogue como Arno, um tipo de assassino totalmente novo, mais letal que seus antecessores. Cace suas presas com uma gama de novas armas, tais como a Lâmina Fantasma, uma Lâmina Oculta com a capacidade de disparar como uma besta.','SKU9',1.00,1.00,1.00,1.00,100.00,140.00,1,16,7,1),(10,2,'Digimon Story: Cyber Sleuth','https://m.media-amazon.com/images/I/81ws0fAQ2NL.jpg',2017,'Edição Padrão','MUNDOS VÍVIDOS E IMERSIVOS\r\nEmbarque em uma aventura emocionante onde a linha entre o mundo real e o mundo digital é turva.','SKU10',1.00,1.00,1.00,1.00,100.00,125.50,1,17,4,3);
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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

--
-- Table structure for table `troca`
--

DROP TABLE IF EXISTS `troca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `troca` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `PedidoID` int NOT NULL,
  `ClienteID` int NOT NULL,
  `DataSolicitacao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Motivo` text NOT NULL COMMENT 'Motivo da troca informado pelo cliente.',
  `StatusTroca` varchar(50) NOT NULL COMMENT 'Status específico da troca (ex: SOLICITADA, AUTORIZADA, RECEBIDA)',
  PRIMARY KEY (`ID`),
  KEY `PedidoID` (`PedidoID`),
  KEY `ClienteID` (`ClienteID`),
  CONSTRAINT `troca_ibfk_1` FOREIGN KEY (`PedidoID`) REFERENCES `pedido` (`ID`),
  CONSTRAINT `troca_ibfk_2` FOREIGN KEY (`ClienteID`) REFERENCES `cliente` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `troca`
--

LOCK TABLES `troca` WRITE;
/*!40000 ALTER TABLE `troca` DISABLE KEYS */;
INSERT INTO `troca` VALUES (1,1,1,'2025-09-07 14:34:59','Teste cupom de troca','FINALIZADA');
/*!40000 ALTER TABLE `troca` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-11 20:44:18
