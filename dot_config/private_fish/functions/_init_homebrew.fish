#!/usr/bin/env fish

function _init_homebrew -d "Initialize Homebrew environment"
    # Only initialize once per session
    if test "$homebrew_initialized" = true
        return 0
    end

    # Skip if Homebrew not available
    if not command -q brew
        return 1
    end

    set -l cache_file "$__fish_cache_dir/homebrew_shellenv"
    
    # Use cached shellenv if available, otherwise create it
    if test -f "$cache_file"
        source "$cache_file"
    else
        # Create cache directory if needed
        mkdir -p "$__fish_cache_dir"
        
        # Generate and cache shellenv
        brew shellenv > "$cache_file"
        source "$cache_file"
    end

    # Add completions if not already added
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
    rm -f "$__fish_cache_dir/homebrew_shellenv"
    _init_homebrew
    echo "🍺 Homebrew configuration reloaded"
end
