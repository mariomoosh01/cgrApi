# CGR Database Project

This project contains all SQL scripts and database-related files for the Climbing Gym Registry (CGR) system.

## Structure

```
src/Database/
├── Scripts/
│   ├── Schema/              # Database and table creation scripts
│   ├── StoredProcedures/    # CQRS stored procedures
│   ├── SeedData/           # Initial data insertion scripts
│   └── Migrations/         # Database version control scripts
└── README.md
```

## Deployment

### Complete Database Deployment
Execute the master deployment script to create the entire database:

```sql
-- Run in SQL Server Management Studio or sqlcmd
sqlcmd -S YourServerName -d master -i "Scripts/00_DeployDatabase.sql"
```

### Step-by-Step Deployment
1. **Create Database**: Run `Scripts/Schema/01_CreateDatabase.sql`
2. **Create Tables**: Run `Scripts/Schema/02_CreateTables.sql`
3. **Create Stored Procedures**: Run `Scripts/StoredProcedures/ManagerProfile_CRUD.sql`
4. **Seed Data**: Run `Scripts/SeedData/01_SeedInitialData.sql`

## Database Schema

### Core Tables
- **ManagerProfiles**: System managers who operate gym chains
- **GymChains**: Business entities (climbing gym chains)
- **GymFacilities**: Individual gym locations within chains
- **Employees**: Staff members at chain or facility level
- **Amenities**: Equipment and services at facilities

### Key Features
- **GUID Primary Keys**: All entities use UNIQUEIDENTIFIER for distributed system compatibility
- **Soft Deletes**: IsDeleted flag for data retention
- **Audit Fields**: CreatedAt, UpdatedAt, CreatedBy, UpdatedBy on all entities
- **Email Verification**: Built-in token-based email verification system
- **Hierarchical Structure**: Manager → GymChain → GymFacility → Employees/Amenities

## CQRS Support

The database includes stored procedures optimized for CQRS pattern:
- **Commands**: CREATE, UPDATE, DELETE operations
- **Queries**: GET operations with various filters
- **Business Logic**: Email verification, password reset flows

## Connection String Format

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=your-server;Database=CgrDatabase;Integrated Security=true;TrustServerCertificate=true;"
  }
}
```