using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClassLibraryConnection
{
    public class Connection
    {

        MySqlConnection connect = new MySqlConnection(ConfigurationManager.ConnectionStrings["MySqlAzure"].ConnectionString);

        public static string msg;
        public MySqlConnection ConnectBD()
        {
            try
            {
                connect.Open();
            }
            catch (Exception error)
            {
                msg = "Erro ao conectar o Banco de Dados" + error.Message;
            }
            return connect;
        }

        public MySqlConnection DisconnectBD()
        {
            try
            {
                connect.Close();
            }
            catch (Exception error)
            {
                msg = "Não foi possível desconectar o Banco de Dados" + error.Message;
            }
            return connect;
        }
    }
}
