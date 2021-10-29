using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LotusProject.Domain.Entity
{
    public class Products : Entity
    {
        public string Name { get; set; }
        public string BarCode { get; set; }
        public string Description { get; set; }
    }
}