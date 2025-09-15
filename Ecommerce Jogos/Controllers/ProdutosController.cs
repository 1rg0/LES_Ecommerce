using Ecommerce_Jogos.Data;
using Ecommerce_Jogos.Helpers;
using Ecommerce_Jogos.Models;
using Ecommerce_Jogos.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using System.Globalization;
using System.Security.Claims;

namespace Ecommerce_Jogos.Controllers
{
    public class ProdutosController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly LogService _logService;

        public ProdutosController(ApplicationDbContext context, LogService logService)
        {
            _context = context;
            _logService = logService;
        }

        public async Task<IActionResult> Index(string filtroTitulo, string filtroEdicao, int? filtroPlataforma, int? filtroDesenvolvedora, int? filtroPublicadora, int? filtroGrupoPrecificacao, int? filtroAnoInicio, int? filtroAnoFim, string filtroStatus, int pageNumber = 1)
        {
            var produtosQuery = _context.Produtos
                                        .Include(p => p.Plataforma)
                                        .AsQueryable();

            if (!string.IsNullOrEmpty(filtroTitulo))
            {
                produtosQuery = produtosQuery.Where(p => p.Nome.Contains(filtroTitulo));
            }
            if (!string.IsNullOrEmpty(filtroEdicao))
            {
                produtosQuery = produtosQuery.Where(p => p.Edicao.Contains(filtroEdicao));
            }
            if (filtroPlataforma.HasValue)
            {
                produtosQuery = produtosQuery.Where(p => p.PlataformaID == filtroPlataforma.Value);
            }
            if (filtroDesenvolvedora.HasValue)
            {
                produtosQuery = produtosQuery.Where(p => p.DesenvolvedoraID == filtroDesenvolvedora.Value);
            }
            if (filtroPublicadora.HasValue)
            {
                produtosQuery = produtosQuery.Where(p => p.PublicadoraID == filtroPublicadora.Value);
            }
            if (filtroGrupoPrecificacao.HasValue)
            {
                produtosQuery = produtosQuery.Where(p => p.GrupoPrecificacaoID == filtroGrupoPrecificacao.Value);
            }
            if (filtroAnoInicio.HasValue)
            {
                produtosQuery = produtosQuery.Where(p => p.AnoLancamento >= filtroAnoInicio.Value);
            }
            if (filtroAnoFim.HasValue)
            {
                produtosQuery = produtosQuery.Where(p => p.AnoLancamento <= filtroAnoFim.Value);
            }
            if (!string.IsNullOrEmpty(filtroStatus))
            {
                bool status = filtroStatus == "true";
                produtosQuery = produtosQuery.Where(p => p.Ativo == status);
            }

            ViewBag.Plataformas = new SelectList(_context.Plataformas.OrderBy(p => p.Nome), "ID", "Nome", filtroPlataforma);
            ViewBag.Desenvolvedoras = new SelectList(_context.Desenvolvedoras.OrderBy(d => d.Nome), "ID", "Nome", filtroDesenvolvedora);
            ViewBag.Publicadoras = new SelectList(_context.Publicadoras.OrderBy(p => p.Nome), "ID", "Nome", filtroPublicadora);
            ViewBag.GruposPrecificacao = new SelectList(_context.GruposPrecificacao.OrderBy(g => g.Nome), "ID", "Nome", filtroGrupoPrecificacao);

            int pageSize = 10;
            var produtosPaginados = await ListaPaginada<Produto>.CreateAsync(produtosQuery.AsNoTracking().OrderBy(p => p.ID), pageNumber, pageSize);

            return View(produtosPaginados);
        }

        public async Task<IActionResult> Catalogo(string searchString, int? plataformaId, int[] categoriaIds)
        {
            var produtosQuery = _context.Produtos
                .Include(p => p.Plataforma)
                .Include(p => p.Categorias)
                .Where(p => p.Ativo && p.PrecoVenda > 0);

            if (!string.IsNullOrEmpty(searchString))
            {
                produtosQuery = produtosQuery.Where(p => p.Nome.Contains(searchString));
            }

            if (plataformaId.HasValue)
            {
                produtosQuery = produtosQuery.Where(p => p.PlataformaID == plataformaId.Value);
            }

            if (categoriaIds != null && categoriaIds.Length > 0)
            {
                produtosQuery = produtosQuery.Where(p => p.Categorias.Any(c => categoriaIds.Contains(c.ID)));
            }

            var viewModel = new CatalogoViewModel
            {
                Plataformas = new SelectList(await _context.Plataformas.OrderBy(pl => pl.Nome).ToListAsync(), "ID", "Nome", plataformaId),
                Categorias = await _context.Categorias.OrderBy(c => c.Nome).ToListAsync(),

                Produtos = await produtosQuery.ToListAsync(),

                SearchString = searchString,
                PlataformaId = plataformaId,
                CategoriaIds = categoriaIds
            };

            return View(viewModel);
        }

        public async Task<IActionResult> Details(int id)
        {
            var produto = await _context.Produtos
                .Include(p => p.Plataforma)
                .Include(p => p.Categorias)
                .Include(p => p.Desenvolvedora)
                .Include(p => p.Publicadora)
                .FirstOrDefaultAsync(p => p.ID == id);

            if (produto == null)
            {
                return NotFound();
            }

            var quantidadeEmEstoque = await _context.EntradasEstoque
                                            .Where(e => e.ProdutoID == id)
                                            .SumAsync(e => e.Quantidade);

            ViewBag.QuantidadeEmEstoque = quantidadeEmEstoque;

            return View(produto);
        }

        public IActionResult Create()
        {
            var viewModel = new ProdutoCreateViewModel();

            ViewBag.Plataformas = new SelectList(_context.Plataformas.OrderBy(p => p.ID), "ID", "Nome");
            ViewBag.Desenvolvedoras = new SelectList(_context.Desenvolvedoras.OrderBy(d => d.ID), "ID", "Nome");
            ViewBag.Publicadoras = new SelectList(_context.Publicadoras.OrderBy(p => p.ID), "ID", "Nome");
            var gruposPrecificacao = _context.GruposPrecificacao.OrderBy(g => g.Nome)
            .Select(g => new {g.ID,NomeComMargem = $"{g.Nome} ({g.MargemLucro.ToString("F2")}% de margem)"}).ToList();
            ViewBag.GruposPrecificacao = new SelectList(gruposPrecificacao, "ID", "NomeComMargem", viewModel.GrupoPrecificacaoID);

            ViewBag.Categorias = _context.Categorias.OrderBy(c => c.Nome).ToList();

            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(ProdutoCreateViewModel viewModel)
        {
            ValidateDecimalField(viewModel.AlturaCm, "AlturaCm", "A altura deve ser um número válido maior que zero.");
            ValidateDecimalField(viewModel.LarguraCm, "LarguraCm", "A largura deve ser um número válido maior que zero.");
            ValidateDecimalField(viewModel.ProfundidadeCm, "ProfundidadeCm", "A profundidade deve ser um número válido maior que zero.");
            ValidateDecimalField(viewModel.PesoGramas, "PesoGramas", "O peso deve ser um número válido maior que zero.");

            if (!ModelState.IsValid)
            {
                ViewBag.Plataformas = new SelectList(_context.Plataformas.OrderBy(p => p.Nome), "ID", "Nome", viewModel.PlataformaID);
                ViewBag.Desenvolvedoras = new SelectList(_context.Desenvolvedoras.OrderBy(d => d.Nome), "ID", "Nome", viewModel.DesenvolvedoraID);
                ViewBag.Publicadoras = new SelectList(_context.Publicadoras.OrderBy(p => p.Nome), "ID", "Nome", viewModel.PublicadoraID);
                var gruposPrecificacao = _context.GruposPrecificacao.OrderBy(g => g.Nome)
                    .Select(g => new { g.ID, NomeComMargem = $"{g.Nome} ({g.MargemLucro.ToString("F2")}% de margem)" }).ToList();
                ViewBag.GruposPrecificacao = new SelectList(gruposPrecificacao, "ID", "NomeComMargem", viewModel.GrupoPrecificacaoID);
                ViewBag.Categorias = _context.Categorias.OrderBy(c => c.Nome).ToList();
                return View(viewModel);
            }

            var culture = CultureInfo.InvariantCulture;

            var novoProduto = new Produto
            {
                Nome = viewModel.Nome,
                Sinopse = viewModel.Sinopse,
                PlataformaID = viewModel.PlataformaID,
                AnoLancamento = viewModel.AnoLancamento,
                DesenvolvedoraID = viewModel.DesenvolvedoraID,
                PublicadoraID = viewModel.PublicadoraID,
                Edicao = viewModel.Edicao,
                URLImagem = viewModel.URLImagem,
                AlturaCm = !string.IsNullOrWhiteSpace(viewModel.AlturaCm) ? decimal.Parse(viewModel.AlturaCm.Replace(",", "."), culture) : 0,
                LarguraCm = !string.IsNullOrWhiteSpace(viewModel.LarguraCm) ? decimal.Parse(viewModel.LarguraCm.Replace(",", "."), culture) : 0,
                ProfundidadeCm = !string.IsNullOrWhiteSpace(viewModel.ProfundidadeCm) ? decimal.Parse(viewModel.ProfundidadeCm.Replace(",", "."), culture) : 0,
                PesoGramas = !string.IsNullOrWhiteSpace(viewModel.PesoGramas) ? decimal.Parse(viewModel.PesoGramas.Replace(",", "."), culture) : 0,
                GrupoPrecificacaoID = viewModel.GrupoPrecificacaoID,
                CodigoBarras = viewModel.CodigoBarras,
                PrecoCusto = 0,
                PrecoVenda = 0,
                Ativo = true
            };

            if (viewModel.CategoriaIDs != null && viewModel.CategoriaIDs.Any())
            {
                var categoriasSelecionadas = await _context.Categorias
                                                    .Where(c => viewModel.CategoriaIDs.Contains(c.ID))
                                                    .ToListAsync();
                novoProduto.Categorias = categoriasSelecionadas;
            }

            _context.Produtos.Add(novoProduto);
            await _context.SaveChangesAsync();

            await _logService.RegistrarLog(
                adminId: GetCurrentAdminId(),
                tipoOperacao: "INSERÇÃO",
                tabela: "Produto",
                registroId: novoProduto.ID,
                dadosAntigos: null,
                dadosNovos: novoProduto
            );

            await _context.SaveChangesAsync();

            return RedirectToAction("Index");
        }

        public async Task<IActionResult> Edit(int id)
        {
            var produto = await _context.Produtos
                .Include(p => p.Categorias)
                .FirstOrDefaultAsync(p => p.ID == id);

            if (produto == null)
            {
                return NotFound();
            }

            var viewModel = new ProdutoEditViewModel
            {
                Id = produto.ID,
                Nome = produto.Nome,
                Sinopse = produto.Sinopse,
                PlataformaID = produto.PlataformaID,
                AnoLancamento = produto.AnoLancamento,
                DesenvolvedoraID = produto.DesenvolvedoraID,
                PublicadoraID = produto.PublicadoraID,
                Edicao = produto.Edicao,
                URLImagem = produto.URLImagem,
                AlturaCm = produto.AlturaCm.ToString(CultureInfo.InvariantCulture),
                LarguraCm = produto.LarguraCm.ToString(CultureInfo.InvariantCulture),
                ProfundidadeCm = produto.ProfundidadeCm.ToString(CultureInfo.InvariantCulture),
                PesoGramas = produto.PesoGramas.ToString(CultureInfo.InvariantCulture),
                GrupoPrecificacaoID = produto.GrupoPrecificacaoID,
                CodigoBarras = produto.CodigoBarras,
                PrecoCusto = produto.PrecoCusto.ToString("F2"),
                PrecoVenda = produto.PrecoVenda.ToString("F2"),
                CategoriaIDs = produto.Categorias.Select(c => c.ID).ToList(),
                UsuarioIsGerente = User.IsInRole("Gerente"),
                MargemLucro = produto.GrupoPrecificacao?.MargemLucro ?? 0
            };

            ViewBag.Plataformas = new SelectList(_context.Plataformas.OrderBy(p => p.Nome), "ID", "Nome", viewModel.PlataformaID);
            ViewBag.Desenvolvedoras = new SelectList(_context.Desenvolvedoras.OrderBy(d => d.Nome), "ID", "Nome", viewModel.DesenvolvedoraID);
            ViewBag.Publicadoras = new SelectList(_context.Publicadoras.OrderBy(p => p.Nome), "ID", "Nome", viewModel.PublicadoraID);
            ViewBag.Categorias = _context.Categorias.OrderBy(c => c.Nome).ToList();

            var gruposPrecificacao = _context.GruposPrecificacao.OrderBy(g => g.Nome)
                .Select(g => new {
                    g.ID,
                    NomeComMargem = $"{g.Nome} ({g.MargemLucro.ToString("F2")}% de margem)"
                }).ToList();
            ViewBag.GruposPrecificacao = new SelectList(gruposPrecificacao, "ID", "NomeComMargem", viewModel.GrupoPrecificacaoID);

            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, ProdutoEditViewModel viewModel)
        {
            if (id != viewModel.Id)
            {
                return NotFound();
            }

            ValidateDecimalField(viewModel.AlturaCm, "AlturaCm", "A altura deve ser um número válido maior que zero.");
            ValidateDecimalField(viewModel.LarguraCm, "LarguraCm", "A largura deve ser um número válido maior que zero.");
            ValidateDecimalField(viewModel.ProfundidadeCm, "ProfundidadeCm", "A profundidade deve ser um número válido maior que zero.");
            ValidateDecimalField(viewModel.PesoGramas, "PesoGramas", "O peso deve ser um número válido maior que zero.");

            if (ModelState.IsValid)
            {
                var precoCusto = decimal.Parse(viewModel.PrecoCusto);
                var precoVenda = decimal.Parse(viewModel.PrecoVenda);
                var grupoPrecificacao = await _context.GruposPrecificacao.FindAsync(viewModel.GrupoPrecificacaoID);

                if (grupoPrecificacao != null)
                {
                    var precoMinimo = precoCusto * (1 + (grupoPrecificacao.MargemLucro / 100));
                    if (precoVenda < precoMinimo)
                    {
                        if (!User.IsInRole("Gerente"))
                        {
                            ModelState.AddModelError("PrecoVenda", $"O preço de venda não respeita a margem de lucro de {grupoPrecificacao.MargemLucro}%. O valor mínimo deve ser {precoMinimo.ToString("C")}.");
                        }
                    }
                }
            }

            if (ModelState.IsValid)
            {
                try
                {
                    var dadosAntigos = await _context.Produtos
                        .Include(p => p.Categorias)
                        .AsNoTracking()
                        .FirstOrDefaultAsync(p => p.ID == id);

                    if (dadosAntigos == null)
                    {
                        return NotFound();
                    }

                    var produtoParaAtualizar = await _context.Produtos
                        .Include(p => p.Categorias)
                        .FirstOrDefaultAsync(p => p.ID == id);

                    if (produtoParaAtualizar == null)
                    {
                        return NotFound();
                    }

                    var culture = CultureInfo.InvariantCulture;

                    produtoParaAtualizar.Nome = viewModel.Nome;
                    produtoParaAtualizar.Sinopse = viewModel.Sinopse;
                    produtoParaAtualizar.PlataformaID = viewModel.PlataformaID;
                    produtoParaAtualizar.AnoLancamento = viewModel.AnoLancamento;
                    produtoParaAtualizar.DesenvolvedoraID = viewModel.DesenvolvedoraID;
                    produtoParaAtualizar.PublicadoraID = viewModel.PublicadoraID;
                    produtoParaAtualizar.Edicao = viewModel.Edicao;
                    produtoParaAtualizar.URLImagem = viewModel.URLImagem;
                    produtoParaAtualizar.AlturaCm = !string.IsNullOrWhiteSpace(viewModel.AlturaCm) ? decimal.Parse(viewModel.AlturaCm.Replace(",", "."), culture) : 0;
                    produtoParaAtualizar.LarguraCm = !string.IsNullOrWhiteSpace(viewModel.LarguraCm) ? decimal.Parse(viewModel.LarguraCm.Replace(",", "."), culture) : 0;
                    produtoParaAtualizar.ProfundidadeCm = !string.IsNullOrWhiteSpace(viewModel.ProfundidadeCm) ? decimal.Parse(viewModel.ProfundidadeCm.Replace(",", "."), culture) : 0;
                    produtoParaAtualizar.PesoGramas = !string.IsNullOrWhiteSpace(viewModel.PesoGramas) ? decimal.Parse(viewModel.PesoGramas.Replace(",", "."), culture) : 0;
                    produtoParaAtualizar.GrupoPrecificacaoID = viewModel.GrupoPrecificacaoID;
                    produtoParaAtualizar.CodigoBarras = viewModel.CodigoBarras;
                    produtoParaAtualizar.PrecoCusto = decimal.Parse(viewModel.PrecoCusto);
                    produtoParaAtualizar.PrecoVenda = decimal.Parse(viewModel.PrecoVenda);

                    produtoParaAtualizar.Categorias.Clear();
                    if (viewModel.CategoriaIDs != null && viewModel.CategoriaIDs.Any())
                    {
                        var categoriasSelecionadas = await _context.Categorias
                            .Where(c => viewModel.CategoriaIDs.Contains(c.ID))
                            .ToListAsync();

                        produtoParaAtualizar.Categorias = categoriasSelecionadas;
                    }

                    await _logService.RegistrarLog(
                        adminId: GetCurrentAdminId(),
                        tipoOperacao: "ALTERAÇÃO",
                        tabela: "Produto",
                        registroId: produtoParaAtualizar.ID,
                        dadosAntigos: dadosAntigos,
                        dadosNovos: produtoParaAtualizar
                    );

                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    throw;
                }
                return RedirectToAction(nameof(Index));
            }

            ViewBag.Plataformas = new SelectList(_context.Plataformas.OrderBy(p => p.Nome), "ID", "Nome", viewModel.PlataformaID);
            ViewBag.Desenvolvedoras = new SelectList(_context.Desenvolvedoras.OrderBy(d => d.Nome), "ID", "Nome", viewModel.DesenvolvedoraID);
            ViewBag.Publicadoras = new SelectList(_context.Publicadoras.OrderBy(p => p.Nome), "ID", "Nome", viewModel.PublicadoraID);
            ViewBag.Categorias = _context.Categorias.OrderBy(c => c.Nome).ToList();

            var gruposPrecificacao = _context.GruposPrecificacao.OrderBy(g => g.Nome)
                .Select(g => new {
                    g.ID,
                    NomeComMargem = $"{g.Nome} ({g.MargemLucro.ToString("F2")}% de margem)"
                }).ToList();
            ViewBag.GruposPrecificacao = new SelectList(gruposPrecificacao, "ID", "NomeComMargem", viewModel.GrupoPrecificacaoID);

            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var produto = await _context.Produtos.FindAsync(id);
            if (produto == null)
            {
                return NotFound();
            }

            var entradasDeEstoque = await _context.EntradasEstoque
                                  .Where(e => e.ProdutoID == id)
                                  .ToListAsync();

            if (entradasDeEstoque.Any())
            {
                _context.EntradasEstoque.RemoveRange(entradasDeEstoque);
            }

            _context.Produtos.Remove(produto);
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ToggleStatus(int id, string motivo)
        {
            var dadosAntigos = await _context.Produtos
                .Include(p => p.Categorias)
                .AsNoTracking()
                .FirstOrDefaultAsync(p => p.ID == id);

            if (dadosAntigos == null)
            {
                return NotFound();
            }

            var produtoParaAtualizar = await _context.Produtos.FindAsync(id);
            if (produtoParaAtualizar == null)
            {
                return NotFound();
            }

            produtoParaAtualizar.Ativo = !produtoParaAtualizar.Ativo;

            string tipoOperacao = produtoParaAtualizar.Ativo ? "ATIVAÇÃO" : "INATIVAÇÃO";

            var adminId = GetCurrentAdminId();
            await _logService.RegistrarLog(
                adminId: adminId,
                tipoOperacao: tipoOperacao,
                tabela: "Produto",
                registroId: produtoParaAtualizar.ID,
                dadosAntigos: dadosAntigos,
                dadosNovos: produtoParaAtualizar,
                motivo: motivo
            );

            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = $"Produto '{produtoParaAtualizar.Nome}' foi alterado para '{(produtoParaAtualizar.Ativo ? "Ativo" : "Inativo")}' com sucesso!";
            return RedirectToAction(nameof(Index));
        }

        private void ValidateDecimalField(string value, string fieldName, string errorMessage)
        {
            if (!string.IsNullOrWhiteSpace(value))
            {
                if (decimal.TryParse(value.Replace(",", "."), CultureInfo.InvariantCulture, out decimal result))
                {
                    if (result <= 0)
                    {
                        ModelState.AddModelError(fieldName, errorMessage);
                    }
                }
                else
                {
                    ModelState.AddModelError(fieldName, "O valor inserido não é um número válido.");
                }
            }
        }

        private int? GetCurrentAdminId()
        {
            if (!User.Identity.IsAuthenticated)
            {
                return null;
            }

            var userTypeClaim = User.FindFirst("UserType");
            if (userTypeClaim?.Value != "Administrador")
            {
                return null;
            }

            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim != null && int.TryParse(userIdClaim.Value, out int adminId))
            {
                return adminId;
            }

            return null;
        }
    }
}
