# Climbing Gym Registry (CGR) API

A comprehensive microservices-based system for managing climbing gym chains, facilities, employees, and climbers. Built with ASP.NET Core 9.0, CQRS pattern, and designed for containerized deployment.

## 🎯 Project Overview

The CGR system enables climbing gym managers to:
- **Register and manage gym chains** - Business entities with multiple locations
- **Manage facilities** - Individual gym locations with amenities and staff
- **Employee management** - Staff at chain or facility level
- **Climber profiles** - Customer management and climbing data
- **Secure authentication** - Email verification and password management

## 🏗️ Architecture

### Microservices Structure
```
src/
├── Security/                    # 🔐 Authentication & Authorization
├── ClimbingGymManagers/        # 🏢 Gym Chain Management
├── Climbers/                   # 🧗 Climber Profiles & Data
├── Shared.Models/              # 📊 Domain Models & DTOs
├── Shared.Common/              # 🔧 Common Utilities
├── Shared.CQRS/               # ⚡ CQRS Infrastructure
└── Database/                   # 🗄️ SQL Server Database
```

### Domain Model Hierarchy
```
ManagerProfile (Gym Owner)
    └── GymChain (Business Entity)
        └── GymFacility (Individual Locations)
            ├── Employee (Staff Members)
            └── Amenity (Equipment & Services)
```

## 🚀 Quick Start

### Prerequisites
- **.NET 9.0 SDK** - [Download here](https://dotnet.microsoft.com/download/dotnet/9.0)
- **SQL Server** - Express, Developer, or full version
- **Visual Studio 2022** or **VS Code** (recommended)
- **Git** for version control

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd CgrApi
   ```

2. **Restore dependencies**
   ```bash
   dotnet restore
   ```

3. **Set up the database**
   ```sql
   -- Execute in SQL Server Management Studio
   sqlcmd -S YourServerName -d master -i "src/Database/Scripts/00_DeployDatabase.sql"
   ```

4. **Configure connection string**
   ```json
   // In CgrApi/appsettings.json
   {
     "ConnectionStrings": {
       "DefaultConnection": "Server=your-server;Database=CgrDatabase;Integrated Security=true;TrustServerCertificate=true;"
     }
   }
   ```

5. **Run the application**
   ```bash
   dotnet run --project CgrApi/CgrApi.csproj
   ```

6. **Access the API**
   - HTTP: http://localhost:5179
   - HTTPS: https://localhost:7048
   - Swagger UI: https://localhost:7048/swagger (Development only)

## 📊 Database Schema

### Core Tables
- **ManagerProfiles** - System users who manage gym chains
- **GymChains** - Business entities (climbing gym companies)
- **GymFacilities** - Individual gym locations
- **Employees** - Staff members at chain or facility level
- **Amenities** - Equipment and services at each facility

### Key Features
- **GUID Primary Keys** - Distributed system ready
- **Soft Deletes** - Data retention with `IsDeleted` flags
- **Audit Trails** - `CreatedAt`, `UpdatedAt`, `CreatedBy`, `UpdatedBy`
- **Email Verification** - Token-based verification system
- **CQRS Optimized** - Stored procedures for commands and queries

📋 **Database Conventions**: See `src/Database/CONVENTIONS.md` for detailed standards.

## 🔧 Development

### Building
```bash
# Build entire solution
dotnet build

# Build specific project
dotnet build src/Security/Security.csproj
```

### Testing
```bash
# Run all tests
dotnet test

# Test specific project
dotnet test src/Security.Tests/
```

### Development Server
```bash
# Run with hot reload
dotnet watch run --project CgrApi/CgrApi.csproj

# Run specific microservice (future)
dotnet run --project src/Security/Security.csproj
```

### Database Management
```bash
# Deploy complete database
sqlcmd -S ServerName -i "src/Database/Scripts/00_DeployDatabase.sql"

# Run specific scripts
sqlcmd -S ServerName -i "src/Database/Scripts/Schema/02_CreateTables.sql"
```

## 🏛️ Project Structure

```
CgrApi/
├── 📁 CgrApi/                  # Main Web API (Gateway)
├── 📁 src/                     # Source code
│   ├── 📁 Security/            # Authentication microservice
│   ├── 📁 ClimbingGymManagers/ # Gym management microservice
│   ├── 📁 Climbers/            # Climber profiles microservice
│   ├── 📁 Shared.Models/       # Domain models and DTOs
│   │   ├── 📁 Entities/        # Domain entities
│   │   └── 📁 DTOs/            # Data transfer objects
│   ├── 📁 Shared.Common/       # Common utilities
│   ├── 📁 Shared.CQRS/         # CQRS infrastructure
│   └── 📁 Database/            # SQL Server database project
│       ├── 📁 Scripts/Schema/  # Table creation scripts
│       ├── 📁 Scripts/StoredProcedures/ # CQRS procedures
│       ├── 📁 Scripts/SeedData/ # Initial data
│       ├── 📄 CONVENTIONS.md   # Database standards
│       └── 📄 README.md        # Database documentation
├── 📄 CLAUDE.md                # Claude Code guidance
├── 📄 README.md                # This file
└── 📄 .gitignore              # Git ignore rules
```

## 🔐 Authentication Flow

1. **Manager Registration**
   - Create ManagerProfile with email
   - Email verification token sent
   - Password hashed and stored

2. **Email Verification**
   - Token-based verification
   - Account activation upon verification

3. **Login Process**
   - Email/password authentication
   - JWT token generation (future)
   - Secure session management

## 🏢 Business Workflow

1. **Gym Chain Registration**
   - Manager creates business profile
   - Business license and tax information
   - Headquarters address setup

2. **Facility Management**
   - Add individual gym locations
   - Configure amenities and services
   - Set operating hours and capacity

3. **Staff Management**
   - Add employees at chain or facility level
   - Role and department assignment
   - Compensation tracking

## 🐳 Deployment (Future)

### Docker Containerization
```bash
# Build containers (future implementation)
docker-compose build

# Run entire stack
docker-compose up -d

# Scale specific services
docker-compose up --scale security=3 -d
```

### Kubernetes Deployment
```bash
# Deploy to cluster (future)
kubectl apply -f k8s/

# Scale services
kubectl scale deployment climbing-gym-managers --replicas=3
```

## 🛠️ Technology Stack

- **Framework**: ASP.NET Core 9.0
- **Database**: SQL Server with Entity Framework Core
- **Architecture**: CQRS with MediatR
- **Authentication**: JWT (future implementation)
- **Containerization**: Docker (future implementation)
- **Orchestration**: Kubernetes (future implementation)

## 📚 API Documentation

### Current Endpoints
- `GET /weatherforecast` - Sample endpoint (temporary)

### Future Microservice Endpoints
- **Security Service**: `/api/auth/login`, `/api/auth/register`, `/api/auth/verify`
- **Gym Manager Service**: `/api/gyms`, `/api/facilities`, `/api/employees`
- **Climber Service**: `/api/climbers`, `/api/profiles`, `/api/routes`

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Follow coding conventions in `CLAUDE.md`
4. Reference database standards in `src/Database/CONVENTIONS.md`
5. Commit changes (`git commit -m 'Add amazing feature'`)
6. Push to branch (`git push origin feature/amazing-feature`)
7. Open Pull Request

### Code Standards
- **C# Code**: Follow Microsoft coding conventions
- **Database**: Follow `src/Database/CONVENTIONS.md` standards
- **CQRS**: Commands for writes, Queries for reads
- **Performance**: Avoid triggers and cursors (see database conventions)

## 📈 Roadmap

### Phase 1: Core Foundation ✅
- [x] Project structure setup
- [x] Database schema design
- [x] Entity models creation
- [x] CQRS infrastructure

### Phase 2: Authentication (In Progress)
- [ ] JWT implementation
- [ ] Email verification service
- [ ] Password reset functionality
- [ ] Role-based authorization

### Phase 3: Gym Management
- [ ] Gym chain CRUD operations
- [ ] Facility management
- [ ] Employee management
- [ ] Amenity tracking

### Phase 4: Climber Management
- [ ] Climber profile system
- [ ] Route tracking
- [ ] Performance analytics
- [ ] Social features

### Phase 5: Containerization
- [ ] Docker containers for each microservice
- [ ] Docker Compose setup
- [ ] Kubernetes deployment
- [ ] CI/CD pipeline

## 🆘 Troubleshooting

### Common Issues

**Database Connection Issues**
```bash
# Check SQL Server is running
sqlcmd -S YourServer -E -Q "SELECT @@VERSION"

# Verify database exists
sqlcmd -S YourServer -E -Q "SELECT name FROM sys.databases WHERE name = 'CgrDatabase'"
```

**Build Errors**
```bash
# Clean and rebuild
dotnet clean
dotnet restore
dotnet build
```

**Port Conflicts**
- Default ports: HTTP 5179, HTTPS 7048
- Modify in `CgrApi/Properties/launchSettings.json`

## 📞 Support

- **Documentation**: Check `CLAUDE.md` for development guidance
- **Database Help**: Reference `src/Database/CONVENTIONS.md`
- **Issues**: Create GitHub issue with detailed description
- **Questions**: Contact the development team

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ for the climbing community** 🧗‍♀️🧗‍♂️