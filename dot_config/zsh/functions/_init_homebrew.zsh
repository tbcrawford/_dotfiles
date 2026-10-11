# Initialize Homebrew environment (mirrors fish _init_homebrew)
_init_homebrew() {
    local brew=/opt/homebrew/bin/brew
    [ -x "$brew" ] || return 1

    export HOMEBREW_NO_ANALYTICS=1

    local shell_name cache_file
    shell_name="$(_init_shell_name)"
    cache_file="homebrew_shellenv.$shell_name"

    _init_cache_ensure "$cache_file" "$brew shellenv $shell_name" "$brew"
    . "$__shell_cache_dir/$cache_file"
}

# Reload Homebrew configuration
reload_homebrew() {
    _init_cache_invalidate "homebrew_shellenv.$(_init_shell_name)"
    _init_homebrew
    echo "🍺 Homebrew configuration reloaded"
}
