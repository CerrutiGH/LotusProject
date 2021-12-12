using LotusProject.Actions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace LotusProject.Controllers
{
    public class PaymentController : Controller
    {
        ActionReserve AcReserve = new ActionReserve();
        // GET: Payment
        public ActionResult Payment()
        {
            //if(Session["emailCust"] == null)
           // {
              //  return RedirectToAction("ViewLoginCustomer", "Customer");
            //}
           // else
           // {
                return View();
           // }
            
           
        }


        public ActionResult FinishPaymentReserve(int id)
        {
            string cpfCustomer = Session["cpgCust"].ToString();
            id = Convert.ToInt32(Request.Url.Segments.Last());
            try
            {
                AcReserve.InsertReserve(id, cpfCustomer);
            }
            catch
            {
                return RedirectToAction("Home");
            }
            finally
            {
                AcReserve.FinishReserve(cpfCustomer);
            }

            return RedirectToAction("Home", "Home");
        }
    }
}