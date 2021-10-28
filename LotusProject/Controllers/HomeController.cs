using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using LotusProject.Actions;
using ClassLibraryModels.InputModels;
namespace LotusProject.Controllers
{
    public class HomeController : Controller
    {
        

        // GET: Home
        public ActionResult Home()
        {
            return View();
        }

        [HttpPost]
        public ActionResult InsertCustomer(InputCustomer customer)
        {

            CustomerAct.InsertCust(customer);
            return View();
        }
    }
}