#!/usr/bin/env fish

function _init_homebrew -d "Initialize Homebrew environment"
    if test "$homebrew_initialized" = true
        return 0
    end

    if not command -q brew
        return 1
    end

    set -l cache_file homebrew_shellenv

    _init_cache_ensure -n $cache_file -m "🍺 Generating Homebrew cache..." -g "brew shellenv" -- brew

    source "$__fish_cache_dir/$cache_file"

    if not contains $HOMEBREW_PREFIX/share/fish/completions $fish_complete_path
        set -l completions_dir $HOMEBREW_PREFIX/share/fish/completions
        set -l vendor_completions_dir $HOMEBREW_PREFIX/share/fish/vendor_completions.d

        if test -d "$completions_dir"
            set -g fish_complete_path $completions_dir $fish_complete_path
        end
        if test -d "$vendor_completions_dir"
            set -g fish_complete_path $vendor_completions_dir $fish_complete_path
        end
    end

    set -g homebrew_initialized true
end

function reload_homebrew -d "Reload Homebrew configuration"
    set -e homebrew_initialized
    _init_cache_invalidate -n homebrew_shellenv
    _init_homebrew
    echo "🍺 Homebrew configuration reloaded"
end
