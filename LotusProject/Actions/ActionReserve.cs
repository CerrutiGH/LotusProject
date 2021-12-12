using ClassLibraryConnection;
using MySql.Data.MySqlClient;
using System;
using LotusProject.Models.ViewModels;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using LotusProject.Models.InputModels;

namespace LotusProject.Actions
{
    public class ActionReserve
    {
        Connection conn = new Connection();
        MySqlCommand Cmd = new MySqlCommand();

        public int ReserveDashAmount()
        {
            Cmd = new MySqlCommand("SELECT COUNT(*) FROM vwAllReserves WHERE MONTH(ResValidity) = MONTH(NOW());", conn.ConnectBD());
            try
            {
            int CountRes = Convert.ToInt32(Cmd.ExecuteScalar());
            return Convert.ToInt32(CountRes);
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
                    resvalidity = (dt["DATE_FORMAT(ResValidity,'%d/%m/%y')"]).ToString(),
                    statusreserve = Convert.ToString(dt["StatusReserve"])
                };
                ListRes.Add(reserve);
            }
            dt.Close();
            return ListRes;
        }

        public List<ViewReserve> ReserveDashLimited()
        {
            Cmd = new MySqlCommand("SELECT CustCPF, CustName, ResAmount, ResPrice, DATE_FORMAT(ResValidity,'%d/%m/%y'), StatusReserve, ResCode FROM vwAllReserves LIMIT 5;", conn.ConnectBD());
            var ListRes = Cmd.ExecuteReader();
            
            return ListReserves(ListRes);
        }



        public List<ViewPackages> ListPackages(MySqlDataReader dt)
        {
            var ListPac = new List<ViewPackages>();
            while (dt.Read())
            {
                var pack = new ViewPackages()
                {
                    PackCode = Convert.ToInt32(dt["PackCode"]),
                    Package = dt["PackName"].ToString(),
                    Description = dt["PackDescription"].ToString(),
                    Price = Convert.ToDecimal(dt["PackPrice"])
                };
                ListPac.Add(pack);
            }
            dt.Close();
            return ListPac;
        }

        public List<ViewPackages> PackageList()
        {
            Cmd = new MySqlCommand("SELECT * FROM tbPackage;", conn.ConnectBD());
            var ListPac = Cmd.ExecuteReader();

            return ListPackages(ListPac);
        }

        public void InsertReserve(int codePack, string cpfCustomer)
        {
            Cmd = new MySqlCommand($"CALL spReserve(1, '{cpfCustomer}', {codePack});", conn.ConnectBD());

            Cmd.ExecuteNonQuery();
            conn.DisconnectBD();
        }

        public void FinishReserve(string cpfCustomer)
        {
            Cmd = new MySqlCommand($"CALL spFinishReserve('Crédito', '{cpfCustomer}')", conn.ConnectBD());

            Cmd.ExecuteNonQuery();
            conn.DisconnectBD();
        }


    }
}