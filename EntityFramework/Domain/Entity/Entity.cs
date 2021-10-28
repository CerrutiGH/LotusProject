using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EntityFramework.Domain.Entity
{
    public abstract class Entity
    {
        public Guid Id { get; set; }

        public bool IsDeleted { get; private set; }

        public void Deletar() => IsDeleted = true;
    }
}
