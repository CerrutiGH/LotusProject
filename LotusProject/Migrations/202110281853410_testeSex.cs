namespace LotusProject.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class testeSex : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Customers", "Sex", c => c.String(maxLength: 1, fixedLength: true, unicode: false, storeType: "char"));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Customers", "Sex");
        }
    }
}
