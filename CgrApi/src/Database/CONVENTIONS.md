# Database Conventions & Standards

## File Structure & Naming

### Directory Structure
```
src/Database/Scripts/
├── Schema/
│   ├── 01_CreateDatabase.sql
│   ├── 02_CreateTables.sql          # Core tables
│   ├── 03_CreateTables_Security.sql # Security-specific tables (future)
│   └── 04_CreateTables_Climbers.sql # Climber-specific tables (future)
│   └── 05_CreateTables_Gym_Managers.sql # Climbing-gym-managers-specific tables (future)
├── StoredProcedures/
│   ├── {EntityName}_CRUD.sql        # e.g., ManagerProfile_CRUD.sql
│   ├── {EntityName}_Queries.sql     # Complex queries
│   └── {EntityName}_Commands.sql    # Complex commands
├── Views/
│   └── vw_{ViewName}.sql            # e.g., vw_ActiveGymFacilities.sql
├── Functions/
│   └── fn_{FunctionName}.sql        # e.g., fn_CalculateDistance.sql
├── SeedData/
│   ├── 01_SeedInitialData.sql       # Essential reference data
│   └── 02_SeedTestData.sql          # Development/test data
└── Migrations/
    └── {YYYY-MM-DD}_{Description}.sql # e.g., 2024-12-26_AddClimberTables.sql
```

## Naming Conventions

### Table Names
- **PascalCase**: `ManagerProfiles`, `GymChains`, `GymFacilities`
- **Plural**: Always use plural form for table names
- **Descriptive**: Clear, business-domain names

### Column Names
- **PascalCase**: `FirstName`, `BusinessEmail`, `CreatedAt`
- **No Abbreviations**: Use `PhoneNumber` not `Phone`
- **Consistent Prefixes**:
  - `Is{Property}`: Boolean fields (`IsActive`, `IsDeleted`)
  - `{Entity}Id`: Foreign keys (`ManagerProfileId`, `GymChainId`)

### Primary Keys
- **Always UNIQUEIDENTIFIER**: `Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID()`
- **Column Name**: Always `Id` (not `{Table}Id` for primary key)

### Foreign Keys
- **Column Name**: `{ReferencedEntity}Id` (e.g., `ManagerProfileId`)
- **Constraint Name**: `FK_{ChildTable}_{ForeignKeyColumn}`
  - Example: `FK_GymChains_ManagerProfileId`

### Indexes
- **Naming**: `IX_{TableName}_{ColumnName(s)}`
- **Examples**:
  - `IX_ManagerProfiles_Email`
  - `IX_GymFacilities_GymChainId_IsActive`

## Standard Table Structure

### Base Entity Fields (Required on ALL tables)
```sql
-- Base entity fields (always at the end)
[CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
[UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
[CreatedBy] NVARCHAR(255) NULL,
[UpdatedBy] NVARCHAR(255) NULL,
[IsDeleted] BIT NOT NULL DEFAULT 0
```

### Data Types Standards
- **GUIDs**: `UNIQUEIDENTIFIER`
- **Strings**: 
  - Short text (names, codes): `NVARCHAR(100)`
  - Email addresses: `NVARCHAR(255)`
  - Long text/descriptions: `NVARCHAR(1000)`
  - Very long text: `NVARCHAR(MAX)`
- **Dates**: `DATETIME2` (more precise than DATETIME)
- **Money**: `DECIMAL(12,2)` for currency, `DECIMAL(10,2)` for rates
- **Booleans**: `BIT` with explicit defaults

### Template for New Tables
```sql
-- Create {TableName} table
CREATE TABLE [dbo].[{TableName}] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    
    -- Business fields here
    [Name] NVARCHAR(200) NOT NULL,
    [Description] NVARCHAR(1000) NULL,
    [IsActive] BIT NOT NULL DEFAULT 1,
    
    -- Foreign keys
    [{ParentEntity}Id] UNIQUEIDENTIFIER NOT NULL,
    
    -- Base entity fields
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [CreatedBy] NVARCHAR(255) NULL,
    [UpdatedBy] NVARCHAR(255) NULL,
    [IsDeleted] BIT NOT NULL DEFAULT 0,
    
    -- Constraints
    CONSTRAINT [FK_{TableName}_{ForeignKeyColumn}] FOREIGN KEY ([{ForeignKeyColumn}]) 
        REFERENCES [dbo].[{ParentTable}] ([Id]) ON DELETE CASCADE
);
GO

-- Create indexes
CREATE NONCLUSTERED INDEX [IX_{TableName}_{ForeignKeyColumn}] ON [dbo].[{TableName}] ([{ForeignKeyColumn}]);
GO
```

## Stored Procedure Conventions

### CRUD Procedures (per entity)
- `sp_Create{EntityName}` - Insert new record
- `sp_Get{EntityName}ById` - Get by primary key
- `sp_Get{EntityName}By{Property}` - Get by specific property
- `sp_Update{EntityName}` - Update existing record
- `sp_Delete{EntityName}` - Soft delete (set IsDeleted = 1)

### Query Procedures
- `sp_List{EntityName}` - Get list with pagination
- `sp_Search{EntityName}` - Search with filters
- `sp_Get{EntityName}With{RelatedEntity}` - Get with related data

### File Naming for Stored Procedures
- **CRUD Operations**: `{EntityName}_CRUD.sql`
- **Complex Queries**: `{EntityName}_Queries.sql`
- **Business Logic**: `{EntityName}_Commands.sql`

## Microservice-Specific Tables

### When adding tables for specific microservices:

**Security Microservice Tables:**
- File: `03_CreateTables_Security.sql`
- Tables: `UserSessions`, `RefreshTokens`, `LoginAttempts`, etc.

**Climbers Microservice Tables:**
- File: `04_CreateTables_Climbers.sql`
- Tables: `ClimberProfiles`, `ClimbingGrades`, `RouteAttempts`, etc.

**ClimbingGymManagers Tables:**
- Already in `02_CreateTables.sql`
- Additional tables: `Memberships`, `Classes`, `Reservations`, etc.

## Performance Guidelines

### AVOID These Patterns
- **Triggers**: Avoid database triggers due to performance overhead and debugging complexity
  - Use application-layer event handling instead
  - Exception: Only use for critical audit requirements that must be database-enforced
- **Cursors**: Never use cursors - use set-based operations instead
  - Replace with JOINs, CTEs, or window functions
  - Use `EXISTS` instead of cursor loops for existence checks
- **Dynamic SQL in Stored Procedures**: Minimize dynamic SQL to prevent injection risks
- **SELECT * in Stored Procedures**: Always specify column names explicitly

### Preferred Patterns
- **Set-based Operations**: Use JOINs, CTEs, and aggregate functions
- **Stored Procedures**: For complex business logic and CQRS operations
- **Views**: For commonly used complex queries
- **Proper Indexing**: Create indexes on foreign keys and frequently queried columns
- **Parameterized Queries**: Always use parameters to prevent SQL injection

## Migration Strategy

### For schema changes:
1. Create migration file: `{YYYY-MM-DD}_{Description}.sql`
2. Include rollback script in comments
3. Test on development environment first
4. Document breaking changes

Example migration file:
```sql
-- Migration: Add ClimbingRoutes table
-- Date: 2024-12-26
-- Author: Developer Name

-- Forward migration
CREATE TABLE [dbo].[ClimbingRoutes] (
    -- table definition
);

-- Rollback (commented):
-- DROP TABLE [dbo].[ClimbingRoutes];
```

This ensures consistency and maintainability as the database grows across all microservices!