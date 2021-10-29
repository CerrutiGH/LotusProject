using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using LotusProject.Actions;
using ClassLibraryModels.InputModels;
using ClassLibraryModels.ViewModels;
using LotusProject.Data;
using LotusProject.Domain.Entity;
using System.Web.Security;

namespace LotusProject.Controllers
{
    public class HomeController : Controller
    {
        CustomerAct custact = new CustomerAct();
        // GET: Home
        public ActionResult Home()
        {
            return View();
        }

        public ActionResult About()
        {
            return View();
        }

        [HttpPost]
        public ActionResult InsertCustomer(InputCustomer customer)
        {

            CustomerAct.InsertCust(customer);
            return View();
        }
        
        [HttpPost]
        public ActionResult SignIn(InputLoginCustomer customer)
        {
            //var Sign = custact.SignIn(customer);
            LotusContext db = new LotusContext();
            var login = db.Customers.Where(x => x.Email.Equals(customer.email) && x.password.Equals(customer.password)).FirstOrDefault();
            if(login != null)
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
        //[HttpGet]
        //public ActionResult GetCustomers()
        //{

        //}
    }
}