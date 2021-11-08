using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClassLibraryDatabaseActions.ActionsCustomer
{
    public class ActionCustomer
    {


        public Employee SignInEmployee(Employee employee)
        {
            CommandMySQL = new MySqlCommand("select * from tbEMPLOYEE where EMPLOGIN = @login and EMPPASSWORD = @password", connection.ConnectBD());
            CommandMySQL.Parameters.Add("@login", MySqlDbType.VarChar).Value = employee.login;
            CommandMySQL.Parameters.Add("@password", MySqlDbType.VarChar).Value = employee.password;

            MySqlDataReader ReaderMySQL;
            ReaderMySQL = CommandMySQL.ExecuteReader();

            if (ReaderMySQL.HasRows)
            {
                while (ReaderMySQL.Read())
                {
                    Employee emp = new Employee();
                    {
                        emp.login = Convert.ToString(ReaderMySQL["EMPLOGIN"]);
                        emp.password = Convert.ToString(ReaderMySQL["EMPPASSWORD"]);
                    }
                }
            }
            else
            {
                employee.login = null;
                employee.password = null;
            }
            return employee;
        }

    }
}
