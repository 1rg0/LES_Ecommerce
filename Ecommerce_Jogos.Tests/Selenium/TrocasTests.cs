using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using SeleniumExtras.WaitHelpers;
using System;
using System.Threading;

namespace Ecommerce_Jogos.Tests.Selenium
{
    [TestFixture]
    public class TrocasTests
    {
        private IWebDriver _driver;
        private WebDriverWait _wait;
        private string _baseUrl = "https://localhost:7175";

        private const string ClienteEmail = "teste@teste.com";
        private const string ClienteSenha = "Senha123@";

        private const int PedidoEntregueId = 3;

        private const string ItemPedidoChave = "3_2";
        private const string MotivoTroca = "Teste automatizado.";


        [SetUp]
        public void Setup()
        {
            var options = new ChromeOptions();
            options.AddArgument("--incognito");
            _driver = new ChromeDriver(options);
            _driver.Manage().Window.Maximize();
            _wait = new WebDriverWait(_driver, TimeSpan.FromSeconds(15));
        }

        [TearDown]
        public void Teardown()
        {
            _driver?.Quit();
            _driver?.Dispose();
        }

        [Test]
        public void DeveSolicitarTrocaDeItemComSucesso()
        {
            LoginCliente();

            _driver.Navigate().GoToUrl($"{_baseUrl}/Pedidos/Details/{PedidoEntregueId}");

            try
            {
                _wait.Until(ExpectedConditions.ElementIsVisible(By.XPath($"//h3[contains(text(), 'Detalhes do Pedido #{PedidoEntregueId}')]")));
            }
            catch (WebDriverTimeoutException)
            {
                Assert.Fail("A página de Detalhes do Pedido não carregou ou o título está incorreto.");
            }

            var botaoSolicitarTroca = By.CssSelector($"button.btn-warning[data-pedido-id='{PedidoEntregueId}']");

            _wait.Until(ExpectedConditions.ElementIsVisible(botaoSolicitarTroca));
            ScrollToAndClick(botaoSolicitarTroca);

            var formTrocaLocator = By.Id("form-solicitar-troca");
            _wait.Until(ExpectedConditions.ElementIsVisible(formTrocaLocator));

            var itemCheckboxLocator = By.Id($"item-{ItemPedidoChave}");
            ScrollToAndClick(itemCheckboxLocator);
            _driver.FindElement(By.Id("Motivo")).SendKeys(MotivoTroca);

            var botaoConfirmarTroca = By.XPath("//button[text()='Confirmar Solicitação']");
            ScrollToAndClick(botaoConfirmarTroca);

            var statusElementLocator = By.XPath("//p[contains(text(), 'Status:')]/strong");

            try
            {
                _wait.Until(driver => {
                    try
                    {
                        var element = driver.FindElement(statusElementLocator);
                        return element.Text == "EM TROCA";
                    }
                    catch (NoSuchElementException) { return false; }
                    catch (StaleElementReferenceException) { return false; }
                });
            }
            catch (WebDriverTimeoutException)
            {
                string statusAtual = "NÃO ENCONTRADO";
                try
                {
                    statusAtual = _driver.FindElement(statusElementLocator).Text;
                }
                catch (Exception) {}

                Assert.Fail($"A página foi recarregada, mas o status do pedido não mudou para 'EM TROCA'. Status encontrado: '{statusAtual}'.");
            }
        }

        private void LoginCliente()
        {
            _driver.Navigate().GoToUrl($"{_baseUrl}/Conta/Login");
            _wait.Until(ExpectedConditions.ElementIsVisible(By.Id("Email"))).SendKeys(ClienteEmail);
            _driver.FindElement(By.Id("Senha")).SendKeys(ClienteSenha);
            _driver.FindElement(By.XPath("//button[@type='submit']")).Click();
            _wait.Until(ExpectedConditions.UrlContains("/Produtos/Catalogo"));
        }

        private void ScrollToAndClick(By locator)
        {
            var element = _wait.Until(ExpectedConditions.ElementExists(locator));
            IJavaScriptExecutor js = (IJavaScriptExecutor)_driver;
            js.ExecuteScript("arguments[0].scrollIntoView({behavior: 'auto', block: 'center'});", element);
            Thread.Sleep(500);
            _wait.Until(ExpectedConditions.ElementToBeClickable(element));
            js.ExecuteScript("arguments[0].click();", element);
        }
    }
}