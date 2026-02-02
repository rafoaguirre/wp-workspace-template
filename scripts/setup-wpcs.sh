#!/bin/bash

# Setup WordPress Coding Standards in Docker container
# Run this after first starting your containers

echo "========================================"
echo "WordPress Coding Standards Setup"
echo "========================================"
echo ""

# Check if composer.json exists
if [ ! -f "composer.json" ]; then
    echo "Error: composer.json not found!"
    exit 1
fi

# Install Composer dependencies inside WordPress container
echo "Installing Composer dependencies (WPCS, PHPCS)..."
docker-compose exec wordpress composer install

# Verify installation
echo ""
echo "Verifying WPCS installation..."
docker-compose exec wordpress vendor/bin/phpcs -i

echo ""
echo "========================================"
echo "Setup Complete!"
echo "========================================"
echo ""
echo "Available commands:"
echo "  composer check-themes   - Check themes for coding standards"
echo "  composer check-plugins  - Check plugins for coding standards"
echo "  composer fix-themes     - Auto-fix theme code"
echo "  composer fix-plugins    - Auto-fix plugin code"
echo ""
echo "Run inside container:"
echo "  docker-compose exec wordpress composer check-themes"
echo ""
echo "Or from VS Code, phpcs will run automatically on save!"
