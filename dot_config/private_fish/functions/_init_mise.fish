#!/usr/bin/env fish

function _init_mise -d "Initialize mise with version-aware caching"
    if test "$mise_initialized" = true
        return 0
    end

    if not command -q mise
        return 1
    end

    set -gx MISE_FISH_AUTO_ACTIVATE 0

    set -l cache_file mise_activate.fish

    _init_cache_ensure -n $cache_file -m "🔧 Generating mise cache..." -g "mise activate fish" -- mise

    source "$__fish_cache_dir/$cache_file"
    set -g mise_initialized true
end

function reload_mise -d "Reload mise configuration"
    set -e mise_initialized
    _init_cache_invalidate -n mise_activate.fish
    _init_mise
    echo "🔧 Mise configuration reloaded"
end
