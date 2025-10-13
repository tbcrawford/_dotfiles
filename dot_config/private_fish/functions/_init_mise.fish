#!/usr/bin/env fish

function _init_mise -d "Initialize mise with caching for activate command"
    # Only initialize once per session
    if test "$mise_initialized" = true
        return 0
    end

    # Check if mise is available
    if not command -q mise
        return 1
    end

    # Disable mise auto activation
    set -gx MISE_FISH_AUTO_ACTIVATE 0

    # Cache and source activate command (includes hook-env functionality)
    set -l activate_cache "$__fish_cache_dir/mise_activate.fish"
    if not test -f "$activate_cache"
        mkdir -p "$__fish_cache_dir"
        mise activate fish > "$activate_cache"
    end
    source "$activate_cache"

    set -g mise_initialized true
end

function reload_mise -d "Reload mise configuration"
    set -e mise_initialized
    set -l activate_cache "$__fish_cache_dir/mise_activate.fish"
    
    # Remove activate cache file
    test -f "$activate_cache" && rm "$activate_cache"
    
    # Reinitialize
    _init_mise
    echo "🔧 Mise configuration reloaded"
end
