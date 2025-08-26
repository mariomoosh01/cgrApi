-- Create CgrDatabase
-- This script creates the main database for the CGR (Climbing Gym Registry) system

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'CgrDatabase')
BEGIN
    CREATE DATABASE [CgrDatabase]
    COLLATE SQL_Latin1_General_CP1_CI_AS;
END
GO

USE [CgrDatabase]
GO

-- Enable specific features if needed
IF NOT EXISTS (SELECT * FROM sys.configurations WHERE name = 'clr enabled')
BEGIN
    EXEC sp_configure 'clr enabled', 1;
    RECONFIGURE;
END
GO

PRINT 'CgrDatabase created successfully'