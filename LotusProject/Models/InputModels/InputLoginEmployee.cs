using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace LotusProject.Models.InputModels
{
    public class InputLoginEmployee
    {
        [Required(ErrorMessage = "O campo Login é obrigatório")]
        [Display(Name = "Login")]
        public string login { get; set; }

        [Required(ErrorMessage = "O campo Senha é obrigatório")]
        [Display(Name = "Senha")]
        [DataType(DataType.Password)]
        public string password { get; set; }
    }
}