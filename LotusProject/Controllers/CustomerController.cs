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
            LotusContext db = new LotusContext();
            var login = db.Customers.Where(x => x.Email.Equals(customer.email) && x.password.Equals(customer.password)).FirstOrDefault();
            if (login != null)
            {
                Session["EmailLog"] = login.Email.ToString();
                return RedirectToAction("Home", "Home");
            }
            return RedirectToAction("About", "Home");
        }


        public ActionResult Logout()
        {
            Session["emailSignIn"] = null;
            return RedirectToAction("Home", "Home");
        }
    }
}