using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace LotusProject.Controllers
{
    public class EmployeeController : Controller
    {
        // GET: Employee
        public ActionResult Dashboard()
        {
            return View();
        }

        public ActionResult LogInEmployee()
        {
            return View();
        }
    }
}