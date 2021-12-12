using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClassLibraryConnection;
using LotusProject.Models.InputModels;
using LotusProject.Models;

namespace ClassLibraryDatabaseActions.ActionsCustomer
{


    public class ActionCustomer
    {
        Connection conn = new Connection();
        MySqlCommand Cmd = new MySqlCommand();


        public string SelectEmail(string varEMail)
        {

            Cmd = new MySqlCommand("CALL spSelectEmail(@Email);", conn.ConnectBD());
            Cmd.Parameters.Add("@Email", MySqlDbType.VarChar).Value = varEMail;
            string Email = (string)Cmd.ExecuteScalar();

            if (Email == null)
            {
                Email = "";
            }
            return Email;
        }


        public Customer SignIn(string email, string pass)
        {
            Cmd = new MySqlCommand("CALL spLoginUser(@Email, @Password);", conn.ConnectBD());
            Cmd.Parameters.Add("@Email", MySqlDbType.VarChar).Value = email;
            Cmd.Parameters.Add("@Password", MySqlDbType.VarChar).Value = pass;

           var dtr = Cmd.ExecuteReader();
           var TempCust = new Customer();

            if (dtr.Read())
            {
                TempCust.email = Convert.ToString(dtr["CustEmail"]);
                TempCust.password = Convert.ToString(dtr["CustPassword"]);
                TempCust.name = Convert.ToString(dtr["CustName"]);
                TempCust.cpf = Convert.ToString(dtr["CustCPF"]);
            }
            dtr.Close();
            conn.DisconnectBD();
            return TempCust;


        }
    }
}
