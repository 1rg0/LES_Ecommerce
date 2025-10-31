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
    public class PedidosAdminTests
    {
        private IWebDriver _driver;
        private WebDriverWait _wait;
        private string _baseUrl = "https://localhost:7175";

        private const string AdminEmail = "admin@ecommerce.com";
        private const string AdminSenha = "Admin123@";

        private const int PedidoAprovadoId = 4;
        private const int PedidoEmTransitoId = 5;
        private const int PedidoEmTrocaId = 6;
        private const int PedidoTrocaAutorizadaId = 7;
        private const int PedidoTrocadoId = 8;


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
        public void DeveAlterarStatusParaEmTransporte()
        {
            LoginAdmin();

            _driver.Navigate().GoToUrl($"{_baseUrl}/Pedidos");

            var botaoDespacharLocator = By.CssSelector($"button.btn-despachar[data-pedido-id='{PedidoAprovadoId}']");
            try
            {
                _wait.Until(ExpectedConditions.ElementIsVisible(botaoDespacharLocator));
            }
            catch (WebDriverTimeoutException)
            {
                Assert.Fail($"Não foi possível encontrar o botão 'Despachar Pedido' para o Pedido {PedidoAprovadoId}. Verifique se o pedido existe e se o status dele é 'APROVADA'.");
            }

            ScrollToAndClick(botaoDespacharLocator);

            var modalLocator = By.Id("despacharModal");
            _wait.Until(ExpectedConditions.ElementIsVisible(modalLocator));

            var botaoConfirmar = _driver.FindElement(modalLocator).FindElement(By.XPath(".//button[text()='Sim, Despachar']"));
            botaoConfirmar.Click();

            var statusBadgeLocator = By.XPath($"//tr[.//a[contains(@href, '/Pedidos/Details/{PedidoAprovadoId}')]]//span[contains(@class, 'badge')]");

            try
            {
                _wait.Until(driver => {
                    try
                    {
                        var element = driver.FindElement(statusBadgeLocator);
                        return element.Text == "EM TRÂNSITO";
                    }
                    catch (NoSuchElementException) { return false; }
                    catch (StaleElementReferenceException) { return false; }
                });
            }
            catch (WebDriverTimeoutException)
            {
                string statusAtual = "NÃO ENCONTRADO";
                try { statusAtual = _driver.FindElement(statusBadgeLocator).Text; } catch (Exception) { /* Ignora */ }
                Assert.Fail($"A página foi recarregada, mas o status do pedido não mudou para 'EM TRÂNSITO'. Status encontrado: '{statusAtual}'.");
            }

            var statusFinal = _driver.FindElement(statusBadgeLocator).Text;
            Assert.That(statusFinal, Is.EqualTo("EM TRÂNSITO"), "O status final na página não é 'EM TRÂNSITO'.");
        }

        [Test]
        public void DeveConfirmarEntregaDoPedido()
        {
            LoginAdmin();

            _driver.Navigate().GoToUrl($"{_baseUrl}/Pedidos");
            _wait.Until(ExpectedConditions.ElementIsVisible(By.CssSelector("table.table")));

            var botaoEntregarLocator = By.CssSelector($"button.btn-entregar[data-pedido-id='{PedidoEmTransitoId}']");
            try
            {
                _wait.Until(ExpectedConditions.ElementIsVisible(botaoEntregarLocator));
            }
            catch (WebDriverTimeoutException)
            {
                Assert.Fail($"Não foi possível encontrar o botão 'Confirmar Entrega' para o Pedido {PedidoEmTransitoId}. Verifique se o pedido existe e se o status dele é 'EM TRÂNSITO'.");
            }

            ScrollToAndClick(botaoEntregarLocator);

            var modalLocator = By.Id("entregueModal");
            _wait.Until(ExpectedConditions.ElementIsVisible(modalLocator));

            var botaoConfirmar = _driver.FindElement(modalLocator).FindElement(By.XPath(".//button[text()='Sim, Confirmar Entrega']"));
            botaoConfirmar.Click();

            var statusBadgeLocator = By.XPath($"//tr[.//a[contains(@href, '/Pedidos/Details/{PedidoEmTransitoId}')]]//span[contains(@class, 'badge')]");

            try
            {
                _wait.Until(driver => {
                    try
                    {
                        var element = driver.FindElement(statusBadgeLocator);
                        return element.Text == "ENTREGUE";
                    }
                    catch (NoSuchElementException) { return false; }
                    catch (StaleElementReferenceException) { return false; }
                });
            }
            catch (WebDriverTimeoutException)
            {
                string statusAtual = "NÃO ENCONTRADO";
                try { statusAtual = _driver.FindElement(statusBadgeLocator).Text; } catch (Exception) { /* Ignora */ }
                Assert.Fail($"A página foi recarregada, mas o status do pedido não mudou para 'ENTREGUE'. Status encontrado: '{statusAtual}'.");
            }

            var statusFinal = _driver.FindElement(statusBadgeLocator).Text;
            Assert.That(statusFinal, Is.EqualTo("ENTREGUE"), "O status final na página não é 'ENTREGUE'.");
        }

        [Test]
        public void DeveAutorizarSolicitacaoDeTroca()
        {
            LoginAdmin();

            _driver.Navigate().GoToUrl($"{_baseUrl}/Pedidos");

            var botaoAutorizarLocator = By.CssSelector($"button.btn-autorizar-troca[data-pedido-id='{PedidoEmTrocaId}']");
            try
            {
                _wait.Until(ExpectedConditions.ElementIsVisible(botaoAutorizarLocator));
            }
            catch (WebDriverTimeoutException)
            {
                Assert.Fail($"Não foi possível encontrar o botão 'Autorizar Troca' para o Pedido {PedidoEmTrocaId}. Verifique se o pedido existe e se o status dele é 'EM TROCA'.");
            }

            ScrollToAndClick(botaoAutorizarLocator);

            var modalLocator = By.Id("autorizarTrocaModal");
            _wait.Until(ExpectedConditions.ElementIsVisible(modalLocator));

            var botaoConfirmar = _driver.FindElement(modalLocator).FindElement(By.XPath(".//button[text()='Sim, Autorizar']"));
            botaoConfirmar.Click();

            var successAlert = _wait.Until(ExpectedConditions.ElementIsVisible(By.CssSelector(".alert.alert-success")));
            Assert.That(successAlert.Text, Does.Contain($"Troca do pedido #{PedidoEmTrocaId} autorizada com sucesso!"));

            var statusBadge = _driver.FindElement(By.XPath($"//tr[.//a[contains(@href, '/Pedidos/Details/{PedidoEmTrocaId}')]]//span[contains(@class, 'badge')]"));
            Assert.That(statusBadge.Text, Is.EqualTo("TROCA AUTORIZADA"));
        }

        [Test]
        public void DeveConfirmarRecebimentoDeTroca()
        {
            LoginAdmin();

            _driver.Navigate().GoToUrl($"{_baseUrl}/Pedidos");
            _wait.Until(ExpectedConditions.ElementIsVisible(By.CssSelector("table.table")));

            var botaoReceberTrocaLocator = By.CssSelector($"button.btn-receber-troca[data-pedido-id='{PedidoTrocaAutorizadaId}']");
            try
            {
                _wait.Until(ExpectedConditions.ElementIsVisible(botaoReceberTrocaLocator));
            }
            catch (WebDriverTimeoutException)
            {
                Assert.Fail($"Não foi possível encontrar o botão 'Confirmar Recebimento' para o Pedido {PedidoTrocaAutorizadaId}. Verifique se o pedido existe e se o status dele é 'TROCA AUTORIZADA'.");
            }

            ScrollToAndClick(botaoReceberTrocaLocator);

            var modalLocator = By.Id("receberTrocaModal");
            _wait.Until(ExpectedConditions.ElementIsVisible(modalLocator));

            var modalElement = _driver.FindElement(modalLocator);

            var checkboxRetornarEstoqueLocator = By.CssSelector("#receberTrocaModal #retornarAoEstoqueCheck");
            ScrollToAndClick(checkboxRetornarEstoqueLocator);

            var botaoConfirmarLocator = By.XPath("//div[@id='receberTrocaModal']//button[text()='Confirmar Recebimento e Gerar Cupom']");
            ScrollToAndClick(botaoConfirmarLocator);

            var statusBadgeLocator = By.XPath($"//tr[.//a[contains(@href, '/Pedidos/Details/{PedidoTrocaAutorizadaId}')]]//span[contains(@class, 'badge')]");

            try
            {
                _wait.Until(driver => {
                    try
                    {
                        var element = driver.FindElement(statusBadgeLocator);
                        return element.Text == "TROCADO";
                    }
                    catch (NoSuchElementException) { return false; }
                    catch (StaleElementReferenceException) { return false; }
                });
            }
            catch (WebDriverTimeoutException)
            {
                string statusAtual = "NÃO ENCONTRADO";
                try { statusAtual = _driver.FindElement(statusBadgeLocator).Text; } catch (Exception) { /* Ignora */ }
                Assert.Fail($"A página foi recarregada, mas o status do pedido não mudou para 'TROCADO'. Status encontrado: '{statusAtual}'.");
            }

            var statusFinal = _driver.FindElement(statusBadgeLocator).Text;
            Assert.That(statusFinal, Is.EqualTo("TROCADO"), "O status final na página não é 'TROCADO'.");
        }

        [Test]
        public void DeveVerificarGeracaoCupomTroca()
        {
            LoginAdmin();

            _driver.Navigate().GoToUrl($"{_baseUrl}/Pedidos/Details/{PedidoTrocadoId}");

            try
            {
                _wait.Until(ExpectedConditions.ElementIsVisible(By.XPath($"//h3[contains(text(), 'Detalhes do Pedido #{PedidoTrocadoId}')]")));
            }
            catch (WebDriverTimeoutException)
            {
                Assert.Fail("A página de Detalhes do Pedido não carregou ou o título está incorreto.");
            }

            By alertaCupomLocator = By.CssSelector(".alert.alert-info");
            try
            {
                _wait.Until(ExpectedConditions.ElementIsVisible(alertaCupomLocator));
            }
            catch (WebDriverTimeoutException)
            {
                string statusAtual = _driver.FindElement(By.XPath("//p[contains(text(), 'Status:')]/strong")).Text;
                Assert.Fail($"A página do Pedido {PedidoTrocadoId} foi carregada (Status: '{statusAtual}'), mas o alerta de 'Cupom de Troca Gerado' não foi encontrado.");
            }

            var alertaElement = _driver.FindElement(alertaCupomLocator);
            Assert.That(alertaElement.Text, Does.Contain("Cupom de Troca Gerado!"), "O alerta encontrado não é o de cupom de troca.");
            Assert.That(alertaElement.Text, Does.Contain("Código:"), "O alerta não exibe o código do cupom.");
            Assert.That(alertaElement.Text, Does.Contain("Valor:"), "O alerta não exibe o valor do cupom.");
        }

        private void LoginAdmin()
        {
            _driver.Navigate().GoToUrl($"{_baseUrl}/Conta/Login");
            _wait.Until(ExpectedConditions.ElementIsVisible(By.Id("Email"))).SendKeys(AdminEmail);
            _driver.FindElement(By.Id("Senha")).SendKeys(AdminSenha);
            _driver.FindElement(By.XPath("//button[@type='submit']")).Click();
            _wait.Until(ExpectedConditions.UrlContains("/Clientes"));
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