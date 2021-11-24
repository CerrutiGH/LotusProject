using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace LotusProject.Controllers
{
    public class StoreController : Controller
    {
        // GET: Store        
        public ActionResult MainStore()
        {
            return View();
        }
         
        public ActionResult ViewProduct()
        {
            return View();
        }
    }
}