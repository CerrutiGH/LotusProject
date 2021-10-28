namespace LotusProject.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class TableCostumer : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Customers",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Name = c.String(unicode: false),
                        Email = c.String(unicode: false),
                        password = c.String(unicode: false),
                        Birthday = c.DateTime(nullable: false, precision: 0),
                        Cpf = c.String(unicode: false),
                        Telephone = c.String(unicode: false),
                        IsDeleted = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => t.Id);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Customers");
        }
    }
}
