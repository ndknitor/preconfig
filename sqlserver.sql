CREATE LOGIN YourLoginName
WITH PASSWORD = 'YourPassword';
USE YourDatabaseName;
CREATE USER YourUserName FOR LOGIN YourLoginName;
GRANT SELECT, INSERT, UPDATE, DELETE ON YourTableName TO YourUserName;

-- Colation for non-symbol Vietnamese searching in Sql Server
create table Product
(
	ProductId int identity primary key,
	[Name] nvarchar(128) not null default '' COLLATE SQL_Latin1_General_CP1_CI_AI
)
select * from Product where [Name] like '%me%'  COLLATE  SQL_Latin1_General_CP1_CI_AI



-- Colation for non-symbol Vietnamese searching in MariaDn
-- utf8mb4_unicode_520_ci
--- utf8mb4_unicode_520_nopad_ci
