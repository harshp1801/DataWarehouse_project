use datawarehouse_project;

GO

Exec Bronze.load_bronze_schema;

GO

Exec Silver.load_silver_schema;
