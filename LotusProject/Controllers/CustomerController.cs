using System.Linq;
using System.Web.Mvc;
using ClassLibraryModels.InputModels;
using ClassLibraryModels.ViewModels;


namespace LotusProject.Controllers
{
    public class CustomerController : Controller
    {
        [HttpPost]
        public ActionResult InsertCustomer()
        {
            return View();
        }

        [HttpPost]
        public ActionResult SignIn()
        {
            return RedirectToAction("About", "Home");
        }


        public ActionResult Logout()
        {
            return RedirectToAction("Home", "Home");
        }
    }
}