<?php
/**
 * Custom wp-config.php additions for development
 * 
 * This file contains additional WordPress configuration for local development.
 * Place this content in your wp-config.php or include this file.
 * 
 * WordPress core will be in the Docker volume, but you can customize
 * configuration by adding this via WP-CLI or manually.
 */

// ===================================================
// WordPress Debug Settings
// ===================================================

define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', false );
@ini_set( 'display_errors', 0 );

// Enable Script Debug (loads unminified JS/CSS)
define( 'SCRIPT_DEBUG', true );

// Enable Savequeries (log database queries)
define( 'SAVEQUERIES', true );

// ===================================================
// Development Settings
// ===================================================

// Disable auto-updates for development
define( 'AUTOMATIC_UPDATER_DISABLED', true );

// Increase memory limit
define( 'WP_MEMORY_LIMIT', '256M' );
define( 'WP_MAX_MEMORY_LIMIT', '512M' );

// Disable cron for better control
define( 'DISABLE_WP_CRON', false );

// Enable post revisions (adjust as needed)
define( 'WP_POST_REVISIONS', 5 );

// Set autosave interval (in seconds)
define( 'AUTOSAVE_INTERVAL', 180 );

// ===================================================
// File System Settings
// ===================================================

// Force direct file system method
define( 'FS_METHOD', 'direct' );

// ===================================================
// Security (Development Only)
// ===================================================

// Disable file editing from admin
// Uncomment this for production-like testing
// define( 'DISALLOW_FILE_EDIT', true );

// Allow unfiltered uploads (be careful!)
// define( 'ALLOW_UNFILTERED_UPLOADS', true );

// ===================================================
// Email Configuration (MailHog)
// ===================================================

// MailHog is configured in php.ini via sendmail_path
// No additional configuration needed

// ===================================================
// Custom Constants
// ===================================================

// Define your custom constants here
// define( 'MY_CUSTOM_CONSTANT', 'value' );
