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
-- Dumping data for table `categoria`
--

LOCK TABLES `categoria` WRITE;
/*!40000 ALTER TABLE `categoria` DISABLE KEYS */;
INSERT INTO `categoria` VALUES (1,'Ação','Jogos focados em desafios físicos, incluindo combate, plataforma e exploração.'),(2,'Aventura','Jogos que enfatizam a exploração e a resolução de quebra-cabeças em uma narrativa.'),(3,'RPG','Jogos de interpretação de papéis com foco no desenvolvimento de personagens e histórias complexas.'),(4,'Esportes','Simulações de esportes do mundo real, como futebol, basquete e automobilismo.'),(5,'Corrida','Jogos centrados em competições de velocidade com veículos.'),(6,'Estratégia','Jogos que exigem planejamento e tomada de decisões táticas para alcançar a vitória.'),(7,'Luta','Jogos de combate um contra um entre um número limitado de personagens.'),(8,'Tiro','Jogos com combate baseado em armas de fogo, em primeira ou terceira pessoa (FPS/TPS).'),(9,'Terror de Sobrevivivência','Jogos que buscam assustar o jogador, geralmente com recursos limitados e atmosfera tensa.'),(10,'Plataforma','Jogos cujo principal desafio é pular e escalar entre plataformas suspensas.'),(11,'Mundo Aberto','Jogos que apresentam um vasto mapa explorável com missões principais e secundárias não-lineares.'),(12,'Simulação','Jogos que recriam atividades e sistemas do mundo real com o máximo de fidelidade possível.');
/*!40000 ALTER TABLE `categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `cidade`
--

LOCK TABLES `cidade` WRITE;
/*!40000 ALTER TABLE `cidade` DISABLE KEYS */;
INSERT INTO `cidade` VALUES (1,25,'Suzano'),(2,25,'Mogi das Cruzes'),(3,25,'São Paulo'),(4,19,'Niterói'),(5,19,'Rio de Janeiro');
/*!40000 ALTER TABLE `cidade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `desenvolvedora`
--

LOCK TABLES `desenvolvedora` WRITE;
/*!40000 ALTER TABLE `desenvolvedora` DISABLE KEYS */;
INSERT INTO `desenvolvedora` VALUES (9,'Capcom'),(5,'CD Projekt Red'),(3,'FromSoftware'),(8,'Guerrilla Games'),(7,'Insomniac Games'),(1,'Naughty Dog'),(6,'Nintendo EPD'),(4,'Rockstar North'),(2,'Santa Monica Studio'),(10,'Square Enix'),(11,'Team Cherry');
/*!40000 ALTER TABLE `desenvolvedora` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `estado`
--

LOCK TABLES `estado` WRITE;
/*!40000 ALTER TABLE `estado` DISABLE KEYS */;
INSERT INTO `estado` VALUES (1,1,'Acre','AC'),(2,1,'Alagoas','AL'),(3,1,'Amapá','AP'),(4,1,'Amazonas','AM'),(5,1,'Bahia','BA'),(6,1,'Ceará','CE'),(7,1,'Distrito Federal','DF'),(8,1,'Espírito Santo','ES'),(9,1,'Goiás','GO'),(10,1,'Maranhão','MA'),(11,1,'Mato Grosso','MT'),(12,1,'Mato Grosso do Sul','MS'),(13,1,'Minas Gerais','MG'),(14,1,'Pará','PA'),(15,1,'Paraíba','PB'),(16,1,'Paraná','PR'),(17,1,'Pernambuco','PE'),(18,1,'Piauí','PI'),(19,1,'Rio de Janeiro','RJ'),(20,1,'Rio Grande do Norte','RN'),(21,1,'Rio Grande do Sul','RS'),(22,1,'Rondônia','RO'),(23,1,'Roraima','RR'),(24,1,'Santa Catarina','SC'),(25,1,'São Paulo','SP'),(26,1,'Sergipe','SE'),(27,1,'Tocantins','TO');
/*!40000 ALTER TABLE `estado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `fornecedor`
--

LOCK TABLES `fornecedor` WRITE;
/*!40000 ALTER TABLE `fornecedor` DISABLE KEYS */;
INSERT INTO `fornecedor` VALUES (1,'Games Brasil Distribuidora','12.345.678/0001-99','contato@gamesbrasildist.com.br'),(2,'Import Action Games','23.456.789/0001-88','sales@importaction.com'),(3,'Indie Nexus Hub','34.567.890/0001-77','parcerias@indienexus.com.br'),(4,'Player One Acessórios','45.678.901/0001-66','vendas@playeroneacessorios.com'),(5,'SP Games Logística','56.789.012/0001-55','logistica@spgames.com.br');
/*!40000 ALTER TABLE `fornecedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `grupoprecificacao`
--

LOCK TABLES `grupoprecificacao` WRITE;
/*!40000 ALTER TABLE `grupoprecificacao` DISABLE KEYS */;
INSERT INTO `grupoprecificacao` VALUES (1,'Lançamento AAA',40.00),(2,'Padrão',60.00),(3,'Promoção',25.50),(4,'Econômico (Hits)',75.00),(5,'Edição Especial',45.00);
/*!40000 ALTER TABLE `grupoprecificacao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `pais`
--

LOCK TABLES `pais` WRITE;
/*!40000 ALTER TABLE `pais` DISABLE KEYS */;
INSERT INTO `pais` VALUES (1,'Brasil');
/*!40000 ALTER TABLE `pais` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `plataforma`
--

LOCK TABLES `plataforma` WRITE;
/*!40000 ALTER TABLE `plataforma` DISABLE KEYS */;
INSERT INTO `plataforma` VALUES (1,'PlayStation 5','Sony'),(2,'PlayStation 4','Sony'),(3,'Xbox Series X|S','Microsoft'),(4,'Xbox One','Microsoft'),(5,'Nintendo Switch','Nintendo');
/*!40000 ALTER TABLE `plataforma` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `publicadora`
--

LOCK TABLES `publicadora` WRITE;
/*!40000 ALTER TABLE `publicadora` DISABLE KEYS */;
INSERT INTO `publicadora` VALUES (4,'Bandai Namco Entertainment'),(6,'Electronic Arts (EA)'),(3,'Microsoft (Xbox Game Studios)'),(2,'Nintendo'),(9,'Sega'),(1,'Sony Interactive Entertainment'),(5,'Take-Two Interactive'),(10,'Team Cherry'),(7,'Ubisoft'),(8,'Warner Bros. Games');
/*!40000 ALTER TABLE `publicadora` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tipo_endereco`
--

LOCK TABLES `tipo_endereco` WRITE;
/*!40000 ALTER TABLE `tipo_endereco` DISABLE KEYS */;
INSERT INTO `tipo_endereco` VALUES (1,'Entrega'),(2,'Cobrança');
/*!40000 ALTER TABLE `tipo_endereco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tipo_logradouro`
--

LOCK TABLES `tipo_logradouro` WRITE;
/*!40000 ALTER TABLE `tipo_logradouro` DISABLE KEYS */;
INSERT INTO `tipo_logradouro` VALUES (1,'Rua'),(2,'Avenida'),(3,'Praça'),(4,'Alameda'),(5,'Travessa'),(6,'Estrada');
/*!40000 ALTER TABLE `tipo_logradouro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tipo_residencia`
--

LOCK TABLES `tipo_residencia` WRITE;
/*!40000 ALTER TABLE `tipo_residencia` DISABLE KEYS */;
INSERT INTO `tipo_residencia` VALUES (1,'Casa'),(2,'Apartamento'),(3,'Condomínio'),(4,'Comercial');
/*!40000 ALTER TABLE `tipo_residencia` ENABLE KEYS */;
UNLOCK TABLES;

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

-- Dump completed on 2025-08-27 15:24:29
