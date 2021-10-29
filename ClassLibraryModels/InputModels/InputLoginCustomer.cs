using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClassLibraryModels.InputModels
{
    public class InputLoginCustomer
    {
        [Required(ErrorMessage = "O campo Email é obrigatório")]
        [Display(Name = "Email")]
        public string email { get; set; }

        [Required(ErrorMessage = "O campo Senha é obrigatório")]
        [Display(Name = "Senha")]
        [DataType(DataType.Password)]
        public string password { get; set; }
    }
}
