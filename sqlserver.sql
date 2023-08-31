-- Step 1: Create a Login (if necessary)
CREATE LOGIN YourLoginName
WITH PASSWORD = 'YourPassword';

-- Step 2: Create a User in a specific database
USE YourDatabaseName;
CREATE USER YourUserName FOR LOGIN YourLoginName;

-- Step 3: Grant Permissions
-- Example: Grant SELECT, INSERT, UPDATE, DELETE permissions on a table
GRANT SELECT, INSERT, UPDATE, DELETE ON YourTableName TO YourUserName;

-- Example: Grant EXECUTE permission on a stored procedure
GRANT EXECUTE ON YourStoredProcedureName TO YourUserName;
