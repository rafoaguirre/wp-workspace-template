# WordPress Development Environment with Docker

A Docker-based WordPress development environment focused on theme and plugin development with easy deployment to production.

## Features

- **WordPress** (PHP 8.2-FPM) with custom configuration
- **MySQL 8.0** with persistent database
- **Nginx** web server (Alpine)
- **phpMyAdmin** for database management
- **WP-CLI** for command-line operations
- **Xdebug 3.2** pre-configured for VS Code debugging
- **MailHog** for email testing (catches all outgoing emails)
- **Composer** included for dependency management
- Proper volume sharing between containers
- Optimized PHP settings for development
- VS Code debugging configuration included
- Easy configuration with environment variables

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed
- Basic knowledge of WordPress development
- Terminal/Command line familiarity

## Quick Start

1. **Clone or use this template**
   ```bash
   # If cloning from a repository
   git clone <your-repo-url>
   cd your-project
   ```

2. **Start the environment** (one command does it all!)
   ```bash
   ./start.sh
   ```
   
   The script will:
   - ✅ Check Docker is running
   - ✅ Check for port conflicts
   - ✅ Build Docker images
   - ✅ Start all services
   - ✅ Show you access URLs

3. **Access your services**
   - 🌐 WordPress: http://localhost:8080
   - 🗄️ phpMyAdmin: http://localhost:8081
   - 📧 MailHog: http://localhost:8025 (email testing)

4. **Complete WordPress installation**
   - Open http://localhost:8080 in your browser
   - Follow the WordPress setup wizard
   - Choose site title, username, and password
   - All emails are captured by MailHog (no real emails sent)

**That's it!** Start developing your theme or plugin in `wp-content/`.

## Configuration

### Environment Variables

Edit the `.env` file to customize your setup:

```bash
# Database configuration
DB_NAME=wordpress
DB_USER=wordpress
DB_PASSWORD=wordpress
DB_ROOT_PASSWORD=rootpassword

# Debug mode (1 = on, 0 = off)
WP_DEBUG=1

# Port configuration
NGINX_PORT=8080
PMA_PORT=8081
```

### Directory Structure

```
your-project/
├── docker-compose.yml      # Docker services configuration
├── docker/
│   └── wordpress/
│       ├── Dockerfile     # Custom WordPress image with Xdebug
│       └── php.ini        # Custom PHP configuration
├── nginx/
│   └── default.conf       # Nginx configuration
├── .vscode/
│   ├── launch.json        # Xdebug debugging configuration
│   └── extensions.json    # Recommended VS Code extensions
├── wp-content/
│   ├── themes/            # Your custom themes (mounted)
│   ├── plugins/           # Your custom plugins (mounted)
│   └── uploads/           # Media uploads (mounted)
├── db-init/               # SQL dumps for initial database (optional)
└── scripts/               # Deployment helper scripts
│   └── uploads/           # Media uploads (mounted)
└── db-init/               # SQL dumps for initial database (optional)
```

## Development Workflow

### Working on Themes and Plugins

All your development files are in the `wp-content` directory:


### Debugging with Xdebug

This setup includes Xdebug 3.2 pre-configured for VS Code:

1. **Install recommended extensions** (VS Code will prompt you)
   - PHP Debug
   - PHP Intelephense

2. **Set a breakpoint** in your theme or plugin PHP file

3. **Start debugging**
   - Press `F5` or go to Run > Start Debugging
   - Navigate to your WordPress site
   - VS Code will stop at your breakpoints

4. **Debug configuration** is in `.vscode/launch.json`

### Email Testing with MailHog

All emails sent by WordPress are caught by MailHog:

1. Trigger an email in WordPress (password reset, new user, etc.)
2. Open MailHog at http://localhost:8025
3. View the email content, headers, and HTML/text versions
4. No real emails are sent during development

### Using Composer

Composer is available inside the WordPress container:

```bash
# Access the WordPress container
docker-compose exec wordpress bash

# Inside the container
composer require vendor/package
composer install
composer update
```

### WordPress Coding Standards (WPCS)

This setup includes WordPress Coding Standards to maintain code quality:

**First-time setup:**
```bash
chmod +x scripts/setup-wpcs.sh
./scripts/setup-wpcs.sh
```

**Check your code:**
```bash
# Check themes
docker-compose exec wordpress composer check-themes

# Check plugins
docker-compose exec wordpress composer check-plugins

# Auto-fix issues
docker-compose exec wordpress composer fix-themes
docker-compose exec wordpress composer fix-plugins
```

**VS Code Integration:**
- Install recommended extensions when prompted
- PHPCS will check your code automatically on save
- Errors/warnings appear in the Problems panel
- Configure your text domain in `phpcs.xml`
```bash
wp-content/
├── themes/
│   └── your-custom-theme/
├── plugins/
│   └── your-custom-plugin/
└── uploads/
```

Changes you make locally are immediately reflected in the Docker container.

### Using WP-CLI

Execute WP-CLI commands:

```bash
# Example: Install a plugin
docker-compose exec wpcli wp plugin install contact-form-7 --activate

# List all plugins
docker-compose exec wpcli wp plugin list

# Update WordPress core
docker-compose exec wpcli wp core update

# Export database
docker-compose exec wpcli wp db export - > backup.sql

# Import database
docker-compose exec wpcli wp db import backup.sql
```

### Database Management

**Using phpMyAdmin:**
- Access: http://localhost:8081
- Server: `db`
- Username: `wordpress` (or `root`)
- Password: `wordpress` (or `rootpassword`)

**Export database:**
```bash
docker-compose exec db mysqldump -u root -prootpassword wordpress > backup.sql
```

**Import database:**
```bash
docker-compose exec -T db mysql -u root -prootpassword wordpress < backup.sql
```

### Stopping and Starting

```bash
# Stop all services
docker-compose stop

# Start services (if already built)
docker-compose start

# Restart everything (rebuild if needed)
./start.sh

# Stop and remove containers (database persists in volumes)
docker-compose down

# Remove everything including database volumes (⚠️ destroys data)
docker-compose down -v
```

## Deployment to Production

### Method 1: Manual Deployment (FTP/SFTP)

1. **Export your theme/plugin files**
   ```bash
   # Zip your theme
   cd wp-content/themes
   zip -r your-theme.zip your-theme/
   
   # Zip your plugin
   cd wp-content/plugins
   zip -r your-plugin.zip your-plugin/
   ```

2. **Upload to production server**
   - Upload theme to: `/wp-content/themes/`
   - Upload plugin to: `/wp-content/plugins/`

3. **Activate on production**
   - Log in to WordPress admin
   - Activate your theme/plugin

### Method 2: Git Deployment

1. **Initialize Git repository (if not done)**
   ```bash
   git init
   git add wp-content/themes/ wp-content/plugins/
   git commit -m "Initial commit"
   ```

2. **Push to remote repository**
   ```bash
   git remote add origin <your-repo-url>
   git push -u origin main
   ```

3. **On production server**
   ```bash
   cd /path/to/wordpress/wp-content
   git clone <your-repo-url> .
   # Or pull updates
   git pull origin main
   ```

### Method 3: WP-CLI Deployment Script

Create a deployment script `deploy.sh`:

```bash
#!/bin/bash

# Configuration
PROD_SSH="user@yourserver.com"
PROD_PATH="/var/www/html/wp-content"
LOCAL_THEME="wp-content/themes/your-theme"
LOCAL_PLUGIN="wp-content/plugins/your-plugin"

# Sync theme
rsync -avz --delete $LOCAL_THEME/ $PROD_SSH:$PROD_PATH/themes/your-theme/

# Sync plugin
rsync -avz --delete $LOCAL_PLUGIN/ $PROD_SSH:$PROD_PATH/plugins/your-plugin/

echo "Deployment complete!"
```

Make it executable and run:
```bash
chmod +x deploy.sh
./deploy.sh
```
, 8081, or 8025 is already in use, change it in `.env`:
```bash
NGINX_PORT=8082
PMA_PORT=8083
MAILHOG_WEB_PORT=8026
```
Then restart: `docker-compose down && docker-compose up -d`

### Permission issues
If you encounter permission errors:
```bash
sudo chown -R $(whoami):$(whoami) wp-content/
```

Or fix inside container:
```bash
docker-compose exec wordpress chown -R www-data:www-data /var/www/html/wp-content
```

### Xdebug not working
1. Make sure the PHP Debug extension is installed in VS Code
2. Check Xdebug is loaded:
   ```bash
   docker-compose exec wordpress php -v
   # Should show "with Xdebug v3.2.2"
   ```
3. Check Xdebug log:
   ```bash
   docker-compose exec wordpress tail -f /tmp/xdebug.log
   ```
4. Verify port 9003 is not blocked by firewall

### Database connection issues
Make sure the database is healthy:
```bash
docker-compose ps
```
All services should show "Up (healthy)" status.

### MailHog not catching emails
1. Check MailHog is running: http://localhost:8025
2. Verify WordPress is configured correctly:
   ```bash
   docker-compose exec wordpress php -i | grep sendmail_path
   # Should show: sendmail_path => /usr/sbin/sendmail -t -i -S mailhog:1025
   ```

### Rebuild containers after configuration changes
If you modify Dockerfile or php.ini:
```bash
docker-compose down
docker-compose build --no-cache wordpress
docker-compose up -d
```

### Reset everything
If things go wrong, reset completely:
```bash
docker-compose down -v
rm -rf wp-content/*c -T db mysql -u root -prootpassword wordpress < prod-backup.sql

# Update URLs for local environment
docker-compose exec wpcli wp search-replace 'https://yoursite.com' 'http://localhost:8080' --all-tables
```

**Upload local database to production (CAREFUL!):**

```bash
# Export local database
docker-compose exec db mysqldump -u root -prootpassword wordpress > local-backup.sql

# Upload to production
scp local-backup.sql user@yourserver.com:/path/to/

# On production server (backup first!)
wp db export prod-safety-backup.sql
wp db import local-backup.sql
wp search-replace 'http://localhost:8080' 'https://yoursite.com' --all-tables
```

## Troubleshooting

### Port already in use
The `start.sh` script checks for port conflicts automatically. If you see warnings:

1. **Change the ports** - Edit `.env`:
   ```bash
   NGINX_PORT=8082
   PMA_PORT=8083
   MAILHOG_WEB_PORT=8026
   ```
   Then restart: `docker-compose down && ./start.sh`

2. **Stop conflicting services** - Find and stop what's using the port:
   ```bash
   # macOS/Linux - example for port 8080
   lsof -ti:8080 | xargs kill -9
   ```

### Permission issues
If you encounter permission errors:
```bash
sudo chown -R $(whoami):$(whoami) wp-content/
```

### Database connection issues
Make sure the database is healthy:
```bash
docker-compose ps
```
All services should show "Up" status.

### Reset everything
If things go wrong, reset completely:
```bash
docker-compose down -v
rm -rf wp-content/
docker-compose up -d
```

## Additional Resources

- [WordPress Documentation](https://wordpress.org/documentation/)
- [WP-CLI Documentation](https://wp-cli.org/)
- [Docker Documentation](https://docs.docker.com/)
- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/)

## License

This development environment configuration is open source. WordPress itself is licensed under GPL v2 or later.
