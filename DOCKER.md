# Docker Setup Guide

This guide explains how to use Docker with the Backend Template project, including development and production environments.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Docker Files Overview](#docker-files-overview)
- [Development Environment](#development-environment)
- [Production Environment](#production-environment)
- [Utility Scripts](#utility-scripts)
- [Database Management](#database-management)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

## 🚀 Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed and running
- [Docker Compose](https://docs.docker.com/compose/install/) (comes with Docker Desktop)
- Basic understanding of Docker concepts

## ⚡ Quick Start

### Development Environment

```bash
# Start development environment with MongoDB
npm run docker:dev
# or
./scripts/setup.sh development

# View logs
npm run docker:logs

# Check status
npm run docker:status
```

### Production Environment

```bash
# Set up production environment
cp .env.production.example .env.production
# Edit .env.production with your production values

# Start production environment
npm run docker:prod
# or
./scripts/setup.sh production
```

## 📁 Docker Files Overview

### `Dockerfile`
Multi-stage Dockerfile with three targets:
- **base**: Common dependencies
- **development**: Development environment with hot-reload
- **production**: Optimized production build

### `docker-compose.yaml`
Development configuration with:
- Backend service (development target)
- MongoDB database
- Volume mounts for hot-reload
- Development environment variables

### `docker-compose.prod.yaml`
Production configuration with:
- Backend service (production target)
- MongoDB database with production settings
- Resource limits
- Logging configuration
- Environment variables from `.env.production`

## 🔧 Development Environment

### Starting Development Environment

```bash
# Method 1: Using npm scripts
npm run docker:dev

# Method 2: Using setup script
./scripts/setup.sh development

# Method 3: Using docker-compose directly
docker-compose up --build -d
```

### What's Included

- **Backend**: Node.js app with hot-reload (`http://localhost:3000`)
- **MongoDB**: Database server (`mongodb://admin:password123@localhost:27017/backend_template_dev`)
- **Volume Mounts**: Source code changes reflect immediately
- **File Watching**: Automatic rebuilds on package.json changes

### Environment Variables

Development environment uses:
- `NODE_ENV=development`
- `PORT=3000`
- `MONGODB_URI=mongodb://admin:password123@mongodb:27017/backend_template_dev?authSource=admin`

## 🚀 Production Environment

### Setup Production Environment

1. **Create production environment file:**
   ```bash
   cp .env.production.example .env.production
   ```

2. **Edit `.env.production` with your values:**
   ```bash
   # Update these critical values
   MONGO_ROOT_PASSWORD=your-secure-password
   JWT_SECRET=your-super-secure-jwt-secret
   MONGODB_URI=mongodb://admin:your-secure-password@mongodb:27017/backend_template
   ```

3. **Start production environment:**
   ```bash
   npm run docker:prod
   ```

### Production Features

- **Optimized Build**: Multi-stage build for smaller image size
- **Security**: Non-root user, minimal dependencies
- **Resource Limits**: CPU and memory constraints
- **Health Checks**: Built-in application health monitoring
- **Logging**: Structured logging with rotation
- **Auto-restart**: Services restart automatically on failure

## 🛠 Utility Scripts

### Database Management (`scripts/db-setup.sh`)

```bash
# Start MongoDB only
./scripts/db-setup.sh start

# Stop MongoDB
./scripts/db-setup.sh stop

# Check status
./scripts/db-setup.sh status

# View logs
./scripts/db-setup.sh logs

# Restart MongoDB
./scripts/db-setup.sh restart
```

### Docker Utilities (`scripts/docker-utils.sh`)

```bash
# View service logs
./scripts/docker-utils.sh logs [service]

# Open shell in container
./scripts/docker-utils.sh shell [backend|mongodb]

# Restart services
./scripts/docker-utils.sh restart [service]

# Rebuild and restart
./scripts/docker-utils.sh rebuild

# Clean up Docker resources
./scripts/docker-utils.sh cleanup

# Check service status
./scripts/docker-utils.sh status

# Open MongoDB shell
./scripts/docker-utils.sh mongo-shell

# Backup database
./scripts/docker-utils.sh backup-db

# Restore database
./scripts/docker-utils.sh restore-db /path/to/backup.gz

# Health check
./scripts/docker-utils.sh health
```

### Setup Script (`scripts/setup.sh`)

```bash
# Development environment
./scripts/setup.sh development
./scripts/setup.sh dev

# Production environment
./scripts/setup.sh production
./scripts/setup.sh prod
```

## 💾 Database Management

### MongoDB Access

**Development:**
```bash
# Using mongo shell
docker exec -it backend-template-mongodb-dev mongosh -u admin -p password123 --authenticationDatabase admin

# Using utility script
./scripts/docker-utils.sh mongo-shell
```

**Connection URI:**
```
mongodb://admin:password123@localhost:27017/backend_template_dev?authSource=admin
```

### Database Backup & Restore

```bash
# Create backup
./scripts/docker-utils.sh backup-db

# Restore from backup
./scripts/docker-utils.sh restore-db ./backups/mongodb_backup_20231201_143022.gz
```

### Database Initialization

The MongoDB container runs `scripts/mongo-init.js` on first startup to:
- Create application database
- Set up initial user
- Create collections and indexes

## 🔍 Troubleshooting

### Common Issues

**Port Already in Use:**
```bash
# Stop conflicting services
./scripts/docker-utils.sh cleanup
docker-compose down
```

**Permission Issues:**
```bash
# Fix file permissions
sudo chown -R $(whoami):$(whoami) .
```

**Database Connection Issues:**
```bash
# Check MongoDB status
./scripts/db-setup.sh status

# View MongoDB logs
./scripts/db-setup.sh logs
```

**Container Build Issues:**
```bash
# Clean Docker cache
docker system prune -f
docker-compose build --no-cache
```

### Health Checks

```bash
# Check all service health
./scripts/docker-utils.sh health

# Check individual service
curl http://localhost:3000/health
```

### Viewing Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f mongodb

# Using utility script
./scripts/docker-utils.sh logs backend
```

## 📚 Best Practices

### Security

1. **Change default passwords** in production
2. **Use strong JWT secrets**
3. **Limit resource usage** in production
4. **Keep Docker images updated**
5. **Use specific image tags** instead of `latest`

### Performance

1. **Use `.dockerignore`** to exclude unnecessary files
2. **Optimize Dockerfile** with multi-stage builds
3. **Set resource limits** in production
4. **Use volumes** for persistent data

### Monitoring

1. **Enable health checks**
2. **Set up log rotation**
3. **Monitor resource usage**
4. **Use structured logging**

### Development

1. **Use hot-reload** in development
2. **Keep development/production parity**
3. **Test with production-like data**
4. **Regular database backups**

## 🆘 Getting Help

If you encounter issues:

1. **Check logs**: `./scripts/docker-utils.sh logs`
2. **Verify Docker**: `docker info`
3. **Check ports**: `netstat -tulpn | grep :3000`
4. **Clean up**: `./scripts/docker-utils.sh cleanup`
5. **Rebuild**: `./scripts/docker-utils.sh rebuild`

## 📝 NPM Scripts Reference

```json
{
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

For more information, see the [main README](README.md) or check the [Docker documentation](https://docs.docker.com/).