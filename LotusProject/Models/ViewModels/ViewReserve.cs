using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LotusProject.Models.ViewModels
{
    public class ViewReserve
    {
        public string custcpf { get; set; }
        public string custname { get; set; }
        public int resamount { get; set; }
        public decimal resprice { get; set; }
        public DateTime resvalidity { get; set; }
        public string statusreserve { get; set; }
    }
}