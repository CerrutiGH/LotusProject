namespace LotusProject.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class alterproduct : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Products", "Description", c => c.String(unicode: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Products", "Description");
        }
    }
}
