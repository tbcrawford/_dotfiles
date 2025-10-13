#!/usr/bin/env fish

function _init_zoxide -d "Initialize zoxide with permanent caching"
    # Only initialize once per session
    if test "$zoxide_initialized" = true
        return 0
    end

    # Check if zoxide is available
    if not command -q zoxide
        echo "⚠️  Zoxide not found. Install with: brew install zoxide"
        return 1
    end

    set -l cache_file $__fish_cache_dir/zoxide_init.fish

    # Generate cache if it doesn't exist
    if not test -f $cache_file
        echo "🚀 Generating zoxide cache..."
        mkdir -p $__fish_cache_dir
        zoxide init fish >$cache_file
    end

    # Source the cached init file
    source $cache_file
    set -g zoxide_initialized true
end

function reload_zoxide -d "Reload zoxide configuration"
    set -e zoxide_initialized
    set -l cache_file $__fish_cache_dir/zoxide_init.fish
    test -f $cache_file && rm $cache_file
    _init_zoxide
    echo "🚀 Zoxide reloaded"
end
