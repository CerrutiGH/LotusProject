using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using LotusProject.Actions;
using LotusProject.Models;
using LotusProject.Models.InputModels;

namespace LotusProject.Controllers
{
    public class EmployeeController : Controller
    {

        ActionEmployee AcEmployee = new ActionEmployee();
        ActionReserve AcReserve = new ActionReserve();
        
        // GET: Employee
        public ActionResult Dashboard()
        {
            if(Session["loginEmp"] == null)
            {
                return RedirectToAction("LogInEmployee", "Employee");
            }
            else
            {
                var login = Session["loginEmp"].ToString();
                ViewBag.ListEmployee = AcEmployee.EmployeeDashLimited();
                ViewBag.Reserve = AcReserve.ReserveDashLimited();
                ViewBag.employee = AcEmployee.DataEmployee(login);
                return View();
            }
            
        }

        public ActionResult LogInEmployee()
        {
            return View();
        }

        [HttpPost]
        public ActionResult SignInEmp(InputLoginEmployee Employee)
        {
            if (!ModelState.IsValid)
            {
                return RedirectToAction("LogInEmployee", "Employee", Employee);
            }
            var Emp = AcEmployee.SignIn(Employee.login, Employee.password);
            if (Emp.login != null && Emp.password != null)
            {
                FormsAuthentication.Encrypt(new FormsAuthenticationTicket(1, Emp.login, DateTime.Now, DateTime.Now.AddHours(12), true, Emp.password));
                Session["loginEmp"] = Emp.login.ToString();
                return RedirectToAction("Dashboard","Employee");
            }
            else
            {
                return RedirectToAction("LogInEmployee", "Employee" );
            }
        }

        public ActionResult Logout()
        {
            Session["loginEmp"] = null;
            return RedirectToAction("LogInEmployee", "Employee");
        }

        public ActionResult EmployeeCenter()
        {
            if (Session["loginEmp"] == null)
            {
                return RedirectToAction("LogInEmployee", "Employee");
            }
            else
            {
            return View();
            }
        }

    }
}