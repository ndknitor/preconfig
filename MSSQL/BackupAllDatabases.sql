DECLARE @BackupPath NVARCHAR(255)
DECLARE @DatabaseName NVARCHAR(255)
DECLARE @BackupFileName NVARCHAR(255)
DECLARE @SQL NVARCHAR(MAX)

-- Set backup path
SET @BackupPath = 'C:\SQLBackups\'  -- Change this to your desired backup directory

-- Cursor to loop through all databases
DECLARE db_cursor CURSOR FOR
SELECT name 
FROM sys.databases
WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')  -- Exclude system databases

OPEN db_cursor

FETCH NEXT FROM db_cursor INTO @DatabaseName

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Construct the backup file path and name
    SET @BackupFileName = @BackupPath + @DatabaseName + '_' + REPLACE(CONVERT(VARCHAR(10), GETDATE(), 112), '-', '') + '.bak'

    -- Construct the backup SQL command
    SET @SQL = 'BACKUP DATABASE [' + @DatabaseName + '] TO DISK = ''' + @BackupFileName + ''''

    -- Execute the backup command
    EXEC sp_executesql @SQL

    -- Fetch the next database
    FETCH NEXT FROM db_cursor INTO @DatabaseName
END

-- Close and deallocate the cursor
CLOSE db_cursor
DEALLOCATE db_cursor
