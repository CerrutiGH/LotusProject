using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClassLibraryModels.InputModels;
using LotusProject.Data;
using LotusProject.Domain.Entity;

namespace LotusProject.Actions
{
    public class CustomerAct
    {

        public static void InsertCust(InputCustomer customer)
        {
            using (var context = new LotusContext())
            {
                context.Customers.Add(new Customer()
                {
                    Name = customer.name,
                    Sex = customer.sex,
                    Email = customer.email,
                    password = customer.password,
                    Birthday = customer.birthday,
                    Cpf = customer.cpf,
                    Telephone = customer.telephone
                });
                context.SaveChanges();
            }
        }
    }
}
