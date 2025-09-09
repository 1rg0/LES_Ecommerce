using BCrypt.Net;
using Ecommerce_Jogos.Data;
using Ecommerce_Jogos.Helpers;
using Ecommerce_Jogos.Models;
using Ecommerce_Jogos.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace Ecommerce_Jogos.Controllers
{
    public class ClientesController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly LogService _logService;

        public ClientesController(ApplicationDbContext context, LogService logService)
        {
            _context = context;
            _logService = logService;
        }

        public async Task<IActionResult> Index(string filtroNome, string filtroCpf, string filtroEmail, string filtroStatus, int pageNumber = 1)
        {

            ViewData["FiltroNome"] = filtroNome;
            ViewData["FiltroCpf"] = filtroCpf;
            ViewData["FiltroEmail"] = filtroEmail;
            ViewData["FiltroStatus"] = filtroStatus;


            var clientesQuery = _context.Clientes.AsQueryable();


            if (!String.IsNullOrEmpty(filtroNome))
            {
                clientesQuery = clientesQuery.Where(c => c.NomeCompleto.Contains(filtroNome));
            }

            if (!String.IsNullOrEmpty(filtroCpf))
            {
                clientesQuery = clientesQuery.Where(c => c.CPF.Contains(filtroCpf));
            }

            if (!String.IsNullOrEmpty(filtroEmail))
            {
                clientesQuery = clientesQuery.Where(c => c.Email.Contains(filtroEmail));
            }

            if (!String.IsNullOrEmpty(filtroStatus))
            {
                bool status = filtroStatus == "true";
                clientesQuery = clientesQuery.Where(c => c.Ativo == status);
            }

            int pageSize = 10;
            var clientesFiltrados = await ListaPaginada<Cliente>.CreateAsync(clientesQuery.AsNoTracking().OrderBy(c => c.Id), pageNumber, pageSize);

            return View(clientesFiltrados);
        }

        public IActionResult Details(int id)
        {
            var cliente = _context.Clientes
            .Include(c => c.Enderecos)
                .ThenInclude(e => e.Cidade)
                    .ThenInclude(cid => cid.Estado)
                        .ThenInclude(est => est.Pais)
            .Include(c => c.Enderecos)
                .ThenInclude(e => e.Tipo_Endereco)
            .Include(c => c.Enderecos)
                .ThenInclude(e => e.Tipo_Residencia)
            .Include(c => c.Enderecos)
                .ThenInclude(e => e.Tipo_Logradouro)
            .Include(c => c.Telefones)
                .ThenInclude(t => t.Tipo_Telefone)
            .Include(c => c.Cartoes)
            .Include(c => c.Pedidos)
            .FirstOrDefault(c => c.Id == id);

            if (cliente == null)
            {
                return NotFound();
            }

            return View(cliente);
        }

        public IActionResult Create()
        {
            var viewModel = new ClienteFormViewModel();

            ViewBag.Cidades = new SelectList(_context.Cidades.OrderBy(c => c.Nome), "ID", "Nome");
            ViewBag.TiposEndereco = new SelectList(_context.TiposEndereco, "ID", "Tipo");
            ViewBag.TiposResidencia = new SelectList(_context.TiposResidencia, "ID", "Tipo");
            ViewBag.TiposLogradouro = new SelectList(_context.TiposLogradouro, "ID", "Tipo");
            ViewBag.TiposTelefone = new SelectList(_context.TiposTelefone, "ID", "Tipo");
            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([FromBody] ClienteFormViewModel viewModel)
        {
            if (viewModel == null)
            {
                return BadRequest("Dados do cliente não fornecidos.");
            }

            if (viewModel.Cartoes == null || !viewModel.Cartoes.Any(c => c.Preferencial))
            {
                ModelState.AddModelError("Cartoes", "É obrigatório adicionar ao menos um cartão e marcá-lo como preferencial.");
            }

            if (viewModel.Enderecos == null ||
                !viewModel.Enderecos.Any(e => e.Tipo_EnderecoID == 1) ||
                !viewModel.Enderecos.Any(e => e.Tipo_EnderecoID == 2))
            {
                ModelState.AddModelError("Enderecos", "É obrigatório adicionar ao menos um endereço de entrega e um de cobrança.");
            }

            if (ModelState.IsValid)
            {
                var novoCliente = new Cliente
                {
                    NomeCompleto = viewModel.NomeCompleto,
                    CPF = viewModel.CPF,
                    Genero = viewModel.Genero,
                    DataNascimento = viewModel.DataNascimento,
                    Email = viewModel.Email,
                    SenhaHash = BCrypt.Net.BCrypt.HashPassword(viewModel.Senha),
                    Ativo = true
                };

                novoCliente.Telefones.Add(new Telefone
                {
                    Tipo_TelefoneID = viewModel.Tipo_TelefoneID,
                    DDD = viewModel.DDD,
                    Numero = viewModel.Numero
                });

                if (viewModel.Enderecos != null && viewModel.Enderecos.Any())
                {
                    foreach (var endViewModel in viewModel.Enderecos)
                    {
                        novoCliente.Enderecos.Add(new Endereco
                        {
                            Apelido = endViewModel.Apelido,
                            CEP = endViewModel.CEP,
                            Logradouro = endViewModel.Logradouro,
                            Numero = endViewModel.Numero,
                            Bairro = endViewModel.Bairro,
                            CidadeID = endViewModel.CidadeID,
                            Tipo_EnderecoID = endViewModel.Tipo_EnderecoID,
                            Tipo_ResidenciaID = endViewModel.Tipo_ResidenciaID,
                            Tipo_LogradouroID = endViewModel.Tipo_LogradouroID,
                            Observacao = endViewModel.Observacao
                        });
                    }
                }

                if (viewModel.Cartoes != null && viewModel.Cartoes.Any())
                {
                    foreach (var cartaoViewModel in viewModel.Cartoes)
                    {
                        novoCliente.Cartoes.Add(new Cartao
                        {
                            NomeImpresso = cartaoViewModel.NomeImpresso,
                            DataValidade = cartaoViewModel.DataValidade,
                            Bandeira = cartaoViewModel.Bandeira,
                            UltimosQuatroDigitos = cartaoViewModel.UltimosQuatroDigitos,
                            Preferencial = cartaoViewModel.Preferencial
                        });
                    }
                }

                _context.Clientes.Add(novoCliente);

                await _context.SaveChangesAsync();

                var dadosNovosCompletos = new
                {
                    Cliente = novoCliente,
                    Telefones = novoCliente.Telefones.ToList(),
                    Enderecos = novoCliente.Enderecos.ToList(),
                    Cartoes = novoCliente.Cartoes.ToList()
                };

                await _logService.RegistrarLog(
                    adminId: GetCurrentAdminId(),
                    tipoOperacao: "INSERÇÃO",
                    tabela: "Cliente",
                    registroId: novoCliente.Id,
                    dadosAntigos: null,
                    dadosNovos: dadosNovosCompletos
                );

                await _context.SaveChangesAsync();

                var userTypeClaim = User.FindFirst("UserType");

                if (userTypeClaim?.Value != "Administrador")
                {
                    return Ok(new { redirectToUrl = Url.Action("Catalogo", "Produtos") });
                }

                return Ok(new { redirectToUrl = Url.Action("Index", "Clientes") });
            }

            return BadRequest(ModelState);
        }

        public async Task<IActionResult> Edit(int id)
        {
            var cliente = await _context.Clientes
                .Include(c => c.Enderecos)
                .Include(c => c.Telefones)
                .Include(c => c.Cartoes)
                .FirstOrDefaultAsync(c => c.Id == id);

            if (cliente == null)
            {
                return NotFound();
            }

            var endereco = cliente.Enderecos.FirstOrDefault();
            var telefone = cliente.Telefones.FirstOrDefault();

            var viewModel = new ClienteEdicaoViewModel
            {
                ClienteID = cliente.Id,
                NomeCompleto = cliente.NomeCompleto,
                CPF = cliente.CPF,
                Email = cliente.Email,
                DataNascimento = cliente.DataNascimento,
                Genero = cliente.Genero,

                EnderecoID = endereco?.ID ?? 0,
                Apelido = endereco?.Apelido,
                CEP = endereco?.CEP,
                Logradouro = endereco?.Logradouro,
                Numero = endereco?.Numero,
                Bairro = endereco?.Bairro,
                Observacao = endereco?.Observacao,
                CidadeID = endereco?.CidadeID ?? 0,
                Tipo_EnderecoID = endereco?.Tipo_EnderecoID ?? 0,
                Tipo_LogradouroID = endereco?.Tipo_LogradouroID ?? 0,
                Tipo_ResidenciaID = endereco?.Tipo_ResidenciaID ?? 0,

                TelefoneID = telefone?.ID ?? 0,
                DDD = telefone?.DDD,
                NumeroTelefone = telefone?.Numero,
                Tipo_TelefoneID = telefone?.Tipo_TelefoneID ?? 0,
            };

            ViewBag.Cidades = new SelectList(_context.Cidades, "ID", "Nome", viewModel.CidadeID);
            ViewBag.TiposEndereco = new SelectList(_context.TiposEndereco, "ID", "Tipo", viewModel.Tipo_EnderecoID);
            ViewBag.TiposResidencia = new SelectList(_context.TiposResidencia, "ID", "Tipo", viewModel.Tipo_ResidenciaID);
            ViewBag.TiposLogradouro = new SelectList(_context.TiposLogradouro, "ID", "Tipo", viewModel.Tipo_LogradouroID);
            ViewBag.TiposTelefone = new SelectList(_context.TiposTelefone, "ID", "Tipo", viewModel.Tipo_TelefoneID);

            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, ClienteEdicaoViewModel viewModel)
        {
            if (id != viewModel.ClienteID)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    var dadosAntigos = await _context.Clientes
                    .Include(c => c.Enderecos)
                    .Include(c => c.Telefones)
                    .AsNoTracking()
                    .FirstOrDefaultAsync(c => c.Id == viewModel.ClienteID);

                    if (dadosAntigos == null)
                    {
                        return NotFound();
                    }


                    var cliente = await _context.Clientes.FindAsync(viewModel.ClienteID);
                    var endereco = await _context.Enderecos.FindAsync(viewModel.EnderecoID);
                    var telefone = await _context.Telefones.FindAsync(viewModel.TelefoneID);

                    if (cliente == null) return NotFound();

                    cliente.NomeCompleto = viewModel.NomeCompleto;
                    cliente.CPF = viewModel.CPF;
                    cliente.Email = viewModel.Email;
                    cliente.DataNascimento = viewModel.DataNascimento;
                    cliente.Genero = viewModel.Genero;

                    if (endereco != null)
                    {
                        endereco.Apelido = viewModel.Apelido;
                        endereco.CEP = viewModel.CEP;
                        endereco.Logradouro = viewModel.Logradouro;
                        endereco.Numero = viewModel.Numero;
                        endereco.Bairro = viewModel.Bairro;
                        endereco.Observacao = viewModel.Observacao;
                        endereco.CidadeID = viewModel.CidadeID;
                        endereco.Tipo_EnderecoID = viewModel.Tipo_EnderecoID;
                        endereco.Tipo_LogradouroID = viewModel.Tipo_LogradouroID;
                        endereco.Tipo_ResidenciaID = viewModel.Tipo_ResidenciaID;
                    }

                    if (telefone != null)
                    {
                        telefone.DDD = viewModel.DDD;
                        telefone.Numero = viewModel.NumeroTelefone;
                        telefone.Tipo_TelefoneID = viewModel.Tipo_TelefoneID;
                    }

                    var dadosNovosCompletos = new
                    {
                        Cliente = cliente,
                        Endereco = endereco,
                        Telefone = telefone
                    };

                    await _logService.RegistrarLog(
                        adminId: GetCurrentAdminId(),
                        tipoOperacao: "ALTERAÇÃO",
                        tabela: "Cliente",
                        registroId: cliente.Id,
                        dadosAntigos: dadosAntigos,
                        dadosNovos: dadosNovosCompletos
                    );

                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    throw;
                }
                return RedirectToAction("Details", new { id = viewModel.ClienteID });
            }

            ViewBag.Cidades = new SelectList(_context.Cidades, "ID", "Nome", viewModel.CidadeID);
            ViewBag.TiposEndereco = new SelectList(_context.TiposEndereco, "ID", "Tipo", viewModel.Tipo_EnderecoID);
            ViewBag.TiposResidencia = new SelectList(_context.TiposResidencia, "ID", "Tipo", viewModel.Tipo_ResidenciaID);
            ViewBag.TiposLogradouro = new SelectList(_context.TiposLogradouro, "ID", "Tipo", viewModel.Tipo_LogradouroID);
            ViewBag.TiposTelefone = new SelectList(_context.TiposTelefone, "ID", "Tipo", viewModel.Tipo_TelefoneID);

            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var cliente = await _context.Clientes.FindAsync(id);
            if (cliente != null)
            {
                _context.Clientes.Remove(cliente);
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        public IActionResult ToggleStatus(int id)
        {
            var cliente = _context.Clientes.Find(id);

            if (cliente == null)
            {
                return NotFound();
            }

            cliente.Ativo = !cliente.Ativo;

            _context.SaveChanges();

            return RedirectToAction(nameof(Index));
        }

        public IActionResult AlterarSenha(int id)
        {
            var viewModel = new AlterarSenhaViewModel
            {
                ClienteID = id
            };
            return View(viewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AlterarSenha(AlterarSenhaViewModel viewModel)
        {
            if (!ModelState.IsValid)
            {
                return View(viewModel);
            }

            var cliente = await _context.Clientes.FindAsync(viewModel.ClienteID);
            if (cliente == null)
            {
                return NotFound();
            }

            if (!BCrypt.Net.BCrypt.Verify(viewModel.SenhaAtual, cliente.SenhaHash))
            {
                ModelState.AddModelError("SenhaAtual", "A senha atual está incorreta.");
                return View(viewModel);
            }

            cliente.SenhaHash = BCrypt.Net.BCrypt.HashPassword(viewModel.NovaSenha);

            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = "Senha alterada com sucesso!";

            return RedirectToAction("Details", new { id = viewModel.ClienteID });
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
