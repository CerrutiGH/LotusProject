namespace LotusProject.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addEmployee : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Employees",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        name = c.String(unicode: false),
                        login = c.String(unicode: false),
                        sex = c.String(maxLength: 1, fixedLength: true, unicode: false, storeType: "char"),
                        cpf = c.String(unicode: false),
                        rg = c.String(unicode: false),
                        birthday = c.DateTime(nullable: false, precision: 0),
                        telephone = c.String(unicode: false),
                        address = c.String(unicode: false),
                        email = c.String(unicode: false),
                        password = c.String(unicode: false),
                        role = c.String(unicode: false),
                        IsDeleted = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => t.Id);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Employees");
        }
    }
}
