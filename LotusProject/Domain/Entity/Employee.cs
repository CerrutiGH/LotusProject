using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace LotusProject.Domain.Entity
{
    public class Employee : Entity
    {
        public int Id { get; set; }
        public string name { get; set; }
        public string login { get; set; }
        [StringLength(1)]
        [Column(TypeName = "char")]
        public string sex { get; set; }
        public string cpf { get; set; }
        public string rg { get; set; }
        public DateTime birthday { get; set; }
        public string address { get; set; }
        public string email { get; set; }
        public string password { get; set; }
        public string role { get; set; }
    }
}