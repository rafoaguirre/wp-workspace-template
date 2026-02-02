#!/bin/bash

# Pull Production Database to Local Development
# This script downloads your production WordPress database and imports it locally

# ============================================
# CONFIGURATION - UPDATE THESE VALUES
# ============================================

PROD_SSH="user@yourserver.com"
PROD_WP_PATH="/var/www/html"
PROD_URL="https://yoursite.com"
LOCAL_URL="http://localhost:8080"

# ============================================
# SCRIPT - DO NOT EDIT BELOW THIS LINE
# ============================================

set -e  # Exit on error

echo "========================================"
echo "Pull Production Database to Local"
echo "========================================"
echo ""

# Confirm action
echo "⚠️  WARNING: This will replace your local database!"
echo "Make sure you have backed up any local data you need."
echo ""
read -p "Continue? (yes/no) " -n 3 -r
echo ""
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Operation cancelled."
    exit 1
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="prod-db-$TIMESTAMP.sql"

echo ""
echo "Step 1: Exporting production database..."
ssh "$PROD_SSH" "cd $PROD_WP_PATH && wp db export - " > "$BACKUP_FILE"
echo "✓ Database exported to $BACKUP_FILE"

echo ""
echo "Step 2: Importing to local database..."
docker-compose exec -T db mysql -u root -prootpassword wordpress < "$BACKUP_FILE"
echo "✓ Database imported"

echo ""
echo "Step 3: Updating URLs for local environment..."
docker-compose exec wpcli wp search-replace "$PROD_URL" "$LOCAL_URL" --all-tables
echo "✓ URLs updated"

echo ""
echo "========================================"
echo "Database sync completed!"
echo "========================================"
echo ""
echo "Your local site now has production data."
echo "Access it at: $LOCAL_URL"
echo "Backup saved at: $BACKUP_FILE"
