using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LotusProject.Domain.Entity
{
    public class Customer : Entity
    {
        public int Id { get; set; }
        public string Name { get; set; }
        [StringLength(1)]
        [Column(TypeName = "char")]
        public string Sex { get; set; }
        public string Email { get; set; }
        public string password { get; set; }
        public DateTime Birthday { get; set; }
        public string Cpf { get; set; }
        public string Telephone { get; set; }

    }
}
