#!/bin/bash

# WordPress Docker Development Environment - Quick Start
# ======================================================

set -e  # Exit on error

echo "🚀 WordPress Docker Development Environment"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running!${NC}"
    echo "Please start Docker Desktop and try again."
    exit 1
fi

echo -e "${GREEN}✅ Docker is running${NC}"
echo ""

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ docker-compose not found!${NC}"
    exit 1
fi

echo -e "${GREEN}✅ docker-compose is available${NC}"
echo ""

# Check for port conflicts
echo "🔍 Checking for port conflicts..."
PORTS=(8080 8081 8025 3306)
PORT_NAMES=("WordPress" "phpMyAdmin" "MailHog" "MySQL")
CONFLICTS=0

for i in "${!PORTS[@]}"; do
    if lsof -Pi :${PORTS[$i]} -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        echo -e "${YELLOW}⚠️  Port ${PORTS[$i]} (${PORT_NAMES[$i]}) is already in use${NC}"
        CONFLICTS=1
    else
        echo -e "${GREEN}✅ Port ${PORTS[$i]} (${PORT_NAMES[$i]}) is available${NC}"
    fi
done

if [ $CONFLICTS -eq 1 ]; then
    echo ""
    echo -e "${YELLOW}⚠️  Some ports are in use. You can either:${NC}"
    echo "   1. Stop the services using those ports"
    echo "   2. Edit .env to change the ports"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo ""
echo "🔨 Building Docker images (this may take 2-5 minutes on first run)..."
docker-compose build

echo ""
echo "🚀 Starting all services..."
docker-compose up -d

echo ""
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check if all containers are running
echo ""
echo "📊 Container Status:"
docker-compose ps

echo ""
echo "=========================================="
echo -e "${GREEN}🎉 Setup Complete!${NC}"
echo "=========================================="
echo ""
echo "📍 Access your services:"
echo ""
echo "   🌐 WordPress:   http://localhost:8080"
echo "   🗄️  phpMyAdmin:  http://localhost:8081"
echo "   📧 MailHog:     http://localhost:8025"
echo ""
echo "🔧 Useful Commands:"
echo ""
echo "   # View logs"
echo "   docker-compose logs -f"
echo ""
echo "   # Stop all services"
echo "   docker-compose stop"
echo ""
echo "   # Start all services"
echo "   docker-compose start"
echo ""
echo "   # Restart a service"
echo "   docker-compose restart wordpress"
echo ""
echo "   # Run WP-CLI commands"
echo "   docker-compose exec wpcli wp plugin list"
echo ""
echo "   # Access WordPress container"
echo "   docker-compose exec wordpress bash"
echo ""
echo "   # Setup WordPress Coding Standards"
echo "   chmod +x scripts/setup-wpcs.sh && ./scripts/setup-wpcs.sh"
echo ""
echo "📚 Documentation:"
echo "   README.md          - Complete guide"
echo "   SETUP-GUIDE.md     - Quick start guide"
echo "   PRE-FLIGHT-CHECK.md - Testing checklist"
echo ""
echo -e "${GREEN}Next Step: Open http://localhost:8080 to install WordPress!${NC}"
echo ""
