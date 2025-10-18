using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using SeleniumExtras.WaitHelpers;
using System;
using System.Globalization;
using System.Threading;

namespace Ecommerce_Jogos.Tests.Selenium
{
    [TestFixture]
    public class CarrinhoTests
    {
        private IWebDriver _driver;
        private WebDriverWait _wait;
        private string _baseUrl = "https://localhost:7175";

        private const string ClienteEmail = "teste@teste.com";
        private const string ClienteSenha = "Senha123@";
        private const int ProdutoId = 2;
        private const string NomeProdutoEsperado = "Starfield";
        private const int EnderecoId = 95;
        private const int CartaoId = 49;
        private const string CupomCodigo = "PROMO10";

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
        public void AdicionarProdutoAoCarrinho()
        {
            LoginCliente();
            AdicionarProdutoAoCarrinho(ProdutoId);
            NavegarParaCarrinho();

            var itemNoCarrinho = _driver.FindElements(By.XPath($"//div[contains(@class, 'card-body')]//h5[contains(text(), '{NomeProdutoEsperado}')]"));
            Assert.That(itemNoCarrinho.Count, Is.GreaterThan(0), $"O produto '{NomeProdutoEsperado}' não foi encontrado no carrinho.");
        }

        [Test]
        public void RealizarCompraCompleta()
        {
            NavegarParaCheckoutAposAdicionarProduto(ProdutoId);
            PreencherCheckoutBasico(EnderecoId);
            AplicarCupom(CupomCodigo);
            PreencherPagamentoUnicoCartao(CartaoId);
            FinalizarCompra();

            VerificarPaginaConfirmacao();
        }

        [Test]
        public void ValidarCheckoutSemDados()
        {
            NavegarParaCheckoutAposAdicionarProduto(ProdutoId);
            var botaoFinalizar = By.XPath("//button[contains(text(), 'Finalizar e Pagar')]");

            ScrollToAndClick(botaoFinalizar);
            var erroEndereco = _wait.Until(ExpectedConditions.ElementIsVisible(By.Id("endereco-error")));
            Assert.Multiple(() =>
            {
                Assert.That(erroEndereco.Displayed, Is.True, "Erro de endereço não apareceu.");
                Assert.That(_driver.Url, Does.Contain("/Checkout"), "Saiu da página sem endereço.");
            });


            PreencherCheckoutBasico(EnderecoId);
            _wait.Until(ExpectedConditions.InvisibilityOfElementLocated(By.Id("endereco-error")));

            ScrollToAndClick(botaoFinalizar);
            var erroPagamento = _wait.Until(ExpectedConditions.ElementIsVisible(By.Id("pagamento-error")));
            Assert.Multiple(() =>
            {
                Assert.That(erroPagamento.Displayed, Is.True, "Erro de pagamento não apareceu.");
                Assert.That(_driver.Url, Does.Contain("/Checkout"), "Saiu da página sem pagamento.");
            });
        }

        [Test]
        public void ValidarCheckoutPagamentoInsuficiente()
        {
            NavegarParaCheckoutAposAdicionarProduto(ProdutoId);
            PreencherCheckoutBasico(EnderecoId);
            PreencherPagamentoUnicoCartao(CartaoId, 5.00m);
            var botaoFinalizar = By.XPath("//button[contains(text(), 'Finalizar e Pagar')]");
            ScrollToAndClick(botaoFinalizar);

            var erroPagamento = _wait.Until(ExpectedConditions.ElementIsVisible(By.Id("pagamento-error")));
            Assert.Multiple(() =>
            {
                Assert.That(erroPagamento.Displayed, Is.True, "Erro de pagamento insuficiente não apareceu.");
                Assert.That(_driver.Url, Does.Contain("/Checkout"), "Saiu da página com pagamento insuficiente.");
            });
        }


        private void LoginCliente()
        {
            _driver.Navigate().GoToUrl($"{_baseUrl}/Conta/Login");
            _wait.Until(ExpectedConditions.ElementIsVisible(By.Id("Email"))).SendKeys(ClienteEmail);
            _driver.FindElement(By.Id("Senha")).SendKeys(ClienteSenha);
            _driver.FindElement(By.XPath("//button[@type='submit']")).Click();
            _wait.Until(ExpectedConditions.UrlContains("/Produtos/Catalogo"));
        }

        private void AdicionarProdutoAoCarrinho(int produtoId)
        {
            _driver.Navigate().GoToUrl($"{_baseUrl}/Produtos/Catalogo");
            _wait.Until(ExpectedConditions.ElementIsVisible(By.CssSelector(".card")));
            var botaoAdicionarLocator = By.XPath($"//button[@data-produto-id='{produtoId}']");
            ScrollToAndClick(botaoAdicionarLocator);
            EsperarBotaoAdicionarSucesso(botaoAdicionarLocator);
            Thread.Sleep(500);
        }

        private void NavegarParaCarrinho()
        {
            _driver.Navigate().GoToUrl($"{_baseUrl}/Carrinho");
            _wait.Until(ExpectedConditions.ElementIsVisible(By.Id("carrinho-itens")));
        }

        private void NavegarParaCheckoutAposAdicionarProduto(int produtoId)
        {
            LoginCliente();
            AdicionarProdutoAoCarrinho(produtoId);
            NavegarParaCarrinho();
            ScrollToAndClick(By.CssSelector("a.btn-finalizar-compra"));
            _wait.Until(ExpectedConditions.UrlContains("/Checkout"));
            _wait.Until(ExpectedConditions.ElementIsVisible(By.Id("address-selection")));
        }

        private void PreencherCheckoutBasico(int enderecoId)
        {
            var enderecoRadioLocator = By.Id($"endereco-{enderecoId}");
            ScrollToAndClick(enderecoRadioLocator);
            _wait.Until(driver => !driver.FindElement(By.Id("frete-valor")).Text.Contains("Selecione"));
            _wait.Until(driver => !driver.FindElement(By.Id("frete-valor")).Text.Contains("Calculando"));
        }

        private void AplicarCupom(string cupomCodigo)
        {
            ScrollToAndClick(By.Id("cupom-input"));
            _driver.FindElement(By.Id("cupom-input")).SendKeys(cupomCodigo);
            _driver.FindElement(By.Id("btn-aplicar-cupom")).Click();
            _wait.Until(ExpectedConditions.ElementIsVisible(By.Id($"cupom-{cupomCodigo}")));
            _wait.Until(driver => driver.FindElement(By.Id("valor-restante-resumo")).Text != "");
        }

        private void PreencherPagamentoUnicoCartao(int cartaoId)
        {
            var valorRestanteTexto = _wait.Until(d => d.FindElement(By.Id("valor-restante-resumo"))).Text;
            var valorFormatado = valorRestanteTexto.Replace("R$", "").Trim();
            PreencherPagamentoUnicoCartao(cartaoId, valorFormatado);
        }

        private void PreencherPagamentoUnicoCartao(int cartaoId, decimal valor)
        {
            var valorFormatado = valor.ToString("N2", CultureInfo.GetCultureInfo("pt-BR"));
            PreencherPagamentoUnicoCartao(cartaoId, valorFormatado);
        }

        private void PreencherPagamentoUnicoCartao(int cartaoId, string valorStringFormatada)
        {
            var cartaoLabelLocator = By.CssSelector($"label[for='cartao-{cartaoId}']");
            ScrollToAndClick(cartaoLabelLocator);
            var valorCartaoInputLocator = By.CssSelector($"#valor-cartao-{cartaoId} input.valor-pagamento");
            var valorCartaoInput = _wait.Until(ExpectedConditions.ElementIsVisible(valorCartaoInputLocator));
            valorCartaoInput.SendKeys(valorStringFormatada);
        }

        private void FinalizarCompra()
        {
            ScrollToAndClick(By.XPath("//button[contains(text(), 'Finalizar e Pagar')]"));
        }

        private void VerificarPaginaConfirmacao()
        {
            _wait.Until(ExpectedConditions.UrlContains("/Pedidos/Confirmacao"));
            var h1Confirmacao = _wait.Until(ExpectedConditions.ElementIsVisible(By.TagName("h1")));
            Assert.That(h1Confirmacao.Text, Is.EqualTo("Obrigado pela sua compra!"), "Não foi redirecionado para a página de confirmação correta.");
        }

        private void EsperarBotaoAdicionarSucesso(By locator)
        {
            try
            {
                _wait.Until(driver => {
                    try
                    {
                        var buttonElement = driver.FindElement(locator);
                        return buttonElement.GetAttribute("class").Contains("btn-success");
                    }
                    catch (NoSuchElementException) { return false; }
                    catch (StaleElementReferenceException) { return false; }
                });
            }
            catch (WebDriverTimeoutException)
            {
                Assert.Fail($"O botão localizado por '{locator}' não mudou para o estado 'sucesso' a tempo.");
            }
        }

        private void ScrollToAndClick(By locator)
        {
            var element = _wait.Until(ExpectedConditions.ElementExists(locator));
            IJavaScriptExecutor js = (IJavaScriptExecutor)_driver;
            js.ExecuteScript("arguments[0].scrollIntoView({behavior: 'auto', block: 'center'});", element);
            _wait.Until(ExpectedConditions.ElementToBeClickable(element));
            element.Click();
        }
    }
}