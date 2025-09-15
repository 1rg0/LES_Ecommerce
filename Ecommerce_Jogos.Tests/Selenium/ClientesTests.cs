using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using SeleniumExtras.WaitHelpers;
using System;
using System.Security.Claims;
using System.Threading;

namespace Ecommerce_Jogos.Tests.Selenium
{
    [TestFixture]
    public class ClientesTests
    {
        private IWebDriver _driver;
        private WebDriverWait _wait;
        private string _baseUrl = "https://localhost:7175";

        [SetUp]
        public void Setup()
        {
            var options = new ChromeOptions();
            options.AddArgument("--incognito");

            _driver = new ChromeDriver(options);
            _driver.Manage().Window.Maximize();
            _wait = new WebDriverWait(_driver, TimeSpan.FromSeconds(10));
        }

        [Test]
        public void DeveAcessarPaginaDeClientes()
        {
            Login();

            var tituloDaPagina = _driver.FindElement(By.TagName("h1")).Text;
            Assert.That(tituloDaPagina, Is.EqualTo("Lista de Clientes"));
        }

        [Test]
        public void DeveCadastrarClienteComEnderecoECartaoViaModais()
        {
            string nomeUnico = $"Cliente Cadastro {Guid.NewGuid().ToString().Substring(0, 4)}";
            string cpfUnico = GerarCpfValido();
            string emailUnico = $"c{cpfUnico}@teste.com";

            Login();

            CriarClienteParaTeste(nomeUnico, cpfUnico, emailUnico);

            Assert.That(_driver.Url, Does.Contain("/Clientes"), "O redirecionamento após o cadastro completo falhou.");
        }

        [Test]
        public void DeveEditarDadosDoClienteComSucesso()
        {
            string nomeOriginal = $"Cliente Para Editar {Guid.NewGuid().ToString().Substring(0, 4)}";
            string cpfOriginal = GerarCpfValido();
            string emailOriginal = $"e{cpfOriginal}@teste.com";
            string cpfFormatado = Convert.ToUInt64(cpfOriginal).ToString(@"000\.000\.000\-00");

            Login();

            CriarClienteParaTeste(nomeOriginal, cpfOriginal, emailOriginal);

            _wait.Until(ExpectedConditions.ElementIsVisible(By.ClassName("table")));

            var linhaDoCliente = _wait.Until(ExpectedConditions.ElementIsVisible(By.XPath($"//tr[td[normalize-space(.)='{nomeOriginal}']]")));

            var botaoEditar = linhaDoCliente.FindElement(By.LinkText("Editar"));
            botaoEditar.Click();

            _wait.Until(ExpectedConditions.UrlContains("/Clientes/Edit"));

            IJavaScriptExecutor js = (IJavaScriptExecutor)_driver;
            js.ExecuteScript("window.scrollTo(0, document.body.scrollHeight);");
            Thread.Sleep(500);

            var campoTelefone = _wait.Until(ExpectedConditions.ElementToBeClickable(By.Id("NumeroTelefone")));
            string novoTelefone = "99999-8888";

            campoTelefone.Clear();
            campoTelefone.SendKeys(novoTelefone);

            var botaoSalvar = _wait.Until(ExpectedConditions.ElementToBeClickable(By.CssSelector("input[type='submit'][value='Salvar Alterações']")));
            botaoSalvar.Click();

            _wait.Until(ExpectedConditions.ElementIsVisible(By.TagName("h1")));

            var elementoParagrafoTelefone = _wait.Until(ExpectedConditions.ElementIsVisible(By.XPath("//p[strong[contains(text(), 'Telefone:')]]")));

            Assert.That(elementoParagrafoTelefone.Text, Does.Contain(novoTelefone),"O número de telefone na página de detalhes não foi atualizado corretamente.");
        }

        [Test]
        public void DeveInativarClienteComSucesso()
        {
            string nome = $"Cliente Para Inativar {Guid.NewGuid().ToString().Substring(0, 4)}";
            string cpf = GerarCpfValido();
            string email = $"i{cpf}@teste.com";

            Login();

            CriarClienteParaTeste(nome, cpf, email);

            _wait.Until(ExpectedConditions.ElementIsVisible(By.ClassName("table")));

            var linhaDoCliente = _wait.Until(ExpectedConditions.ElementIsVisible(By.XPath($"//tr[td[contains(text(), '{nome}')]]")));

            var botaoInativar = linhaDoCliente.FindElement(By.XPath(".//button[text()='Inativar']"));
            botaoInativar.Click();

            _wait.Until(ExpectedConditions.ElementIsVisible(By.ClassName("table")));

            var linhaDoClienteAtualizada = _wait.Until(ExpectedConditions.ElementIsVisible(By.XPath($"//tr[td[contains(text(), '{nome}')]]")));

            var celulaStatus = linhaDoClienteAtualizada.FindElement(By.XPath("./td[5]"));

            Assert.That(celulaStatus.Text, Is.EqualTo("Inativo"), "O status do cliente não foi alterado para 'Inativo' após o clique.");
        }

        [Test]
        public void DeveAtivarUmClientePreviamenteInativado()
        {
            string nome = $"Cliente Para Ativar {Guid.NewGuid().ToString().Substring(0, 4)}";
            string cpf = GerarCpfValido();
            string email = $"a{cpf}@teste.com";

            Login();
            CriarClienteParaTeste(nome, cpf, email);

            _wait.Until(ExpectedConditions.ElementIsVisible(By.ClassName("table")));

            var linhaDoClienteOriginal = _wait.Until(ExpectedConditions.ElementIsVisible(By.XPath($"//tr[td[contains(text(), '{nome}')]]")));
            linhaDoClienteOriginal.FindElement(By.XPath(".//button[text()='Inativar']")).Click();

            _wait.Until(ExpectedConditions.ElementIsVisible(By.ClassName("table")));

            var linhaDoClienteInativo = _wait.Until(ExpectedConditions.ElementIsVisible(By.XPath($"//tr[td[contains(text(), '{nome}')]]")));

            Assert.That(linhaDoClienteInativo.FindElement(By.XPath("./td[5]")).Text, Is.EqualTo("Inativo"));

            Thread.Sleep(1000);

            linhaDoClienteInativo.FindElement(By.XPath(".//button[text()='Ativar']")).Click();

            _wait.Until(ExpectedConditions.ElementIsVisible(By.ClassName("table")));

            var linhaDoClienteFinal = _wait.Until(ExpectedConditions.ElementIsVisible(By.XPath($"//tr[td[contains(text(), '{nome}')]]")));

            var celulaStatusFinal = linhaDoClienteFinal.FindElement(By.XPath("./td[5]"));
            Assert.That(celulaStatusFinal.Text, Is.EqualTo("Ativo"), "O status do cliente não foi alterado para 'Ativo'.");
        }

        [Test]
        public void DeveGerenciarEnderecosCompletamente()
        {
            string nome = $"Cliente Enderecos {Guid.NewGuid().ToString().Substring(0, 4)}";
            string cpf = GerarCpfValido();
            string email = $"end{cpf}@teste.com";
            string cepParaEditar = "08777-123";
            string cepParaExcluir = "08777-124";

            Login();

            CriarClienteParaTeste(nome, cpf, email);

            _wait.Until(ExpectedConditions.ElementIsVisible(By.ClassName("table")));

            var linhaDoCliente = _wait.Until(ExpectedConditions.ElementIsVisible(By.XPath($"//tr[td[contains(text(), '{nome}')]]")));
            linhaDoCliente.FindElement(By.LinkText("Detalhes")).Click();
            _wait.Until(ExpectedConditions.ElementIsVisible(By.TagName("h1")));

            var linkGerenciarEnderecos = _driver.FindElement(By.LinkText("Gerenciar Endereços"));
            IJavaScriptExecutor js = (IJavaScriptExecutor)_driver;
            js.ExecuteScript("arguments[0].scrollIntoView({block: 'center'});", linkGerenciarEnderecos);
            Thread.Sleep(500);
            linkGerenciarEnderecos.Click();

            var linkParaEditar = _driver.FindElement(By.LinkText("Editar"));
            js.ExecuteScript("arguments[0].scrollIntoView({block: 'center'});", linkParaEditar);
            Thread.Sleep(200);
            var cardParaEditar = _wait.Until(ExpectedConditions.ElementIsVisible(By.XPath($"//div[contains(@class, 'card') and contains(normalize-space(.), 'CEP: {cepParaEditar}')]")));
            cardParaEditar.FindElement(By.LinkText("Editar")).Click();

            _wait.Until(ExpectedConditions.UrlContains("/Enderecos/Edit"));
            string novoApelido = "Apelido Editado Pelo Teste";
            var campoApelido = _driver.FindElement(By.Id("Apelido"));
            campoApelido.Clear();
            campoApelido.SendKeys(novoApelido);

            var botaoSalvar = _driver.FindElement(By.CssSelector("input[type='submit'][value='Salvar Alterações']"));

            js.ExecuteScript("arguments[0].scrollIntoView({block: 'center'});", botaoSalvar);
            Thread.Sleep(500);

            _wait.Until(ExpectedConditions.ElementToBeClickable(botaoSalvar)).Click();

            var cardEditado = _wait.Until(ExpectedConditions.ElementIsVisible(By.XPath($"//div[contains(@class, 'card') and contains(normalize-space(.), 'CEP: {cepParaEditar}')]")));
            Assert.That(cardEditado.Text, Does.Contain(novoApelido), "O apelido do endereço não foi atualizado corretamente.");

            _driver.FindElement(By.LinkText("Adicionar Novo Endereço")).Click();

            _wait.Until(ExpectedConditions.UrlContains("/Enderecos/Create"));
            string apelidoNovo = "Endereço Adicionado Pelo Teste";
            _driver.FindElement(By.Id("Apelido")).SendKeys(apelidoNovo);
            new SelectElement(_driver.FindElement(By.Id("Tipo_EnderecoID"))).SelectByValue("1");
            new SelectElement(_driver.FindElement(By.Id("Tipo_ResidenciaID"))).SelectByValue("1");
            _driver.FindElement(By.Id("CEP")).SendKeys("33333-333");
            new SelectElement(_driver.FindElement(By.Id("Tipo_LogradouroID"))).SelectByValue("1");
            _driver.FindElement(By.Id("Logradouro")).SendKeys("Avenida Nova");
            _driver.FindElement(By.Id("Numero")).SendKeys("300");
            _driver.FindElement(By.Id("Bairro")).SendKeys("Bairro Novo");
            new SelectElement(_driver.FindElement(By.Id("CidadeID"))).SelectByValue("1");

            botaoSalvar = _driver.FindElement(By.CssSelector("input[type='submit'][value='Finalizar Cadastro']"));

            js.ExecuteScript("arguments[0].scrollIntoView({block: 'center'});", botaoSalvar);
            Thread.Sleep(500);

            _wait.Until(ExpectedConditions.ElementToBeClickable(botaoSalvar)).Click();

            _wait.Until(ExpectedConditions.UrlContains("/Clientes/Details"));
            var corpoDaPagina = _driver.FindElement(By.TagName("body")).Text;
            Assert.That(corpoDaPagina, Does.Contain(apelidoNovo), "O novo endereço não foi encontrado na página de detalhes do cliente.");

            _wait.Until(ExpectedConditions.ElementIsVisible(By.TagName("h1")));
            linkGerenciarEnderecos = _driver.FindElement(By.LinkText("Gerenciar Endereços"));
            js = (IJavaScriptExecutor)_driver;
            js.ExecuteScript("arguments[0].scrollIntoView({block: 'center'});", linkGerenciarEnderecos);
            Thread.Sleep(500);
            linkGerenciarEnderecos.Click();

            var cardParaExcluir = _wait.Until(ExpectedConditions.ElementIsVisible(By.XPath($"//div[contains(@class, 'card') and contains(normalize-space(.), 'CEP: {cepParaExcluir}')]")));
            cardParaExcluir.FindElement(By.CssSelector("button.btn-danger")).Click();

            var modal = _wait.Until(ExpectedConditions.ElementIsVisible(By.Id("confirmDeleteModal")));
            modal.FindElement(By.XPath(".//button[text()='Excluir']")).Click();

            _wait.Until(ExpectedConditions.StalenessOf(cardParaExcluir));
            var cardsExcluidos = _driver.FindElements(By.XPath($"//div[contains(@class, 'card') and contains(normalize-space(.), 'CEP: {cepParaExcluir}')]"));
            Assert.That(cardsExcluidos.Count, Is.EqualTo(0), "O endereço não foi excluído da lista.");
        }

        [Test]
        public void DeveGerenciarCartoesCompletamente()
        {
            string nome = $"Cliente Cartoes {Guid.NewGuid().ToString().Substring(0, 4)}";
            string cpf = GerarCpfValido();
            string email = $"car{cpf}@teste.com";
            string finalCartaoParaExcluir = "4444";

            Login();
            CriarClienteParaTeste(nome, cpf, email);

            _wait.Until(ExpectedConditions.ElementIsVisible(By.ClassName("table")));

            var linhaDoCliente = _wait.Until(ExpectedConditions.ElementIsVisible(By.XPath($"//tr[td[contains(text(), '{nome}')]]")));
            linhaDoCliente.FindElement(By.LinkText("Detalhes")).Click();
            _wait.Until(ExpectedConditions.ElementIsVisible(By.TagName("h1")));

            var linkGerenciarCartoes = _driver.FindElement(By.LinkText("Gerenciar Cartões"));
            IJavaScriptExecutor js = (IJavaScriptExecutor)_driver;
            js.ExecuteScript("arguments[0].scrollIntoView({block: 'center'});", linkGerenciarCartoes);
            Thread.Sleep(500);
            linkGerenciarCartoes.Click();

            var cardParaExcluir = _wait.Until(ExpectedConditions.ElementIsVisible(By.XPath($"//div[contains(@class, 'card') and contains(normalize-space(.), 'Número: **** **** **** {finalCartaoParaExcluir}')]")));
            cardParaExcluir.FindElement(By.CssSelector("button.btn-danger")).Click();

            var modal = _wait.Until(ExpectedConditions.ElementIsVisible(By.Id("confirmDeleteModal")));
            modal.FindElement(By.XPath(".//button[text()='Excluir']")).Click();

            _wait.Until(ExpectedConditions.StalenessOf(cardParaExcluir));
            var cardsExcluidos = _driver.FindElements(By.XPath($"//div[contains(@class, 'card') and contains(normalize-space(.), 'Número: **** **** **** {finalCartaoParaExcluir}')]"));
            Assert.That(cardsExcluidos.Count, Is.EqualTo(0), "O cartão não foi excluído da lista.");

            _wait.Until(ExpectedConditions.UrlContains("/Cartoes"));

            _driver.FindElement(By.LinkText("Adicionar Novo Cartão")).Click();

            _wait.Until(ExpectedConditions.UrlContains("/Cartoes/Create"));
            string finalCartaoNovo = "5555";
            _driver.FindElement(By.Id("NumeroCartao")).SendKeys($"1111 2222 3333 {finalCartaoNovo}");
            _driver.FindElement(By.Id("NomeImpresso")).SendKeys("Novo Cartao Teste");
            _driver.FindElement(By.Id("DataValidade")).SendKeys("11/2025");
            new SelectElement(_driver.FindElement(By.Id("Bandeira"))).SelectByValue("Mastercard");
            _driver.FindElement(By.Id("CodigoSeguranca")).SendKeys("987");
            _driver.FindElement(By.Id("Preferencial")).Click();

            var botaoSalvar = _driver.FindElement(By.CssSelector("input[type='submit'][value='Salvar Cartão']"));
            js.ExecuteScript("arguments[0].scrollIntoView({block: 'center'});", botaoSalvar);
            Thread.Sleep(500);
            _wait.Until(ExpectedConditions.ElementToBeClickable(botaoSalvar)).Click();

            _wait.Until(ExpectedConditions.UrlContains("/Cartoes"));
            var cardAdicionado = _driver.FindElements(By.XPath($"//div[contains(@class, 'card') and contains(normalize-space(.), 'Número: **** **** **** {finalCartaoNovo}')]"));
            Assert.That(cardAdicionado, Is.Not.Null, "O novo cartão não foi encontrado na página de gerenciamento de cartões.");
        }

        private void Login()
        {
            _driver.Navigate().GoToUrl($"{_baseUrl}/Conta/Login");
            _driver.FindElement(By.Id("Email")).SendKeys("admin@ecommerce.com");
            _driver.FindElement(By.Id("Senha")).SendKeys("Admin123@");
            _driver.FindElement(By.XPath("//button[@type='submit']")).Click();
            _wait.Until(ExpectedConditions.UrlContains("/Clientes"));
        }

        private void CriarClienteParaTeste(string nome, string cpf, string email)
        {
            _driver.Navigate().GoToUrl($"{_baseUrl}/Clientes/Create");

            _driver.FindElement(By.Id("NomeCompleto")).SendKeys(nome);
            _driver.FindElement(By.Id("CPF")).SendKeys(cpf);
            _driver.FindElement(By.Id("DataNascimento")).SendKeys("01/01/1990");
            new SelectElement(_driver.FindElement(By.Id("Genero"))).SelectByValue("Outro");
            new SelectElement(_driver.FindElement(By.Id("Tipo_TelefoneID"))).SelectByIndex(1);
            _driver.FindElement(By.Id("DDD")).SendKeys("11");
            _driver.FindElement(By.Id("Numero")).SendKeys("98765-4321");
            _driver.FindElement(By.Id("Email")).SendKeys(email);
            _driver.FindElement(By.Id("Senha")).SendKeys("SenhaForte123!");
            _driver.FindElement(By.Id("ConfirmarSenha")).SendKeys("SenhaForte123!");

            AdicionarEndereco("Endereço Para Editar", "08777-123", "Cobrança", "123", "Bairro", "1", "2", "1", "1", "");
            AdicionarEndereco("Endereço Para Excluir", "08777-124", "Entrega", "456", "Bairro", "2", "1", "1", "1", "");

            AdicionarCartao("1111 2222 3333 4444", "Teste Cartao", "Visa", "123");

            ScrollToAndClick(By.CssSelector("input[type='submit'][value='Salvar Cliente']"));
            _wait.Until(ExpectedConditions.UrlContains("/Clientes"));
        }

        private void AdicionarEndereco(string apelido, string cep, string logradouro, string numero, string bairro, string cidadeId, string tipoEnderecoId, string tipoResidenciaId, string tipoLogradouroId, string observacao)
        {
            ScrollToAndClick(By.CssSelector("button[data-bs-target='#enderecoModal']"));

            _wait.Until(ExpectedConditions.ElementIsVisible(By.Id("enderecoModal")));

            _driver.FindElement(By.Id("apelido")).SendKeys(apelido);
            _driver.FindElement(By.Id("cep")).SendKeys(cep);
            _driver.FindElement(By.Id("logradouro")).SendKeys(logradouro);
            _driver.FindElement(By.Id("numero")).SendKeys(numero);
            _driver.FindElement(By.Id("bairro")).SendKeys(bairro);
            new SelectElement(_driver.FindElement(By.Id("cidadeId"))).SelectByValue(cidadeId);
            new SelectElement(_driver.FindElement(By.Id("tipoEnderecoId"))).SelectByValue(tipoEnderecoId);
            new SelectElement(_driver.FindElement(By.Id("tipoResidenciaId"))).SelectByValue(tipoResidenciaId);
            new SelectElement(_driver.FindElement(By.Id("tipoLogradouroId"))).SelectByValue(tipoLogradouroId);
            _driver.FindElement(By.Id("observacao")).SendKeys(observacao);

            _driver.FindElement(By.Id("btnSalvarEndereco")).Click();

            _wait.Until(ExpectedConditions.InvisibilityOfElementLocated(By.Id("enderecoModal")));
        }

        private void AdicionarCartao(string numeroCartao, string nomeImpresso, string bandeira, string cvv)
        {
            ScrollToAndClick(By.CssSelector("button[data-bs-target='#cartaoModal']"));

            _wait.Until(ExpectedConditions.ElementIsVisible(By.Id("cartaoModal")));

            _driver.FindElement(By.Id("numeroCartao")).SendKeys(numeroCartao);
            _driver.FindElement(By.Id("nomeImpresso")).SendKeys(nomeImpresso);
            _driver.FindElement(By.Id("dataValidadeCartao")).SendKeys("12/2026");
            new SelectElement(_driver.FindElement(By.Id("bandeira"))).SelectByValue(bandeira);
            _driver.FindElement(By.Id("cvv")).SendKeys(cvv);
            _driver.FindElement(By.Id("preferencial")).Click();

            _driver.FindElement(By.Id("btnSalvarCartao")).Click();

            _wait.Until(ExpectedConditions.InvisibilityOfElementLocated(By.Id("cartaoModal")));
        }

        private static string GerarCpfValido()
        {
            var random = new Random();
            int[] cpf = new int[11];

            for (int i = 0; i < 9; i++)
            {
                cpf[i] = random.Next(0, 9);
            }

            int soma = 0;
            for (int i = 0; i < 9; i++)
            {
                soma += cpf[i] * (10 - i);
            }
            int resto = soma % 11;
            cpf[9] = (resto < 2) ? 0 : 11 - resto;

            soma = 0;
            for (int i = 0; i < 10; i++)
            {
                soma += cpf[i] * (11 - i);
            }
            resto = soma % 11;
            cpf[10] = (resto < 2) ? 0 : 11 - resto;

            return string.Join("", cpf);
        }

        private void ScrollToAndClick(By locator)
        {
            //var element = _wait.Until(ExpectedConditions.ElementToBeClickable(locator));
            var element = _driver.FindElement(locator);
            IJavaScriptExecutor js = (IJavaScriptExecutor)_driver;
            js.ExecuteScript("arguments[0].scrollIntoView({block: 'center'});", element);
            Thread.Sleep(200);
            element.Click();
        }

        [TearDown]
        public void Teardown()
        {
            _driver?.Quit();
            _driver?.Dispose();
        }
    }
}