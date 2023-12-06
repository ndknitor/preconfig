-- Sql Server strict permission
CREATE LOGIN [new_user] WITH PASSWORD = 'user_password';
USE [your_database_name];
CREATE USER [new_user] FOR LOGIN [new_user];
GRANT SELECT, INSERT, UPDATE, DELETE TO [new_user];

-- MySQL strict permission
CREATE USER 'new_user'@'localhost' IDENTIFIED BY 'user_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON your_database_name.* TO 'new_user'@'localhost';
FLUSH PRIVILEGES;

-- Colation for non-symbol Vietnamese searching in MariaDB
-- utf8mb4_unicode_520_ci
--- utf8mb4_unicode_520_nopad_ci

-- Colation for non-symbol Vietnamese searching in Sql Server
create table Product
(
	ProductId int identity primary key,
	[Name] nvarchar(128) not null default '' COLLATE SQL_Latin1_General_CP1_CI_AI
)
select * from Product where [Name] like '%me%'  COLLATE  SQL_Latin1_General_CP1_CI_AI

-- Rename table Sql Server
BEGIN TRANSACTION;
	EXEC sp_rename 'OldTableName', 'NewTableName';
COMMIT;

-- Rename table MySql
START TRANSACTION;
  RENAME TABLE old_table_name TO new_table_name;
COMMIT;

-- Reaname table Postgres
BEGIN;
  ALTER TABLE old_table_name RENAME TO new_table_name;
COMMIT;

