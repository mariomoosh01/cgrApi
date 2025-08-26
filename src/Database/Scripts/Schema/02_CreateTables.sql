-- Create all tables for CGR system
-- Execute after database creation

USE [CgrDatabase]
GO

-- Create ManagerProfiles table
CREATE TABLE [dbo].[ManagerProfiles] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    [FirstName] NVARCHAR(100) NOT NULL,
    [LastName] NVARCHAR(100) NOT NULL,
    [Email] NVARCHAR(255) NOT NULL UNIQUE,
    [PasswordHash] NVARCHAR(255) NOT NULL,
    [PhoneNumber] NVARCHAR(20) NULL,
    
    -- Email verification
    [EmailVerified] BIT NOT NULL DEFAULT 0,
    [EmailVerificationToken] NVARCHAR(255) NULL,
    [EmailVerificationTokenExpires] DATETIME2 NULL,
    
    -- Password reset
    [PasswordResetToken] NVARCHAR(255) NULL,
    [PasswordResetTokenExpires] DATETIME2 NULL,
    
    -- Account status
    [IsActive] BIT NOT NULL DEFAULT 1,
    [LastLoginAt] DATETIME2 NULL,
    
    -- Base entity fields
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [CreatedBy] NVARCHAR(255) NULL,
    [UpdatedBy] NVARCHAR(255) NULL,
    [IsDeleted] BIT NOT NULL DEFAULT 0
);
GO

-- Create GymChains table
CREATE TABLE [dbo].[GymChains] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    [BusinessName] NVARCHAR(200) NOT NULL,
    [BusinessDescription] NVARCHAR(1000) NULL,
    [BusinessLicense] NVARCHAR(100) NULL,
    [TaxId] NVARCHAR(50) NULL,
    
    -- Business contact information
    [BusinessEmail] NVARCHAR(255) NOT NULL,
    [BusinessPhone] NVARCHAR(20) NULL,
    [Website] NVARCHAR(255) NULL,
    
    -- Business address (headquarters)
    [HeadquartersAddress] NVARCHAR(500) NULL,
    [City] NVARCHAR(100) NULL,
    [State] NVARCHAR(100) NULL,
    [ZipCode] NVARCHAR(20) NULL,
    [Country] NVARCHAR(100) NULL DEFAULT 'USA',
    
    [IsActive] BIT NOT NULL DEFAULT 1,
    [EstablishedDate] DATETIME2 NULL,
    
    -- Foreign key
    [ManagerProfileId] UNIQUEIDENTIFIER NOT NULL,
    
    -- Base entity fields
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [CreatedBy] NVARCHAR(255) NULL,
    [UpdatedBy] NVARCHAR(255) NULL,
    [IsDeleted] BIT NOT NULL DEFAULT 0,
    
    CONSTRAINT [FK_GymChains_ManagerProfileId] FOREIGN KEY ([ManagerProfileId]) 
        REFERENCES [dbo].[ManagerProfiles] ([Id]) ON DELETE CASCADE
);
GO

-- Create GymFacilities table
CREATE TABLE [dbo].[GymFacilities] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    [Name] NVARCHAR(200) NOT NULL,
    [Description] NVARCHAR(1000) NULL,
    [Address] NVARCHAR(500) NOT NULL,
    [City] NVARCHAR(100) NOT NULL,
    [State] NVARCHAR(100) NOT NULL,
    [ZipCode] NVARCHAR(20) NOT NULL,
    [Country] NVARCHAR(100) NULL DEFAULT 'USA',
    
    -- Contact information
    [PhoneNumber] NVARCHAR(20) NULL,
    [Email] NVARCHAR(255) NULL,
    
    -- Operating hours
    [OperatingHours] NVARCHAR(500) NULL,
    
    -- Facility details
    [SquareFootage] DECIMAL(10,2) NULL,
    [MaxCapacity] INT NULL,
    [IsActive] BIT NOT NULL DEFAULT 1,
    [OpeningDate] DATETIME2 NULL,
    
    -- Foreign key
    [GymChainId] UNIQUEIDENTIFIER NOT NULL,
    
    -- Base entity fields
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [CreatedBy] NVARCHAR(255) NULL,
    [UpdatedBy] NVARCHAR(255) NULL,
    [IsDeleted] BIT NOT NULL DEFAULT 0,
    
    CONSTRAINT [FK_GymFacilities_GymChainId] FOREIGN KEY ([GymChainId]) 
        REFERENCES [dbo].[GymChains] ([Id]) ON DELETE CASCADE
);
GO

-- Create Employees table
CREATE TABLE [dbo].[Employees] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    [FirstName] NVARCHAR(100) NOT NULL,
    [LastName] NVARCHAR(100) NOT NULL,
    [Email] NVARCHAR(255) NOT NULL,
    [PhoneNumber] NVARCHAR(20) NULL,
    
    -- Employment details
    [Position] NVARCHAR(100) NOT NULL,
    [Department] NVARCHAR(100) NULL,
    [HourlyRate] DECIMAL(10,2) NULL,
    [Salary] DECIMAL(12,2) NULL,
    [HireDate] DATETIME2 NOT NULL,
    [TerminationDate] DATETIME2 NULL,
    
    -- Status
    [IsActive] BIT NOT NULL DEFAULT 1,
    [Notes] NVARCHAR(1000) NULL,
    
    -- Foreign keys
    [GymChainId] UNIQUEIDENTIFIER NOT NULL,
    [GymFacilityId] UNIQUEIDENTIFIER NULL, -- Nullable if employee works at chain level
    
    -- Base entity fields
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [CreatedBy] NVARCHAR(255) NULL,
    [UpdatedBy] NVARCHAR(255) NULL,
    [IsDeleted] BIT NOT NULL DEFAULT 0,
    
    CONSTRAINT [FK_Employees_GymChainId] FOREIGN KEY ([GymChainId]) 
        REFERENCES [dbo].[GymChains] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Employees_GymFacilityId] FOREIGN KEY ([GymFacilityId]) 
        REFERENCES [dbo].[GymFacilities] ([Id])
);
GO

-- Create Amenities table
CREATE TABLE [dbo].[Amenities] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    [Name] NVARCHAR(200) NOT NULL,
    [Description] NVARCHAR(1000) NULL,
    [Category] NVARCHAR(100) NOT NULL, -- e.g., "Equipment", "Service", "Facility"
    [IsAvailable] BIT NOT NULL DEFAULT 1,
    [Cost] DECIMAL(10,2) NULL, -- Cost to maintain/provide this amenity
    [MaintenanceSchedule] NVARCHAR(500) NULL,
    
    -- Foreign key
    [GymFacilityId] UNIQUEIDENTIFIER NOT NULL,
    
    -- Base entity fields
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [CreatedBy] NVARCHAR(255) NULL,
    [UpdatedBy] NVARCHAR(255) NULL,
    [IsDeleted] BIT NOT NULL DEFAULT 0,
    
    CONSTRAINT [FK_Amenities_GymFacilityId] FOREIGN KEY ([GymFacilityId]) 
        REFERENCES [dbo].[GymFacilities] ([Id]) ON DELETE CASCADE
);
GO

-- Create indexes for better performance
CREATE NONCLUSTERED INDEX [IX_ManagerProfiles_Email] ON [dbo].[ManagerProfiles] ([Email]);
CREATE NONCLUSTERED INDEX [IX_GymChains_ManagerProfileId] ON [dbo].[GymChains] ([ManagerProfileId]);
CREATE NONCLUSTERED INDEX [IX_GymFacilities_GymChainId] ON [dbo].[GymFacilities] ([GymChainId]);
CREATE NONCLUSTERED INDEX [IX_Employees_GymChainId] ON [dbo].[Employees] ([GymChainId]);
CREATE NONCLUSTERED INDEX [IX_Employees_GymFacilityId] ON [dbo].[Employees] ([GymFacilityId]);
CREATE NONCLUSTERED INDEX [IX_Amenities_GymFacilityId] ON [dbo].[Amenities] ([GymFacilityId]);

PRINT 'All tables created successfully with indexes'