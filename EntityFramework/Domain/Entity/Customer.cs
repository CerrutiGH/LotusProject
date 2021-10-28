using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityFramework.Domain.Entity
{
    public class Customer : Entity
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public char Sex { get; set; }
        public string Email { get; set; }
        public string password { get; set; }
        public DateTime Birthday { get; set; }
        public string Cpf { get; set; }
        public string Telephone { get; set; }

    }
}
