#!/bin/bash
set -e

# Configuration
IMAGE_NAME="backend-template"
DOCKERHUB_USERNAME="alikhan018"
ENV=${1:-development}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Backend Template Docker Setup${NC}"
echo -e "Environment: ${YELLOW}$ENV${NC}"
echo ""

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        echo -e "${RED}❌ Docker is not running. Please start Docker and try again.${NC}"
        exit 1
    fi
}

# Function to cleanup existing containers
cleanup() {
    echo -e "${YELLOW}🧹 Cleaning up existing containers...${NC}"
    
    if [ "$ENV" = "production" ]; then
        docker-compose -f docker-compose.prod.yaml down --remove-orphans 2>/dev/null || true
    else
        docker-compose down --remove-orphans 2>/dev/null || true
    fi
    
    # Remove dangling images
    docker image prune -f > /dev/null 2>&1
}

# Function to setup development environment
setup_development() {
    echo -e "${BLUE}🔧 Setting up development environment...${NC}"
    
    # Create .env file if it doesn't exist
    if [ ! -f .env ]; then
        cp .env.example .env
        echo -e "${GREEN}✅ Created .env file from .env.example${NC}"
    fi
    
    # Start services
    docker-compose up --build -d
    
    echo -e "${GREEN}✅ Development environment is running!${NC}"
    echo -e "${BLUE}📝 Services:${NC}"
    echo "   - Backend: http://localhost:3000"
    echo "   - MongoDB: mongodb://admin:password123@127.0.0.1:27017/backend_template_dev"
    echo ""
    echo -e "${YELLOW}💡 Useful commands:${NC}"
    echo "   - View logs: docker-compose logs -f"
    echo "   - Stop services: docker-compose down"
    echo "   - Rebuild: docker-compose up --build"
}

# Function to setup production environment
setup_production() {
    echo -e "${BLUE}🚀 Setting up production environment...${NC}"
    
    # Check for required environment variables
    if [ ! -f .env.production ]; then
        echo -e "${RED}❌ .env.production file not found. Please create it first.${NC}"
        exit 1
    fi
    
    # Load production environment variables
    export $(cat .env.production | grep -v '^#' | xargs)
    
    # Build and start services
    docker-compose -f docker-compose.prod.yaml up --build -d
    
    # Tag and push to Docker Hub (optional)
    if [ "$PUSH_TO_HUB" = "true" ]; then
        echo -e "${YELLOW}📦 Pushing to Docker Hub...${NC}"
        docker tag $IMAGE_NAME $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
        docker push $DOCKERHUB_USERNAME/$IMAGE_NAME:latest
        echo -e "${GREEN}✅ Pushed to Docker Hub${NC}"
    fi
    
    echo -e "${GREEN}✅ Production environment is running!${NC}"
    echo -e "${BLUE}📝 Services:${NC}"
    echo "   - Backend: http://localhost:${APP_PORT:-3000}"
    echo "   - MongoDB: Check your MONGODB_URI"
}

# Main execution
check_docker
cleanup

case $ENV in
    "development" | "dev")
        setup_development
        ;;
    "production" | "prod")
        setup_production
        ;;
    *)
        echo -e "${RED}❌ Invalid environment: $ENV${NC}"
        echo -e "${YELLOW}Usage: $0 [development|production]${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}🎉 Setup completed successfully!${NC}"
