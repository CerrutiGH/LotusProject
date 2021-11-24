using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web.Script.Serialization;

namespace LotusProject.Models.ViewModels
{
    public class Cep
    {
        public string CEP { get; set; }
        public string Address { get; set; }
        public string District { get; set; }
        public string City { get; set; }
        public string State { get; set; }

        public static Cep Search(string cep)
        {
            var cepObj = new Cep();
            var url = "https://apps.widenet.com.br/busca-cep/api/cep.json" + cep;

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.AutomaticDecompression = DecompressionMethods.GZip;

            string json = string.Empty;
            using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
            using (Stream stream = response.GetResponseStream())
            using (StreamReader reader = new StreamReader(stream))
            {
                json = reader.ReadToEnd();
            }

            JavaScriptSerializer json_serializer = new JavaScriptSerializer();
            JsonCepObject cepJson = json_serializer.Deserialize<JsonCepObject>(json);

            cepObj.CEP = cepJson.code;
            cepObj.Address = cepJson.address;
            cepObj.District = cepJson.district;
            cepObj.City = cepJson.city;
            cepObj.State = cepJson.state;
            return cepObj;

        }
    }

    internal class JsonCepObject
    {
        public string code { get; set; }
        public string state { get; set; }
        public string city { get; set; }
        public string district { get; set; }
        public string address { get; set; }
    }
}
