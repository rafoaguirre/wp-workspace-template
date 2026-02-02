# Changelog

All notable changes to this WordPress Docker Development Template will be documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Fixed
- WordPress 6.9 theme installer compatibility issues
- Mount theme/plugin directories to Nginx for serving static assets (screenshots, JS, CSS)
- Add Underscore.js compatibility plugin to restore deprecated _.pluck() method
- Fix empty themes string initialization on theme-install page preventing API calls
- Resolve 404 errors for theme screenshots
- Fix Backbone model initialization errors in theme browser

### Changed
- Updated .gitignore to exclude experimental themes and plugins while keeping core template files
- Simplified README Quick Start to emphasize ./start.sh workflow
- Updated README troubleshooting to reflect start.sh automatic port checking

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
