#!/usr/bin/env fish

function _init_starship -d "Initialize starship prompt with version-aware caching"
    if test "$starship_initialized" = true
        return 0
    end

    if not command -q starship
        echo "⚠️  Starship not found. Install with: brew install starship"
        return 1
    end

    set -gx STARSHIP_CONFIG $__fish_config_dir/themes/starship.toml

    set -l cache_file starship_init.fish

    _init_cache_ensure -n $cache_file -m "🚀 Generating starship cache..." \
        -g "starship init fish --print-full-init" -- starship

    source "$__fish_cache_dir/$cache_file"

    if functions -q enable_transience
        enable_transience
    end

    set -g starship_initialized true
end

function reload_starship -d "Reload starship configuration"
    set -e starship_initialized
    _init_cache_invalidate -n starship_init.fish
    _init_starship
    echo "🚀 Starship reloaded"
end

function refresh_starship_cache -d "Refresh starship cache"
    reload_starship
end
