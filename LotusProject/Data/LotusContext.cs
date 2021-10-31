﻿using LotusProject.Domain.Entity;
using MySql.Data.EntityFramework;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LotusProject.Data
{
    [DbConfigurationType(typeof(MySqlEFConfiguration))]
    public class LotusContext : DbContext
    {
        public DbSet<Customer> Customers { get; set; }
        public DbSet<Employee> employees { get; set; }
        public DbSet<Products> Products { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<Inventory> Inventories { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
        }

        public LotusContext() : base("MySqlConnection") { }
    }
}
