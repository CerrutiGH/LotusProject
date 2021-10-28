using EntityFramework.Domain.Entity;
using MySql.Data.EntityFramework;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityFramework.Data
{
    [DbConfigurationType(typeof(MySqlEFConfiguration))]
    public class LotusContext : DbContext
    {
        public DbSet<Customer> Customers { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
        }

        public LotusContext() : base("MySqlConnection") { }
    }
}
