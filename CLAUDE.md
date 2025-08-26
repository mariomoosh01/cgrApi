# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Climbing Gym Registry (CGR)** system built as a microservices architecture using ASP.NET Core 9.0. The system manages climbing gym chains, facilities, employees, and climbers using CQRS pattern with separate class libraries for business logic that will be deployed as containerized microservices.

## Development Commands

### Building and Running
- `dotnet build` - Build entire solution
- `dotnet run --project CgrApi/CgrApi.csproj` - Run the main API gateway
- `dotnet watch run --project CgrApi/CgrApi.csproj` - Run with hot reload for development

### Database Management
- **Deploy Database**: Execute `src/Database/Scripts/00_DeployDatabase.sql` in SQL Server
- **Schema Only**: Run individual scripts in `src/Database/Scripts/Schema/`
- **Connection String**: Configure in `CgrApi/appsettings.json` under `ConnectionStrings:DefaultConnection`

### Testing and Validation
- `dotnet test` - Run unit tests (no tests currently exist)
- Use the `CgrApi.http` file with VS Code REST Client extension or similar tools to test endpoints

## Architecture

### Microservices Structure
```
src/
├── Security/                    # Authentication, authorization, user management
├── ClimbingGymManagers/        # Gym chain management, facilities, employees
├── Climbers/                   # Climber profiles and climbing data
├── Shared.Models/              # Entities and DTOs shared across services
│   ├── Entities/               # Domain entities (ManagerProfile, GymChain, etc.)
│   └── DTOs/                   # Data transfer objects
├── Shared.Common/              # Common utilities and interfaces
├── Shared.CQRS/               # CQRS infrastructure (MediatR, handlers)
└── Database/                   # SQL Server database project
    ├── Scripts/Schema/         # Table creation scripts
    ├── Scripts/StoredProcedures/ # CQRS stored procedures
    └── CONVENTIONS.md          # **READ THIS**: Database standards and conventions
```

### Main API Gateway
- `CgrApi/CgrApi.csproj` - Main Web API project (currently serving as gateway)
- `CgrApi/Program.cs` - Application entry point with controller configuration
- `CgrApi/Controllers/` - API controllers that orchestrate microservices
- `CgrApi/appsettings.json` - Configuration including database connection strings

### Database Architecture
- **Database**: SQL Server with Entity Framework Core
- **Pattern**: CQRS with stored procedures for optimal performance
- **Entities**: ManagerProfile → GymChain → GymFacility → Employees/Amenities hierarchy
- **Conventions**: See `src/Database/CONVENTIONS.md` for naming standards and patterns
- **Key Features**: GUID PKs, soft deletes, audit trails, email verification

### Domain Model
1. **ManagerProfile** - Gym chain owners/operators with email verification
2. **GymChain** - Business entities (climbing gym chains)
3. **GymFacility** - Individual gym locations within chains
4. **Employee** - Staff members (chain-level or facility-specific)
5. **Amenity** - Equipment and services at facilities

### Key Configuration
- **Target Framework**: .NET 9.0
- **Architecture Pattern**: CQRS with microservices
- **Database**: SQL Server with stored procedures
- **Development URLs**: 
  - HTTP: http://localhost:5179
  - HTTPS: https://localhost:7048
- **OpenAPI**: Available in development for API documentation

### Important Notes
- Microservices are currently **class libraries** - will be converted to Web APIs for Docker deployment
- **Always reference** `src/Database/CONVENTIONS.md` for database standards
- Use CQRS pattern: Commands for writes, Queries for reads
- Avoid triggers and cursors for performance (see database conventions)

## Code Quality Standards

### Design Patterns and SOLID Principles
**MANDATORY**: All code implementations must enforce design patterns and SOLID principles:

#### SOLID Principles
- **Single Responsibility Principle (SRP)**: Each class should have one reason to change
- **Open/Closed Principle (OCP)**: Open for extension, closed for modification
- **Liskov Substitution Principle (LSP)**: Derived classes must be substitutable for base classes
- **Interface Segregation Principle (ISP)**: Depend on abstractions, not concretions
- **Dependency Inversion Principle (DIP)**: High-level modules should not depend on low-level modules

#### Required Design Patterns
- **Repository Pattern**: For data access abstraction
- **Command Pattern**: For CQRS command handling
- **Query Pattern**: For CQRS query handling
- **Factory Pattern**: For object creation when complexity is high
- **Strategy Pattern**: For interchangeable algorithms/behaviors
- **Decorator Pattern**: For extending functionality without modification
- **Observer Pattern**: For event handling and notifications

#### Implementation Guidelines
- Use dependency injection for all dependencies
- Implement interfaces for all services and repositories
- Apply proper separation of concerns across layers
- Follow DRY (Don't Repeat Yourself) principle
- Ensure high cohesion and loose coupling
- Write clean, self-documenting code with meaningful names