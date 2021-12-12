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
            Cmd = new MySqlCommand("select COUNT(*) From vwAllOrders WHERE MONTH(OrdDate) = month(now());", conn.ConnectBD());
            try
            {
                int CountOrder = Convert.ToInt32(Cmd.ExecuteScalar());
                return Convert.ToInt32(CountOrder);
            }
            catch
            {
                return 0;
            }
            finally
            {
                conn.DisconnectBD();
            }
        }

        public decimal OrdersValueTotal()
        {
            Cmd = new MySqlCommand("select SUM(Ord TotalPrice) FROM vwAllOrders WHERE MONTH(OrdDate) = month(now());", conn.ConnectBD());
            try
            {
                decimal CountOrder = Convert.ToDecimal(Cmd.ExecuteScalar());
                return Convert.ToDecimal(CountOrder);
            }
            catch
            {
                
                return 0;
            }
            finally
            {
                conn.DisconnectBD();
            }
           
          
            
           
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