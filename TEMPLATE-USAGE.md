# TEMPLATE: WordPress Docker Development Environment

This is a reusable template for setting up WordPress development environments. Clone this for each new WordPress project.

## Quick Start for New Projects

1. **Clone this template**
   ```bash
   git clone <this-repo-url> my-new-wordpress-project
   cd my-new-wordpress-project
   ```

2. **Customize for your project**
   ```bash
   # Update .env with your project-specific settings
   nano .env
   
   # Update container names in docker-compose.yml (optional)
   # Change: wp-workspace-template-* to: my-project-*
   ```

3. **Start development**
   ```bash
   ./start.sh
   ```

4. **Install WordPress**
   - Open http://localhost:8080
   - Complete WordPress installation

5. **Start coding**
   - Add your theme to `wp-content/themes/`
   - Add your plugins to `wp-content/plugins/`
   - Changes reflect immediately!

## Using This Template for Multiple Projects

### Recommended Workflow

**Option 1: Clone for Each Project**
```bash
# Project 1
git clone <template-repo> client-site-1
cd client-site-1
# Update .env ports if needed: NGINX_PORT=8080
./start.sh  # Automatically checks for port conflicts

# Project 2 (different ports!)
git clone <template-repo> client-site-2
cd client-site-2
# Update .env ports: NGINX_PORT=8082, PMA_PORT=8083, etc.
./start.sh  # Will warn if ports are in use

# Project 3
git clone <template-repo> client-site-3
cd client-site-3
# Update .env ports: NGINX_PORT=8084, PMA_PORT=8085, etc.
./start.sh
```

**All three sites can run simultaneously with different ports!**

### Container Naming Convention

To avoid conflicts when running multiple sites, update container names in `docker-compose.yml`:

```yaml
# Change from:
container_name: wp-workspace-template-wordpress

# To something unique:
container_name: clientname-wordpress
```

### Port Management for Multiple Sites

Edit `.env` for each project:

| Project | NGINX_PORT | PMA_PORT | MAILHOG_WEB_PORT | DB_PORT |
|---------|------------|----------|------------------|---------|
| Site 1  | 8080       | 8081     | 8025             | 3306    |
| Site 2  | 8082       | 8083     | 8026             | 3307    |
| Site 3  | 8084       | 8085     | 8027             | 3308    |

### Customizing Each Project

1. **Update container names** in `docker-compose.yml`
2. **Change ports** in `.env`
3. **Update documentation** in README (project-specific)
4. **Customize phpcs.xml** (update text domain and prefix)
5. **Update composer.json** name field

## Template Maintenance

### Keep Your Template Updated

In your template repository:
```bash
# Update Docker images
docker-compose pull

# Rebuild with latest versions
docker-compose build --no-cache

# Test to ensure everything works
docker-compose up -d
```

### Syncing Updates to Projects

When you improve the template:

```bash
# In project directory
git remote add template <template-repo-url>
git fetch template
git merge template/main --allow-unrelated-histories

# Resolve conflicts (usually just .env and container names)
# Then commit the updates
```

## Best Practices for Template Use

### DO Commit
✅ Docker configuration (docker-compose.yml, Dockerfile)
✅ Empty directory structure (wp-content/themes/, plugins/, uploads/)
✅ Configuration files (.gitignore, phpcs.xml, composer.json)
✅ Documentation (README, guides)
✅ VS Code settings (.vscode/)
✅ Helper scripts (start.sh, setup scripts)

### DON'T Commit
❌ Environment variables (.env)
❌ Database data (*.sql, db_data/)
❌ WordPress uploads (wp-content/uploads/*)
❌ Vendor dependencies (vendor/, node_modules/)
❌ Docker volumes (wordpress_data/, db_data/)
❌ IDE workspace files
❌ Log files

## Project-Specific Customization

### After Cloning Template

1. **Initialize as new repo**
   ```bash
   rm -rf .git
   git init
   git add .
   git commit -m "Initial commit from WordPress Docker template"
   git remote add origin <your-project-repo>
   git push -u origin main
   ```

2. **Update project name**
   - composer.json: "name" field
   - README.md: Project title and description
   - docker-compose.yml: container_name fields

3. **Configure for project**
   - phpcs.xml: text_domain and prefix
   - .env: Database credentials (use strong passwords!)
   - nginx/default.conf: server_name if needed

## Features Included

This template includes:
- ✅ WordPress (PHP 8.2-FPM)
- ✅ MySQL 8.0
- ✅ Nginx
- ✅ phpMyAdmin
- ✅ WP-CLI
- ✅ Xdebug for debugging
- ✅ MailHog for email testing
- ✅ WordPress Coding Standards
- ✅ Composer support
- ✅ VS Code integration

## Support

See the full documentation:
- README.md - Complete setup guide
- SETUP-GUIDE.md - Quick reference
- TEMPLATE-USAGE.md - How to use this as a template

## License

This template is open source. WordPress is GPL v2 or later.
