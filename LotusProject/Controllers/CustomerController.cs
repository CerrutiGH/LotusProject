using System.Linq;
using System.Web.Mvc;
using ClassLibraryModels.InputModels;
using ClassLibraryModels.ViewModels;


namespace LotusProject.Controllers
{
    public class CustomerController : Controller
    {
        [HttpPost]
        public ActionResult InsertCustomer(InputCustomer customer, string cep)
        {
            return View();
        }

        [HttpPost]
        public ActionResult SignIn(InputLoginCustomer customer)
        {
            //var Sign = custact.SignIn(customer);
          
            return RedirectToAction("About", "Home");
        }


        public ActionResult Logout()
        {
            return RedirectToAction("Home", "Home");
        }
    }
}