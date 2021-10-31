using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LotusProject.Domain.Entity
{
    public class Cart
    {
        public Guid ProductID { get; set; }
        public string NameProduct { get; set; }
        public int Amount { get; set; }
        public decimal UnityPrice { get; set; }
    }

   
}