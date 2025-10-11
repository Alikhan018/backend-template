# 🚀 Professional Backend Template

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-20+-green.svg)](https://nodejs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0+-blue.svg)](https://www.typescriptlang.org/)
[![Docker](https://img.shields.io/badge/Docker-Supported-blue.svg)](https://www.docker.com/)
[![MongoDB](https://img.shields.io/badge/Database-MongoDB-green.svg)](https://www.mongodb.com/)

A **production-ready**, **enterprise-grade** Node.js backend template built with TypeScript, featuring modern architecture patterns, comprehensive Docker support, and developer-friendly tooling.

## ✨ **Why This Template?**

This isn't just another Node.js starter - it's a **carefully crafted** backend foundation that incorporates **industry best practices**, **clean architecture**, and **production-ready** configurations to give you a **significant head start** on any backend project.

## 🎯 **Key Highlights**

### 🏗️ **Enterprise Architecture**
- **Clean Architecture** with modular design
- **SOLID principles** implementation
- **Separation of concerns** with clear boundaries
- **Domain-driven design** structure

### 🔐 **Security First**
- JWT-based authentication
- Password hashing with bcrypt
- Input validation with Zod
- CORS protection
- Security headers and best practices

### 🐳 **Production-Ready Docker**
- Multi-stage Dockerfile optimization
- Separate dev/prod environments
- MongoDB integration included
- Health checks and monitoring
- Resource optimization

### 🛠️ **Developer Experience**
- Hot-reload development
- Comprehensive logging
- Type safety with TypeScript
- Path aliases for clean imports
- Rich utility scripts

---

## 📋 **Table of Contents**

- [🚀 Quick Start](#-quick-start)
- [🏛️ Architecture](#️-architecture)
- [🔧 Features](#-features)
- [🐳 Docker Support](#-docker-support)
- [📁 Project Structure](#-project-structure)
- [🔌 API Endpoints](#-api-endpoints)
- [🛡️ Security Features](#️-security-features)
- [📚 Documentation](#-documentation)
- [🚀 Deployment](#-deployment)
- [🤝 Contributing](#-contributing)

---

## 🚀 **Quick Start**

### **Prerequisites**
- [Node.js 20+](https://nodejs.org/)
- [Docker & Docker Compose](https://docs.docker.com/get-docker/)
- [MongoDB](https://www.mongodb.com/) (or use Docker)

### **⚡ Super Quick Start (Docker)**
```bash
# Clone the repository
git clone https://github.com/Alikhan018/backend-template.git
cd backend-template

# Start everything with Docker (recommended)
npm run docker:dev

# 🎉 That's it! Your API is running at http://localhost:3000
```

### **🔧 Manual Setup**
```bash
# Install dependencies
npm install

# Set up environment variables
cp .env.example .env

# Start MongoDB (Docker)
npm run db:start

# Start development server
npm run dev
```

---

## 🏛️ **Architecture**

This template follows **Clean Architecture** principles with a modular, scalable design:

### **🎨 Architectural Patterns**
- **Layered Architecture**: Clear separation between presentation, business, and data layers
- **Repository Pattern**: Abstract data access logic
- **Dependency Injection**: Loose coupling between components
- **Base Classes**: Consistent behavior across modules
- **Error-First Design**: Comprehensive error handling strategy

### **📦 Module Structure**
Each feature is organized as a self-contained module:
```
src/modules/[feature]/
├── controllers/     # HTTP request handlers
├── services/        # Business logic
├── models/          # Data models
├── routes/          # Route definitions
├── validators/      # Input validation schemas
├── dtos/            # Data transfer objects
└── interfaces/      # TypeScript interfaces
```

---

## 🔧 **Features**

### **🏗️ Core Infrastructure**
- ✅ **TypeScript** - Full type safety and modern JS features
- ✅ **Express.js** - Fast, minimal web framework
- ✅ **MongoDB** - Flexible NoSQL database with Mongoose ODM
- ✅ **JWT Authentication** - Secure token-based auth
- ✅ **Winston Logging** - Structured logging with file rotation
- ✅ **Environment Configuration** - Flexible env management

### **🛡️ Security & Validation**
- ✅ **Zod Validation** - Runtime type checking and validation
- ✅ **Password Hashing** - bcrypt for secure password storage
- ✅ **JWT Middleware** - Route-level authentication
- ✅ **Input Sanitization** - Prevent injection attacks
- ✅ **CORS Protection** - Configurable cross-origin requests

### **🔄 Development Experience**
- ✅ **Hot Reload** - Instant feedback during development
- ✅ **Path Aliases** - Clean import statements (`@/modules/...`)
- ✅ **Error Handling** - Centralized error management
- ✅ **Base Classes** - Consistent patterns across modules
- ✅ **TypeScript Strict Mode** - Maximum type safety

### **🐳 DevOps & Deployment**
- ✅ **Docker Support** - Multi-stage builds for dev/prod
- ✅ **Docker Compose** - Orchestrated services
- ✅ **Health Checks** - Built-in application monitoring
- ✅ **Logging Strategy** - Structured logs with rotation
- ✅ **Environment Separation** - Dev/staging/prod configs

---

## 🐳 **Docker Support**

### **🎯 What Makes Our Docker Setup Special**

#### **🏗️ Multi-Stage Builds**
- **Development Stage**: Hot-reload with full debugging
- **Production Stage**: Optimized, lightweight containers
- **Security**: Non-root users and minimal attack surface

#### **🔧 Complete Development Environment**
```bash
# Development with MongoDB
npm run docker:dev

# Production environment  
npm run docker:prod

# View logs
npm run docker:logs

# Database management
npm run db:start
npm run db:status
npm run db:logs
```

#### **🛠️ Advanced Docker Features**
- **Health Checks**: Automatic service monitoring
- **Resource Limits**: Memory and CPU constraints
- **Volume Management**: Persistent data and hot-reload
- **Network Isolation**: Secure service communication
- **Backup/Restore**: Built-in database utilities

**[📖 Complete Docker Guide →](DOCKER.md)**

---

## 📁 **Project Structure**

```
backend-template/
├── 📂 src/
│   ├── 📂 configs/           # Configuration modules
│   │   ├── database/         # Database connection
│   │   └── logger/          # Winston logger setup
│   ├── 📂 core/             # Core framework components
│   │   ├── controller/      # Base controller class
│   │   ├── service/         # Base service class
│   │   ├── error/           # Error handling
│   │   └── routes/          # Route registration
│   ├── 📂 modules/          # Feature modules
│   │   ├── auth/            # Authentication module
│   │   └── users/           # User management
│   ├── 📂 middlewares/      # Express middlewares
│   │   ├── auth.middleware.ts
│   │   ├── validate.middleware.ts
│   │   └── role.middleware.ts
│   ├── 📂 environment/      # Environment configuration
│   └── 📂 server/           # Server setup
├── 📂 scripts/              # Utility scripts
│   ├── setup.sh            # Environment setup
│   ├── db-setup.sh         # Database management
│   └── docker-utils.sh     # Docker utilities
├── 📂 logs/                 # Application logs
├── 🐳 Dockerfile            # Multi-stage Docker build
├── 🐳 docker-compose.yaml   # Development environment
├── 🐳 docker-compose.prod.yaml # Production environment
└── 📋 DOCKER.md            # Docker documentation
```

---

## 🔌 **API Endpoints**

### **🔐 Authentication**
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| `POST` | `/api/auth/signup` | Register new user | ❌ |
| `POST` | `/api/auth/login` | User login | ❌ |

### **👥 User Management**
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| `GET` | `/api/users` | Get all users | ✅ |
| `POST` | `/api/users` | Create user | ❌ |
| `GET` | `/api/users/:id` | Get user by ID | ✅ |
| `PUT` | `/api/users/:id` | Update user | ✅ |
| `DELETE` | `/api/users/:id` | Delete user | ✅ |

### **📊 System**
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| `GET` | `/` | Health check | ❌ |

### **📝 Sample Requests**

<details>
<summary><strong>🔐 User Registration</strong></summary>

```bash
curl -X POST http://localhost:3000/api/auth/signup \\
  -H "Content-Type: application/json" \\
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123"
  }'
```

**Response:**
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "id": "507f1f77bcf86cd799439011",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```
</details>

<details>
<summary><strong>🔑 User Login</strong></summary>

```bash
curl -X POST http://localhost:3000/api/auth/login \\
  -H "Content-Type: application/json" \\
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 3600
  }
}
```
</details>

---

## 🛡️ **Security Features**

### **🔒 Authentication & Authorization**
- **JWT Tokens**: Secure, stateless authentication
- **Password Hashing**: bcrypt with salt rounds
- **Token Expiration**: Configurable token lifetime
- **Route Protection**: Middleware-based auth checks

### **🛡️ Input Validation**
- **Zod Schemas**: Runtime type checking
- **Request Validation**: Comprehensive input sanitization
- **Error Responses**: Detailed validation feedback
- **SQL Injection Protection**: Parameterized queries

### **🔐 Security Headers**
```javascript
// CORS Configuration
CORS_ORIGIN=http://localhost:3000,https://yourapp.com

// JWT Security
JWT_SECRET=your-super-secure-secret
JWT_EXPIRES_IN=7d

// Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
```

---

## 📚 **Documentation**

### **📖 Available Guides**
- **[🐳 Docker Setup Guide](DOCKER.md)** - Complete Docker documentation
- **[🔧 Development Guide](#)** - Development best practices
- **[🚀 Deployment Guide](#)** - Production deployment
- **[🔌 API Reference](#)** - Complete API documentation

### **🛠️ NPM Scripts**

```json
{
  "dev": "Start development server with hot-reload",
  "build": "Build TypeScript to JavaScript",
  "start": "Start production server",
  
  "db:start": "Start MongoDB container",
  "db:stop": "Stop MongoDB container",
  "db:status": "Check MongoDB status",
  "db:logs": "View MongoDB logs",
  
  "docker:dev": "Start development environment",
  "docker:prod": "Start production environment",
  "docker:down": "Stop all containers",
  "docker:logs": "View service logs",
  "docker:shell": "Open container shell",
  "docker:cleanup": "Clean Docker resources",
  "docker:status": "Check container status",
  "docker:health": "Health check all services"
}
```

---

## 🚀 **Deployment**

### **🌩️ Cloud Deployment**
This template is ready for deployment on major cloud platforms:

- **AWS ECS/EKS** - Container orchestration
- **Google Cloud Run** - Serverless containers  
- **Azure Container Instances** - Managed containers
- **DigitalOcean Apps** - Platform-as-a-Service
- **Railway** - Simple deployment
- **Render** - Zero-config deployment

### **🐳 Docker Production**
```bash
# Create production environment
cp .env.production.example .env.production

# Edit with your production values
vim .env.production

# Deploy with Docker Compose
docker-compose -f docker-compose.prod.yaml up -d

# Or use our script
npm run docker:prod
```

### **🔧 Environment Variables**
Critical environment variables for production:
```env
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb://username:password@host:port/database
JWT_SECRET=your-super-secure-jwt-secret-change-this
CORS_ORIGIN=https://yourdomain.com
```

---

## 🎯 **What Makes This Template Special**

### **🏆 Production-Ready**
- ✅ **Battle-tested** patterns and practices
- ✅ **Scalable** architecture that grows with your needs
- ✅ **Security-first** approach with comprehensive protection
- ✅ **Performance** optimizations built-in
- ✅ **Monitoring** and logging ready for production

### **👨‍💻 Developer-Friendly**
- ✅ **Hot-reload** for instant development feedback
- ✅ **TypeScript** for better code quality and IDE support
- ✅ **Clear documentation** with examples
- ✅ **Utility scripts** for common tasks
- ✅ **Consistent patterns** across the codebase

### **🚀 Modern Technology Stack**
- ✅ **Latest Node.js** features and best practices
- ✅ **MongoDB** with Mongoose for data modeling
- ✅ **Docker** for consistent environments
- ✅ **Winston** for professional logging
- ✅ **Zod** for runtime validation

---

## 🤝 **Contributing**

We welcome contributions! Here's how you can help:

### **🎯 Areas for Contribution**
- 📝 **Documentation**: Improve guides and examples
- 🔧 **Features**: Add new modules and functionality
- 🐛 **Bug Fixes**: Report and fix issues
- 🔬 **Testing**: Add comprehensive test coverage
- 🚀 **Performance**: Optimize and benchmark

### **📋 Contribution Guidelines**
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📊 **Project Stats**

- **⭐ Stars**: Give us a star if you find this useful!
- **🍴 Forks**: Fork to create your own version
- **📝 Issues**: Report bugs and request features
- **🔄 Pull Requests**: Contribute improvements

---

## 📄 **License**

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🎉 **Getting Started**

Ready to build something amazing? 

```bash
git clone https://github.com/Alikhan018/backend-template.git
cd backend-template
npm run docker:dev
```

**🚀 Your production-ready backend is now running at `http://localhost:3000`**

---

## 🙏 **Acknowledgments**

- **Express.js** - Fast, unopinionated web framework
- **TypeScript** - JavaScript that scales
- **MongoDB** - The application data platform
- **Docker** - Containerization platform
- **Winston** - Universal logging library

---

<div align="center">

**Built with ❤️ by [Muhammad Ali Khan](https://github.com/Alikhan018)**

[⭐ Star this repo](https://github.com/Alikhan018/backend-template) | [🐛 Report Bug](https://github.com/Alikhan018/backend-template/issues) | [💡 Request Feature](https://github.com/Alikhan018/backend-template/issues)

</div>