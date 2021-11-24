using ClassLibraryConnection;
using MySql.Data.MySqlClient;
using LotusProject.Models;
using LotusProject.Models.InputModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using LotusProject.Models.ViewModels;

namespace LotusProject.Actions
{
    public class ActionEmployee
    {

        Connection conn = new Connection();
        MySqlCommand Cmd = new MySqlCommand();


        public List<ViewEmployee> ListEmployee(MySqlDataReader dt)
        {
            var ListEmp = new List<ViewEmployee>();
            while (dt.Read())
            {
                var employee = new ViewEmployee()
                {
                    cpf = dt["EmpCPF"].ToString(),
                    name = dt["EmpName"].ToString(),
                    login = dt["EmpLogin"].ToString(),
                    birthday = Convert.ToDateTime(dt["EmpDtNasc"]),
                    telephone = dt["EmpTel"].ToString(),
                    email = dt["EmpEmail"].ToString(),
                    address = dt["CEPAddress"].ToString(),
                    role = dt["RoleName"].ToString()
                };
                ListEmp.Add(employee);
            }
            dt.Close();
            return ListEmp;
        }

        public List<ViewEmployee> EmployeeDashLimited()
        {
            Cmd = new MySqlCommand("SELECT * FROM vwDataEmployee LIMIT 8;", conn.ConnectBD());
            var ListEmp = Cmd.ExecuteReader();

            return ListEmployee(ListEmp);
        }


        public Employee SignIn(string login, string pass)
        {
            Cmd = new MySqlCommand("CALL spLoginEmployee(@Login, @Password);", conn.ConnectBD());
            Cmd.Parameters.Add("@Login", MySqlDbType.VarChar).Value = login;
            Cmd.Parameters.Add("@Password", MySqlDbType.VarChar).Value = pass;

            var dtr = Cmd.ExecuteReader();
            var TempCust = new Employee(); // Passar para uma ViewModel

            if (dtr.Read())
            {
                TempCust.login = Convert.ToString(dtr["EmpLogin"]);
                TempCust.password = Convert.ToString(dtr["EmpPassword"]);
                TempCust.name = Convert.ToString(dtr["EmpName"]);
            }
            dtr.Close();
            conn.DisconnectBD();
            return TempCust;


        }

        public Employee DataEmployee(string login)
        {
            Cmd = new MySqlCommand("CALL spSelectEmployeeData(@Login);", conn.ConnectBD());
            Cmd.Parameters.Add("@Login", MySqlDbType.VarChar).Value = login;

            var dtr = Cmd.ExecuteReader();
            var TempCust = new Employee(); // Passar para uma ViewModel

            if (dtr.Read())
            {
                TempCust.login = Convert.ToString(dtr["EmpLogin"]);
                TempCust.name = Convert.ToString(dtr["EmpName"]);
                TempCust.cpf = Convert.ToString(dtr["EmpCPF"]);
                TempCust.role = Convert.ToString(dtr["RoleName"]);
            }
            dtr.Close();
            conn.DisconnectBD();
            return TempCust;


        }
    }
}