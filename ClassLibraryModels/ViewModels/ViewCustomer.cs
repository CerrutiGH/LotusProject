using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClassLibraryModels.ViewModels
{
    public class ViewCustomer
    {
        public int code { get; set; }
        public string name { get; set; }
        public string sex { get; set; }
        public string email { get; set; }
        public string password { get; set; }
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime birthday { get; set; }
        public string cpf { get; set; }
        public string telephone { get; set; }
    }
}
