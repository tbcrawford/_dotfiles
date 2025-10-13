#!/usr/bin/env fish

# Simple Fish shell initialization

function _init_fish -d "Initialize Fish shell"
    # Only run once per session
    if test "$fish_initialized" = true
        return 0
    end

    # Set up XDG directories
    set -q XDG_CONFIG_HOME || set -gx XDG_CONFIG_HOME ~/.config
    set -q XDG_DATA_HOME || set -gx XDG_DATA_HOME ~/.local/share
    set -q XDG_CACHE_HOME || set -gx XDG_CACHE_HOME ~/.cache

    # Set up editor preferences
    set -q EDITOR || set -gx EDITOR nvim
    set -q VISUAL || set -gx VISUAL nvim
    set -q PAGER || set -gx PAGER less
    set -q NVIM_APPNAME || set -gx NVIM_APPNAME lazyvim

    # Basic Fish settings
    set -g fish_greeting
    set -g fish_history_max 10000
    set -g fish_autosuggestion_enabled 1

    # Terminal settings
    set -q TERM || set -gx TERM xterm-256color
    set -q COLORTERM || set -gx COLORTERM truecolor

    # Locale
    set -q LC_ALL || set -gx LC_ALL en_US.UTF-8
    set -q LANG || set -gx LANG en_US.UTF-8

    # Set theme if not already set
    if not set -q FISH_THEME
        fish_config theme choose Nord >/dev/null 2>&1
        set -Ux FISH_THEME nord
    end

    set -g fish_initialized true
end
