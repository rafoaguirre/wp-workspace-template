# Deployment Script for WordPress

This directory contains helper scripts for deploying your WordPress theme and plugins to production.

## deploy.sh

A simple rsync-based deployment script. Configure it with your production server details before using.

### Usage

1. Edit `deploy.sh` with your server details
2. Make it executable: `chmod +x deploy.sh`
3. Run: `./deploy.sh`

## Database Sync Scripts

Use these carefully - always backup production before syncing!

### pull-prod-db.sh
Downloads production database to local environment

### push-to-prod.sh
Uploads local database to production (USE WITH CAUTION!)
