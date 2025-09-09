using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Ecommerce_Jogos.Controllers
{
    public class RecomendacaoController : Controller
    {
        // GET: RecomendacaoController
        public IActionResult Index()
        {
            return View();
        }

        // GET: RecomendacaoController/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: RecomendacaoController/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: RecomendacaoController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: RecomendacaoController/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: RecomendacaoController/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: RecomendacaoController/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: RecomendacaoController/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }
    }
}
