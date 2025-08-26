-- Master deployment script for CGR Database
-- Execute this script to deploy the complete database

PRINT 'Starting CGR Database deployment...'
PRINT 'Timestamp: ' + CONVERT(VARCHAR, GETDATE(), 121)
GO

-- Step 1: Create Database
PRINT 'Step 1: Creating database...'
:r .\Schema\01_CreateDatabase.sql
GO

-- Step 2: Create Tables
PRINT 'Step 2: Creating tables and indexes...'
:r .\Schema\02_CreateTables.sql
GO

-- Step 3: Create Stored Procedures
PRINT 'Step 3: Creating stored procedures...'
:r .\StoredProcedures\ManagerProfile_CRUD.sql
GO

-- Step 4: Seed Initial Data
PRINT 'Step 4: Seeding initial data...'
:r .\SeedData\01_SeedInitialData.sql
GO

PRINT 'CGR Database deployment completed successfully!'
PRINT 'Completion timestamp: ' + CONVERT(VARCHAR, GETDATE(), 121)
GO