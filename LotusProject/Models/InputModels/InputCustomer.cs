using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LotusProject.Models.InputModels
{
    public class InputCustomer
    {
        [Required(ErrorMessage = "O campo Nome completo é obrigatório")]
        [Display(Name = "Nome completo")]
        public string name { get; set; }

        [Required(ErrorMessage = "O campo Sexo é obrigatório")]
        [Display(Name = "Gênero")]
        public string gender { get; set; }

        [Required(ErrorMessage = "O campo Email é obrigatório")]
        [Display(Name = "Email")]
        public string email { get; set; }

        [Required(ErrorMessage = "O campo Senha é obrigatório")]
        [Display(Name = "Senha")]
        [DataType(DataType.Password)]
        public string password { get; set; }

        [Required(ErrorMessage = "O campo Confirmar senha é obrigatório")]
        [Display(Name = "Confirmar senha")]
        [DataType(DataType.Password)]
        public string ConfirmPassword { get; set; }


        [Required(ErrorMessage = "O campo Data de nascimento é obrigatório")]
        [Display(Name = "Data de nascimento")]
        [DisplayFormat(DataFormatString = "{0:dd/MM/yyyy}", ApplyFormatInEditMode = true)]
        public DateTime birthday { get; set; }


        [Required(ErrorMessage = "O campo CPF é obrigatório")]
        [Display(Name = "CPF")]
        public string cpf { get; set; }


        [Required(ErrorMessage = "O campo Telefone é obrigatório")]
        [Display(Name = "Telefone")]
        public string telephone { get; set; }

        [Required(ErrorMessage = "O campo Número da residência é obrigatório")]
        [Display(Name = "Número da residência")]
        public int numberAddress { get; set; }

        [Required(ErrorMessage = "O campo CEP é obrigatório")]
        [Display(Name = "CEP")]
        public string cep { get; set; }
    }
}
