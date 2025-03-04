-- Sql Server strict permission
CREATE LOGIN [new_user] WITH PASSWORD = 'user_password';
USE [your_database_name];
CREATE USER [new_user] FOR LOGIN [new_user];
GRANT SELECT, INSERT, UPDATE, DELETE TO [new_user];
--Sql Server admin permission
ALTER SERVER ROLE sysadmin ADD MEMBER new_user;
-- Sql Server backup database
BACKUP DATABASE DatabaseName TO DISK = '/tmp/DatabaseName.bak'
-- Sql server restore database
RESTORE DATABASE DatabaseName FROM DISK = '/tmp/DatabaseName.bak' WITH REPLACE
-- Bash : sqlcmd -S server_name -U username -P password -Q "BACKUP DATABASE database_name TO DISK='C:\Backup\database_name.bak'"
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


-- MySQL strict permission
CREATE USER 'new_user'@'localhost' IDENTIFIED BY 'user_password';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, REFERENCES, ALTER, DROP, INDEX ON your_database_name.* TO 'new_user'@'localhost';
FLUSH PRIVILEGES;
-- Mysql admin permission
GRANT ALL PRIVILEGES ON *.* TO 'new_user'@'%' WITH GRANT OPTION;
-- MySQL backup database
-- Bash : mysqldump -u username -p database_name > backup_file.sql

-- MySQL restore database
-- Bash : mysql -u username -p database_name < backup_file.sql

-- Colation for non-symbol Vietnamese searching in MariaDB
-- utf8mb4_unicode_520_ci
--- utf8mb4_unicode_520_nopad_ci

-- Rename table MySql
START TRANSACTION;
  RENAME TABLE old_table_name TO new_table_name;
COMMIT;


-- PostgreSQL strict permission
CREATE USER username WITH PASSWORD 'password';
\c DatabaseName
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO username;
-- Postgres admin permission
CREATE ROLE new_user LOGIN PASSWORD 'password' SUPERUSER;

-- Postgres backup database
-- Bash : pg_dump -h localhost -U username -d database_name -f backup_file.sql
-- Postgres restore database
-- Bash : psql -h localhost -U username -d database_name -f backup_file.sql
-- Bash : pg_restore -h localhost -U username -f dump-file
	
-- Reaname table Postgres
BEGIN;
  ALTER TABLE old_table_name RENAME TO new_table_name;
COMMIT;

-- Delete data in all tables Postgres
DO $$ 
DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') 
    LOOP
        EXECUTE 'TRUNCATE TABLE ' || r.tablename || ' CASCADE';
    END LOOP;
END $$;

-- PostgresSQL hard reset
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
