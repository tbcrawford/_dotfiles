#!/usr/bin/env fish

# Simple Fisher initialization following KISS and YAGNI principles
# Maintains all required functionality with minimal complexity

function _init_fisher -d "Initialize Fisher plugin manager"
    # Ultra-fast return if already initialized this session
    test "$fisher_session_init" = true && return 0

    # Set Fisher path
    set -gx fisher_path $__fish_config_dir/.fisher

    # One-time setup check
    if not test "$FISHER_ONCE_COMPLETE" = true
        # Install Fisher if needed
        test -d $fisher_path || _install_fisher || return 1

        # Mark complete
        set -Ux FISHER_ONCE_COMPLETE true
    end

    # Always ensure Fisher paths are added (they may be missing from current session)
    test -d $fisher_path/functions && not contains $fisher_path/functions $fish_function_path && set -p fish_function_path $fisher_path/functions
    test -d $fisher_path/completions && not contains $fisher_path/completions $fish_complete_path && set -p fish_complete_path $fisher_path/completions

    # Load config files (minimal overhead)  
    test -d $fisher_path/conf.d && begin
        for config in $fisher_path/conf.d/*.fish
            test -f $config && source $config
        end
    end

    # Mark session initialized
    set -g fisher_session_init true
end

function _install_fisher
    echo "Installing Fisher..."
    
    # Create directories
    mkdir -p $fisher_path
    touch $__fish_config_dir/fish_plugins

    # Download and install Fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    or return 1

    # Install plugins or Fisher itself
    if test -s $__fish_config_dir/fish_plugins
        fisher update
    else
        fisher install jorgebucaran/fisher
    end
end

function reload_fisher -d "Reload Fisher configuration"
    set -e FISHER_ONCE_COMPLETE
    set -e fisher_session_init
    _init_fisher
    echo "Fisher reloaded"
end