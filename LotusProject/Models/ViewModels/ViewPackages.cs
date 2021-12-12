using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LotusProject.Models.ViewModels
{
    public class ViewPackages
    {
        public int PackCode { get; set; }
        public string Package { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; } 
    }
}