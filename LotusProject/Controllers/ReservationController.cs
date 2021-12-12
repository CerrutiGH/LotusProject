using LotusProject.Actions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace LotusProject.Controllers
{
    public class ReservationController : Controller
    {
        ActionReserve AcReserve = new ActionReserve();
        // GET: Reservation
        public ActionResult Reservation()
        {
            ViewBag.Pack = AcReserve.PackageList();
            return View();
        }
    }
}