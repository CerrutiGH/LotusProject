using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace LotusProject.Models.ViewModels
{
    public class ViewEmployee
    {
        [Display(Name = "Nome Completo")]
        public string name { get; set; }

        [Display(Name = "Login")]
        public string login { get; set; }


        [Display(Name = "Sexo")]
        public char sex { get; set; }

        [Display(Name = "CPF")]
        public string cpf { get; set; }


        [Display(Name = "Data de nascimento")]
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime birthday { get; set; }

        [Display(Name = "Telefone")]
        public string telephone { get; set; }

        [Display(Name = "Cep")]
        public string cep { get; set; }

        [Display(Name = "Número da residência")]
        public int number { get; set; }

        [Display(Name = "Email")]
        public string email { get; set; }

        [Display(Name = "Senha")]
        [DataType(DataType.Password)]
        public string password { get; set; }

        [Display(Name = "Confirmar senha")]
        [DataType(DataType.Password)]
        public string confirmPassword { get; set; }

        [Display(Name = "Acesso")]
        public string role { get; set; }
    }
}