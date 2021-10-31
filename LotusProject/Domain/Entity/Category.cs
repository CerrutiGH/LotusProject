using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LotusProject.Domain.Entity
{
    public class Category : Entity
    {
        public string Description { get; set; }
        public ICollection<Products> Product { get; set; } /*Uma categoria pode ter vários produtos ligados a ela*/
    }
}