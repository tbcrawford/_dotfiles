#!/usr/bin/env fish

# Simple starship initialization with permanent caching
function _init_starship -d "Initialize starship prompt with caching"
    # Skip if already initialized this session
    if test "$starship_initialized" = true
        return 0
    end

    # Check if starship is available
    if not command -q starship
        echo "⚠️  Starship not found. Install with: brew install starship"
        return 1
    end

    # Set config path
    set -gx STARSHIP_CONFIG $__fish_config_dir/themes/starship.toml

    # Use cache file for starship init
    set -l cache_file $__fish_cache_dir/starship_init.fish
    
    if not test -f $cache_file
        # Generate cache once
        echo "🚀 Generating starship cache..."
        mkdir -p $__fish_cache_dir
        starship init fish --print-full-init >$cache_file
    end

    # Source cached init
    source $cache_file

    # Enable transience if available
    if functions -q enable_transience
        enable_transience
    end

    # Mark as initialized for this session
    set -g starship_initialized true
end

# Utility to refresh cache if needed
function refresh_starship_cache -d "Refresh starship cache"
    if not command -q starship
        echo "❌ Starship not found"
        return 1
    end

    set -l cache_file $__fish_cache_dir/starship_init.fish
    echo "🚀 Refreshing starship cache..."
    mkdir -p $__fish_cache_dir
    starship init fish --print-full-init >$cache_file
    echo "✅ Cache refreshed"
end