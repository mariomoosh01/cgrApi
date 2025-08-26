-- Stored Procedures for ManagerProfile CQRS operations

USE [CgrDatabase]
GO

-- CREATE ManagerProfile
CREATE OR ALTER PROCEDURE [dbo].[sp_CreateManagerProfile]
    @Id UNIQUEIDENTIFIER,
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Email NVARCHAR(255),
    @PasswordHash NVARCHAR(255),
    @PhoneNumber NVARCHAR(20) = NULL,
    @CreatedBy NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO [dbo].[ManagerProfiles] (
        [Id], [FirstName], [LastName], [Email], [PasswordHash], 
        [PhoneNumber], [CreatedBy]
    )
    VALUES (
        @Id, @FirstName, @LastName, @Email, @PasswordHash,
        @PhoneNumber, @CreatedBy
    );
    
    SELECT @Id as CreatedId;
END
GO

-- GET ManagerProfile by Id
CREATE OR ALTER PROCEDURE [dbo].[sp_GetManagerProfileById]
    @Id UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT * FROM [dbo].[ManagerProfiles] 
    WHERE [Id] = @Id AND [IsDeleted] = 0;
END
GO

-- GET ManagerProfile by Email
CREATE OR ALTER PROCEDURE [dbo].[sp_GetManagerProfileByEmail]
    @Email NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT * FROM [dbo].[ManagerProfiles] 
    WHERE [Email] = @Email AND [IsDeleted] = 0;
END
GO

-- UPDATE ManagerProfile
CREATE OR ALTER PROCEDURE [dbo].[sp_UpdateManagerProfile]
    @Id UNIQUEIDENTIFIER,
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @PhoneNumber NVARCHAR(20) = NULL,
    @UpdatedBy NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE [dbo].[ManagerProfiles]
    SET 
        [FirstName] = @FirstName,
        [LastName] = @LastName,
        [PhoneNumber] = @PhoneNumber,
        [UpdatedBy] = @UpdatedBy,
        [UpdatedAt] = GETUTCDATE()
    WHERE [Id] = @Id AND [IsDeleted] = 0;
    
    SELECT @@ROWCOUNT as UpdatedRows;
END
GO

-- VERIFY Email
CREATE OR ALTER PROCEDURE [dbo].[sp_VerifyManagerEmail]
    @Id UNIQUEIDENTIFIER,
    @EmailVerificationToken NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE [dbo].[ManagerProfiles]
    SET 
        [EmailVerified] = 1,
        [EmailVerificationToken] = NULL,
        [EmailVerificationTokenExpires] = NULL,
        [UpdatedAt] = GETUTCDATE()
    WHERE [Id] = @Id 
        AND [EmailVerificationToken] = @EmailVerificationToken
        AND [EmailVerificationTokenExpires] > GETUTCDATE()
        AND [IsDeleted] = 0;
    
    SELECT @@ROWCOUNT as VerifiedRows;
END
GO

-- DELETE ManagerProfile (Soft delete)
CREATE OR ALTER PROCEDURE [dbo].[sp_DeleteManagerProfile]
    @Id UNIQUEIDENTIFIER,
    @UpdatedBy NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE [dbo].[ManagerProfiles]
    SET 
        [IsDeleted] = 1,
        [UpdatedBy] = @UpdatedBy,
        [UpdatedAt] = GETUTCDATE()
    WHERE [Id] = @Id;
    
    SELECT @@ROWCOUNT as DeletedRows;
END
GO

PRINT 'ManagerProfile CRUD stored procedures created successfully'