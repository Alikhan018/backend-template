#!/bin/bash
# Docker Utility Script for Backend Template
# Collection of useful Docker commands for development and maintenance

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

PROJECT_NAME="backend-template"

echo -e "${BLUE}🐳 Docker Utilities for Backend Template${NC}"
echo ""

# Function to show usage
show_usage() {
    echo -e "${YELLOW}Usage: $0 [command]${NC}"
    echo ""
    echo -e "${BLUE}Available commands:${NC}"
    echo "  logs [service]    - Show logs for all services or specific service"
    echo "  shell [service]   - Open shell in backend or mongodb container"
    echo "  restart [service] - Restart all services or specific service"
    echo "  rebuild           - Rebuild and restart all services"
    echo "  cleanup           - Clean up Docker resources"
    echo "  status            - Show status of all containers"
    echo "  mongo-shell       - Open MongoDB shell"
    echo "  backup-db         - Backup MongoDB database"
    echo "  restore-db [file] - Restore MongoDB database from backup"
    echo "  health            - Check health of all services"
    echo ""
}

# Function to show logs
show_logs() {
    local service=${1:-""}
    
    if [ -n "$service" ]; then
        echo -e "${BLUE}📋 Showing logs for $service...${NC}"
        docker-compose logs -f "$service"
    else
        echo -e "${BLUE}📋 Showing logs for all services...${NC}"
        docker-compose logs -f
    fi
}

# Function to open shell
open_shell() {
    local service=${1:-"backend"}
    
    case $service in
        "backend"|"app")
            echo -e "${BLUE}🐚 Opening shell in backend container...${NC}"
            docker-compose exec backend /bin/sh
            ;;
        "mongodb"|"mongo"|"db")
            echo -e "${BLUE}🐚 Opening shell in MongoDB container...${NC}"
            docker-compose exec mongodb /bin/bash
            ;;
        *)
            echo -e "${RED}❌ Unknown service: $service${NC}"
            echo -e "${YELLOW}Available services: backend, mongodb${NC}"
            exit 1
            ;;
    esac
}

# Function to restart services
restart_services() {
    local service=${1:-""}
    
    if [ -n "$service" ]; then
        echo -e "${YELLOW}🔄 Restarting $service...${NC}"
        docker-compose restart "$service"
    else
        echo -e "${YELLOW}🔄 Restarting all services...${NC}"
        docker-compose restart
    fi
    
    echo -e "${GREEN}✅ Restart completed${NC}"
}

# Function to rebuild services
rebuild_services() {
    echo -e "${YELLOW}🏗️  Rebuilding and restarting services...${NC}"
    docker-compose down
    docker-compose up --build -d
    echo -e "${GREEN}✅ Rebuild completed${NC}"
}

# Function to cleanup Docker resources
cleanup_docker() {
    echo -e "${YELLOW}🧹 Cleaning up Docker resources...${NC}"
    
    # Stop all containers
    docker-compose down --remove-orphans
    
    # Remove unused containers
    docker container prune -f
    
    # Remove unused images
    docker image prune -f
    
    # Remove unused volumes (be careful with this in production)
    read -p "$(echo -e ${YELLOW}Do you want to remove unused volumes? This will delete any data not in named volumes [y/N]: ${NC})" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker volume prune -f
    fi
    
    # Remove unused networks
    docker network prune -f
    
    echo -e "${GREEN}✅ Cleanup completed${NC}"
}

# Function to show container status
show_status() {
    echo -e "${BLUE}📊 Container Status:${NC}"
    echo ""
    docker-compose ps
    echo ""
    
    echo -e "${BLUE}💾 Volume Usage:${NC}"
    docker volume ls --filter name=${PROJECT_NAME}
    echo ""
    
    echo -e "${BLUE}🌐 Network Info:${NC}"
    docker network ls --filter name=${PROJECT_NAME}
}

# Function to open MongoDB shell
open_mongo_shell() {
    echo -e "${BLUE}🍃 Opening MongoDB shell...${NC}"
    if [ "$(docker-compose ps -q mongodb)" ]; then
        docker-compose exec mongodb mongosh -u admin -p password123 --authenticationDatabase admin
    else
        echo -e "${RED}❌ MongoDB container is not running${NC}"
        echo -e "${YELLOW}💡 Start services with: ./scripts/setup.sh${NC}"
    fi
}

# Function to backup database
backup_database() {
    local backup_dir="./backups"
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_file="$backup_dir/mongodb_backup_$timestamp.gz"
    
    echo -e "${BLUE}💾 Creating database backup...${NC}"
    
    # Create backup directory if it doesn't exist
    mkdir -p "$backup_dir"
    
    if [ "$(docker-compose ps -q mongodb)" ]; then
        docker-compose exec -T mongodb mongodump --username admin --password password123 --authenticationDatabase admin --gzip --archive | gzip > "$backup_file"
        echo -e "${GREEN}✅ Backup created: $backup_file${NC}"
    else
        echo -e "${RED}❌ MongoDB container is not running${NC}"
    fi
}

# Function to restore database
restore_database() {
    local backup_file=$1
    
    if [ -z "$backup_file" ]; then
        echo -e "${RED}❌ Please provide backup file path${NC}"
        echo -e "${YELLOW}Usage: $0 restore-db /path/to/backup.gz${NC}"
        exit 1
    fi
    
    if [ ! -f "$backup_file" ]; then
        echo -e "${RED}❌ Backup file not found: $backup_file${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}⚠️  This will overwrite the current database. Are you sure? [y/N]${NC}"
    read -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}🔄 Restoring database from backup...${NC}"
        if [ "$(docker-compose ps -q mongodb)" ]; then
            gunzip -c "$backup_file" | docker-compose exec -T mongodb mongorestore --username admin --password password123 --authenticationDatabase admin --gzip --archive --drop
            echo -e "${GREEN}✅ Database restored successfully${NC}"
        else
            echo -e "${RED}❌ MongoDB container is not running${NC}"
        fi
    else
        echo -e "${YELLOW}ℹ️  Restore cancelled${NC}"
    fi
}

# Function to check health
check_health() {
    echo -e "${BLUE}🏥 Checking service health...${NC}"
    echo ""
    
    # Check backend health
    if curl -s http://localhost:3000/health > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Backend: Healthy${NC}"
    else
        echo -e "${RED}❌ Backend: Unhealthy or not responding${NC}"
    fi
    
    # Check MongoDB health
    if [ "$(docker-compose ps -q mongodb)" ]; then
        if docker-compose exec mongodb mongosh --quiet --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ MongoDB: Healthy${NC}"
        else
            echo -e "${RED}❌ MongoDB: Unhealthy${NC}"
        fi
    else
        echo -e "${RED}❌ MongoDB: Not running${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}📊 System Resources:${NC}"
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running. Please start Docker and try again.${NC}"
    exit 1
fi

# Main execution
case "${1:-help}" in
    "logs")
        show_logs "$2"
        ;;
    "shell")
        open_shell "$2"
        ;;
    "restart")
        restart_services "$2"
        ;;
    "rebuild")
        rebuild_services
        ;;
    "cleanup")
        cleanup_docker
        ;;
    "status")
        show_status
        ;;
    "mongo-shell")
        open_mongo_shell
        ;;
    "backup-db")
        backup_database
        ;;
    "restore-db")
        restore_database "$2"
        ;;
    "health")
        check_health
        ;;
    "help"|*)
        show_usage
        ;;
esac