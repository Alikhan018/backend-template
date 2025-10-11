#!/bin/bash
# MongoDB Docker Management Script
# This script helps manage MongoDB in Docker for development

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

CONTAINER_NAME="backend-template-mongodb-dev"
MONGO_PORT="27017"
MONGO_USERNAME="admin"
MONGO_PASSWORD="password123"
MONGO_DATABASE="backend_template_dev"

echo -e "${BLUE}🍃 MongoDB Docker Manager${NC}"
echo ""

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        echo -e "${RED}❌ Docker is not running. Please start Docker and try again.${NC}"
        exit 1
    fi
}

# Function to start MongoDB
start_mongo() {
    echo -e "${BLUE}🚀 Starting MongoDB container...${NC}"
    
    if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        echo -e "${YELLOW}⚠️  MongoDB container is already running${NC}"
        show_connection_info
        return
    fi
    
    # Remove existing stopped container
    if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
        docker rm $CONTAINER_NAME > /dev/null 2>&1
    fi
    
    # Start new MongoDB container
    docker run -d \
        --name $CONTAINER_NAME \
        -p $MONGO_PORT:27017 \
        -e MONGO_INITDB_ROOT_USERNAME=$MONGO_USERNAME \
        -e MONGO_INITDB_ROOT_PASSWORD=$MONGO_PASSWORD \
        -e MONGO_INITDB_DATABASE=$MONGO_DATABASE \
        -v mongodb_dev_data:/data/db \
        mongo:7-jammy > /dev/null
    
    echo -e "${GREEN}✅ MongoDB container started successfully!${NC}"
    show_connection_info
}

# Function to stop MongoDB
stop_mongo() {
    echo -e "${YELLOW}🛑 Stopping MongoDB container...${NC}"
    
    if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        docker stop $CONTAINER_NAME > /dev/null
        docker rm $CONTAINER_NAME > /dev/null
        echo -e "${GREEN}✅ MongoDB container stopped${NC}"
    else
        echo -e "${YELLOW}⚠️  MongoDB container is not running${NC}"
    fi
}

# Function to show connection information
show_connection_info() {
    echo -e "${BLUE}📝 Connection Information:${NC}"
    echo "   - Host: localhost"
    echo "   - Port: $MONGO_PORT"
    echo "   - Username: $MONGO_USERNAME"
    echo "   - Password: $MONGO_PASSWORD"
    echo "   - Database: $MONGO_DATABASE"
    echo "   - Connection URI: mongodb://$MONGO_USERNAME:$MONGO_PASSWORD@localhost:$MONGO_PORT/$MONGO_DATABASE?authSource=admin"
    echo ""
    echo -e "${YELLOW}💡 Useful commands:${NC}"
    echo "   - Connect with mongo shell: docker exec -it $CONTAINER_NAME mongosh -u $MONGO_USERNAME -p $MONGO_PASSWORD --authenticationDatabase admin"
    echo "   - View container logs: docker logs $CONTAINER_NAME"
    echo "   - Stop MongoDB: $0 stop"
}

# Function to show status
show_status() {
    if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        echo -e "${GREEN}✅ MongoDB container is running${NC}"
        show_connection_info
    else
        echo -e "${RED}❌ MongoDB container is not running${NC}"
        echo -e "${YELLOW}💡 Start it with: $0 start${NC}"
    fi
}

# Function to show logs
show_logs() {
    if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
        echo -e "${BLUE}📋 MongoDB container logs:${NC}"
        docker logs -f $CONTAINER_NAME
    else
        echo -e "${RED}❌ MongoDB container is not running${NC}"
    fi
}

# Main execution
check_docker

case "${1:-start}" in
    "start")
        start_mongo
        ;;
    "stop")
        stop_mongo
        ;;
    "status")
        show_status
        ;;
    "logs")
        show_logs
        ;;
    "restart")
        stop_mongo
        sleep 2
        start_mongo
        ;;
    *)
        echo -e "${RED}❌ Invalid command: $1${NC}"
        echo -e "${YELLOW}Usage: $0 [start|stop|status|logs|restart]${NC}"
        exit 1
        ;;
esac
