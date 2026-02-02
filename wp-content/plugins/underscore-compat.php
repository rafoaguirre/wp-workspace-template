<?php
/**
 * Plugin Name: Underscore.js Compatibility Fix
 * Description: Adds missing _.pluck() method for WordPress 6.9 compatibility
 * Version: 1.0.0
 * Author: Auto-generated
 */

// Add polyfill immediately after underscore loads, before wp-backbone
add_action('admin_print_scripts', function() {
    ?>
    <script type="text/javascript">
    (function() {
        if (typeof _ !== 'undefined' && !_.pluck) {
            _.mixin({
                pluck: function(obj, key) {
                    return _.map(obj, function(value) { 
                        return value ? value[key] : undefined; 
                    });
                }
            });
        }
    })();
    </script>
    <?php
}, -999);

add_action('wp_print_scripts', function() {
    ?>
    <script type="text/javascript">
    (function() {
        if (typeof _ !== 'undefined' && !_.pluck) {
            _.mixin({
                pluck: function(obj, key) {
                    return _.map(obj, function(value) { 
                        return value ? value[key] : undefined; 
                    });
                }
            });
        }
    })();
    </script>
    <?php
}, -999);

// Fix empty themes string on theme-install page
add_action('admin_footer-theme-install.php', function() {
    ?>
    <script type="text/javascript">
    (function($) {
        // Fix empty themes string being passed instead of empty array
        if (window._wpThemeSettings && window._wpThemeSettings.themes === '') {
            window._wpThemeSettings.themes = [];
            console.log('Fixed empty themes string to array');
        }
    })(jQuery);
    </script>
    <?php
}, 1);
