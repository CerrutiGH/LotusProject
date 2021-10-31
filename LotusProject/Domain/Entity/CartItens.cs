using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LotusProject.Domain.Entity
{
    public class CartItens
    {
        private List<Cart> _Itens = new List<Cart>();
        public List<Cart> Itens { get { return _Itens; } }
        public decimal ValorTotal { get { return _Itens.Sum(p => p.UnityPrice); } }

        public void AdicionarItem(Guid prodId, string name, decimal price)
        {
            _Itens.Add(new Cart { ProductID = prodId, NameProduct = name, UnityPrice = price });
        }
        public void Limpar()
        {
            _Itens.Clear();
        }
        public void RemoverItem(int index)
        {
            _Itens.RemoveAt(index);
        }
    }
}