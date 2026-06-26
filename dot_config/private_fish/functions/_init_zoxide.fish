#!/usr/bin/env fish

function _init_zoxide -d "Initialize zoxide with version-aware caching"
    if test "$zoxide_initialized" = true
        return 0
    end

    if not command -q zoxide
        echo "⚠️  Zoxide not found. Install with: brew install zoxide"
        return 1
    end

    set -l cache_file zoxide_init.fish

    _init_cache_ensure -n $cache_file -m "🚀 Generating zoxide cache..." -g "zoxide init fish" -- zoxide fish

    source "$__fish_cache_dir/$cache_file"
    set -g zoxide_initialized true
end

function reload_zoxide -d "Reload zoxide configuration"
    set -e zoxide_initialized
    _init_cache_invalidate -n zoxide_init.fish
    _init_zoxide
    echo "🚀 Zoxide reloaded"
end
