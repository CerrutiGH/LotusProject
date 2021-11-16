using System;
using System.Linq;
using System.Web.Mvc;
using System.Web.Security;
using ClassLibraryDatabaseActions.ActionsCustomer;
using ClassLibraryModels.InputModels;
using ClassLibraryModels.ViewModels;


namespace LotusProject.Controllers
{
    public class CustomerController : Controller
    {
        ActionCustomer custumer = new ActionCustomer();
        [HttpPost]
        public ActionResult InsertCustomer()
        {
            return View();
        }

        public ActionResult ViewLoginCustomer()
        {
            return View();
        }

        public ActionResult ViewRegisterCustomer()
        {
            return View();
        }


        public ActionResult CheckEmail(string email)
        {
            bool EmailExists;

            var customer = new ActionCustomer();
            string login = customer.SelectEmail(email);

            if (login.Length == 0)
            {
                EmailExists = false;
            }
            else
            {
                EmailExists = true;
            }

            return Json(!EmailExists, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public ActionResult SignIn(InputLoginCustomer login)
        {
           
            if (!ModelState.IsValid) {
                return View(login);
            }
            ViewBag.CustumerAttributes = custumer.SignIn(login.email, login.password);

            if (ViewBag.CustumerAttributes.email != null && ViewBag.CustumerAttributes.password != null)
            {
                FormsAuthentication.Encrypt(new FormsAuthenticationTicket(1, ViewBag.CustumerAttributes.email, DateTime.Now, DateTime.Now.AddHours(12), true, ViewBag.CustumerAttributes.password));
                Session["emailCust"] = ViewBag.CustumerAttributes.email;
                Session["nameCust"] = ViewBag.CustumerAttributes.name;


                return RedirectToAction("Home", "Home");
            }
            else
            {
                return RedirectToAction("ViewLoginCustomer", "Customer");
            }
        }


        public ActionResult Logout()
        {
            Session["emailCust"] = null;
            Session["nameCust"] = null;

            return RedirectToAction("Home", "Home");
        }
    }
}