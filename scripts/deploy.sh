#!/bin/bash

# WordPress Production Deployment Script
# This script syncs your theme and plugins to production using rsync

# ============================================
# CONFIGURATION - UPDATE THESE VALUES
# ============================================

PROD_SSH="user@yourserver.com"
PROD_PATH="/var/www/html/wp-content"

# Theme to deploy (leave empty if not deploying a theme)
LOCAL_THEME="wp-content/themes/your-theme-name"

# Plugins to deploy (space-separated list, leave empty if none)
LOCAL_PLUGINS=(
    "wp-content/plugins/your-plugin-name"
)

# ============================================
# SCRIPT - DO NOT EDIT BELOW THIS LINE
# ============================================

set -e  # Exit on error

echo "================================"
echo "WordPress Production Deployment"
echo "================================"
echo ""

# Check if rsync is available
if ! command -v rsync &> /dev/null; then
    echo "Error: rsync is not installed. Please install it first."
    exit 1
fi

# Confirm deployment
echo "You are about to deploy to: $PROD_SSH:$PROD_PATH"
echo ""
read -p "Are you sure you want to continue? (yes/no) " -n 3 -r
echo ""
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Deployment cancelled."
    exit 1
fi

echo ""
echo "Starting deployment..."
echo ""

# Deploy theme
if [ -n "$LOCAL_THEME" ] && [ -d "$LOCAL_THEME" ]; then
    THEME_NAME=$(basename "$LOCAL_THEME")
    echo "Deploying theme: $THEME_NAME"
    rsync -avz --delete \
        --exclude 'node_modules' \
        --exclude '.git' \
        --exclude '.DS_Store' \
        --exclude '*.log' \
        "$LOCAL_THEME/" "$PROD_SSH:$PROD_PATH/themes/$THEME_NAME/"
    echo "✓ Theme deployed successfully"
    echo ""
else
    echo "No theme to deploy or theme directory not found"
    echo ""
fi

# Deploy plugins
if [ ${#LOCAL_PLUGINS[@]} -gt 0 ]; then
    for PLUGIN in "${LOCAL_PLUGINS[@]}"; do
        if [ -d "$PLUGIN" ]; then
            PLUGIN_NAME=$(basename "$PLUGIN")
            echo "Deploying plugin: $PLUGIN_NAME"
            rsync -avz --delete \
                --exclude 'node_modules' \
                --exclude '.git' \
                --exclude '.DS_Store' \
                --exclude '*.log' \
                "$PLUGIN/" "$PROD_SSH:$PROD_PATH/plugins/$PLUGIN_NAME/"
            echo "✓ Plugin deployed successfully"
            echo ""
        else
            echo "⚠ Plugin not found: $PLUGIN"
            echo ""
        fi
    done
else
    echo "No plugins to deploy"
    echo ""
fi

echo "================================"
echo "Deployment completed!"
echo "================================"
echo ""
echo "Next steps:"
echo "1. Test your production site"
echo "2. Clear any caching plugins"
echo "3. Check for errors in WordPress admin"
