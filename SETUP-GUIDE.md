# Quick Setup Guide

## What Was Fixed

### 🔴 Critical Issues Resolved:

1. **Volume Sharing Problem** ✅
   - **Before**: Nginx couldn't serve static files (CSS, JS, images)
   - **After**: Shared `wordpress_data` volume between WordPress and Nginx

2. **WP-CLI Access** ✅
   - **Before**: WP-CLI couldn't access WordPress core files
   - **After**: Full WordPress access via shared volume

3. **No Debugging Tools** ✅
   - **Before**: No way to debug PHP code
   - **After**: Xdebug 3.2 pre-configured with VS Code integration

4. **Email Testing** ✅
   - **Before**: Emails sent to real addresses during development
   - **After**: MailHog catches all emails for safe testing

5. **PHP Configuration** ✅
   - **Before**: Default PHP settings (limited memory, no error display)
   - **After**: Custom php.ini optimized for development

6. **Permission Issues** ✅
   - **Before**: Potential file permission conflicts
   - **After**: Proper user mapping and volume configuration

## New Features Added:

### 1. Xdebug Debugging
- Set breakpoints in VS Code
- Step through WordPress code
- Inspect variables and call stacks
- Pre-configured in `.vscode/launch.json`

### 2. MailHog Email Testing
- Catches all outgoing emails
- View email content at http://localhost:8025
- Test password resets, notifications, etc.
- No real emails sent during development

### 3. Composer Support
- Manage PHP dependencies
- Install packages directly in container
- Useful for theme/plugin development

### 4. Custom PHP Configuration
- 256MB memory limit (up from 128MB)
- 100MB upload limit (up from 2MB)
- Full error reporting enabled
- Extended execution time for imports

### 5. Improved MySQL Setup
- Native password authentication
- Auto-import SQL files from `db-init/` directory
- Better health checks

### 6. VS Code Integration
- Debugging configuration ready to use
- Recommended extensions list
- IntelliSense support

## Key Improvements:

| Area | Before | After |
|------|--------|-------|
| **Static Files** | ❌ Nginx can't serve CSS/JS | ✅ Full WordPress access |
| **Debugging** | ❌ No debugger | ✅ Xdebug + VS Code |
| **Emails** | ❌ Sent to real addresses | ✅ Caught by MailHog |
| **PHP Settings** | ⚠️ Default (limited) | ✅ Optimized for dev |
| **Dependencies** | ❌ No Composer | ✅ Composer included |
| **WP-CLI** | ⚠️ Limited access | ✅ Full WordPress access |
| **Development** | ⚠️ Basic setup | ✅ Production-ready workflow |

## Setup Instructions

1. **First time setup**
   ```bash
   ./start.sh
   ```
   
   The script automatically:
   - Checks Docker is running
   - Detects port conflicts
   - Builds containers
   - Starts all services

2. **Access your sites**
   - WordPress: http://localhost:8080
   - phpMyAdmin: http://localhost:8081
   - MailHog: http://localhost:8025

3. **Start debugging**
   - Open VS Code
   - Install recommended extensions (you'll be prompted)
   - Set a breakpoint in your theme/plugin
   - Press F5 to start debugging

4. **Test emails**
   - Trigger any WordPress email (password reset, etc.)
   - Open http://localhost:8025
   - View the captured email

## Development Workflow

### Theme Development
```bash
# Your theme files are in:
wp-content/themes/your-theme/

# Changes are immediately visible
# Just refresh your browser
```

### Plugin Development
```bash
# Your plugin files are in:
wp-content/plugins/your-plugin/

# Changes are immediately visible
# Refresh browser or WP admin
```

### Debugging PHP Code
```bash
# 1. Set a breakpoint in VS Code (click left of line number)
# 2. Press F5 (Start Debugging)
# 3. Navigate to the page in browser
# 4. VS Code will pause at breakpoint
# 5. Inspect variables, step through code
```

### Using WP-CLI
```bash
# List plugins
docker-compose exec wpcli wp plugin list

# Install a plugin
docker-compose exec wpcli wp plugin install contact-form-7 --activate

# Update WordPress
docker-compose exec wpcli wp core update

# Export database
docker-compose exec wpcli wp db export backup.sql
```

### Managing Emails
```bash
# All WordPress emails go to MailHog
# View them at: http://localhost:8025
# No configuration needed - it just works!
```

## Important Notes

### WordPress Core Files
WordPress core is stored in a Docker volume (`wordpress_data`). This means:
- ✅ Core files are shared between WordPress and Nginx
- ✅ Updates persist across container restarts
- ✅ You can access core files if needed
- ⚠️ Don't commit core files to Git (they're in the volume)

### Your Development Files
Your themes and plugins are mounted from your host:
- ✅ Edit files directly on your Mac
- ✅ Changes are immediately reflected
- ✅ Commit to Git as normal
- ✅ IDE autocomplete works

### Database Persistence
Database is stored in `db_data` volume:
- ✅ Data survives container restarts
- ✅ Data survives container rebuilds
- ⚠️ Only deleted with `docker-compose down -v`

## Comparison: Before vs After

### Before (Original Setup)
```yaml
# WordPress container
volumes:
  - ./wp-content/themes:/var/www/html/wp-content/themes
  - ./wp-content/plugins:/var/www/html/wp-content/plugins
  
# Problems:
# ❌ Nginx couldn't serve static files
# ❌ No debugging tools
# ❌ No email testing
# ❌ WP-CLI had limited access
```

### After (Improved Setup)
```yaml
# WordPress container
volumes:
  - wordpress_data:/var/www/html  # Shared with Nginx
  - ./wp-content/themes:/var/www/html/wp-content/themes
  - ./wp-content/plugins:/var/www/html/wp-content/plugins
  
# Benefits:
# ✅ Nginx can serve all files
# ✅ Xdebug for debugging
# ✅ MailHog for email testing
# ✅ WP-CLI has full access
# ✅ Composer included
# ✅ Custom PHP configuration
```

## When to Rebuild

Rebuild containers when you change:
- Dockerfile
- php.ini
- docker-compose.yml (build section)

```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## Performance Notes

This setup prioritizes **development experience** over performance:
- Xdebug slows down PHP (disable in production)
- Full error reporting increases overhead
- Docker volumes have slight I/O overhead on Mac

For production, you would:
- Disable Xdebug
- Reduce error reporting
- Use optimized PHP settings
- Enable OpCache

## Next Steps

1. **Install WordPress** at http://localhost:8080
2. **Test debugging** by setting a breakpoint
3. **Test email** by requesting password reset
4. **Start developing** your theme/plugin
5. **Read the full README.md** for deployment instructions
