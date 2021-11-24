using ClassLibraryConnection;
using MySql.Data.MySqlClient;
using System;
using LotusProject.Models.ViewModels;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LotusProject.Actions
{
    public class ActionReserve
    {
        Connection conn = new Connection();
        MySqlCommand Cmd = new MySqlCommand();

        public int ReserveDashAmount()
        {
            Cmd = new MySqlCommand("SELECT COUNT(*) FROM vwAllReserves;", conn.ConnectBD());
            int CountRes = Convert.ToInt32(Cmd.ExecuteScalar());

            conn.DisconnectBD();
            return Convert.ToInt32(CountRes);
        }



        public List<ViewReserve> ListReserves(MySqlDataReader dt)
        {
            var ListRes = new List<ViewReserve>();
            while (dt.Read())
            {
                var reserve = new ViewReserve()
                {
                    custcpf = dt["CustCPF"].ToString(),
                    custname = dt["CustName"].ToString(),
                    resamount = Convert.ToInt32(dt["ResAmount"]),
                    resprice = Convert.ToDecimal(dt["ResPrice"]),
                    resvalidity = Convert.ToDateTime(dt["ResValidity"]),
                    statusreserve = Convert.ToString(dt["StatusReserve"])
                };
                ListRes.Add(reserve);
            }
            dt.Close();
            return ListRes;
        }

        public List<ViewReserve> ReserveDashLimited()
        {
            Cmd = new MySqlCommand("SELECT * FROM vwAllReserves LIMIT 5;", conn.ConnectBD());
            var ListRes = Cmd.ExecuteReader();
            
            return ListReserves(ListRes);
        }
    }
}