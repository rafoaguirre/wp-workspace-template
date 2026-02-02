# Changelog

All notable changes to this WordPress Docker Development Template will be documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.0.0] - 2026-02-01

### Added
- Initial release of WordPress Docker development template
- WordPress with PHP 8.2-FPM
- MySQL 8.0 with persistence
- Nginx web server (Alpine)
- phpMyAdmin for database management
- WP-CLI for command-line operations
- Xdebug 3.2 for debugging
- MailHog for email testing
- Composer with WordPress Coding Standards (WPCS)
- VS Code integration (launch.json, settings.json, extensions.json)
- Custom PHP configuration (256MB memory, 100MB uploads)
- Automated start script
- Deployment helper scripts
- Comprehensive documentation

### Features
- Shared volume architecture (wordpress_data) for proper Nginx/WordPress file access
- Health checks for MySQL
- Auto-import SQL files from db-init/
- Environment variable configuration via .env
- Git-ready with proper .gitignore
- Multi-site template support (different ports)
- WordPress Coding Standards integration
- Email testing (all emails caught by MailHog)
- Professional debugging with Xdebug

### Documentation
- README.md - Complete setup and usage guide
- TEMPLATE-USAGE.md - How to use as template for multiple projects
- SETUP-GUIDE.md - Quick start reference
- wp-config-custom.php - WordPress configuration template
