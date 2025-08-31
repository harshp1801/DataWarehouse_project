use master;
GO

if exists (select 1 from sys.databases where name = 'datawarehouse_project')
BEGIN 
    alter database datawarehouse_project set single_user with rollback immediate;
    drop database datawarehouse_project;
END
GO

print '=============================================================================================='
create database datawarehouse_project;
GO
print 'Database Datawarehouse_project is created'
print '=============================================================================================='


use datawarehouse_project;
go

create schema Bronze;
go

create schema Silver;
go

create schema Gold;
go