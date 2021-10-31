using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LotusProject.Domain.Entity
{
    public class Inventory : Entity
    {
        public Products Products { get; set; }
        public Guid ProductId { get; set; }
        public Qualitative InfoPurchase { get; set; }
    }
}