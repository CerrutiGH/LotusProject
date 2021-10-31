using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace LotusProject.Domain.Entity
{
    public class Products : Entity
    {
        public string Name { get; set; }
        public string BarCode { get; set; }
        public string Price { get; set; }
        public ICollection<Category> categories { get; set; }
        public Inventory Inventory { get; set; }
    }
}