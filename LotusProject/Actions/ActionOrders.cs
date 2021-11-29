using ClassLibraryConnection;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using LotusProject.Models;
using System.Linq;
using System.Web;

namespace LotusProject.Actions
{
    public class ActionOrders
    {
        Connection conn = new Connection();
        MySqlCommand Cmd = new MySqlCommand();

        public int OrdersDashAmount()
        {
            Cmd = new MySqlCommand("select COUNT(*) From vwAllOrders;", conn.ConnectBD());
            int CountOrder = Convert.ToInt32(Cmd.ExecuteScalar());

            conn.DisconnectBD();
            return Convert.ToInt32(CountOrder);
        }

        public decimal OrdersValueTotal()
        {
            Cmd = new MySqlCommand("select SUM(OrdTotalPrice) FROM vwAllOrders WHERE MONTH(OrdDate) = month(now());", conn.ConnectBD());
            decimal CountOrder = Convert.ToDecimal(Cmd.ExecuteScalar());

            conn.DisconnectBD();
            return Convert.ToDecimal(CountOrder);
        }

        public int MonthOrders(int month)
        {
            Cmd = new MySqlCommand($"select COUNT(*) From vwAllOrders WHERE MONTH(OrdDate) = {month} AND YEAR(OrdDate) = YEAR(now());", conn.ConnectBD());
            int months = (int)Convert.ToInt32(Cmd.ExecuteScalar());
            conn.DisconnectBD();
            return months;
        }
    }
}