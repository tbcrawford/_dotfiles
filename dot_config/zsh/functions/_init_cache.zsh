# Version-aware cache helpers for _init_* functions (mirrors fish 00-cache.fish).
#
# Uses binary metadata (mtime + size) instead of --version subprocesses so
# startup stays fast while still detecting tool upgrades.

__shell_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# Return mtime:size metadata for a command
_init_cache_probe_meta() {
    local bin_path
    bin_path="$(command -v "$1" 2>/dev/null)" || {
        echo missing
        return
    }
    /usr/bin/stat -L -f '%m:%z' "$bin_path" 2>/dev/null || echo missing
}

# Regenerate cached init output when tool metadata changes
#
# @example _init_cache_ensure homebrew_shellenv.zsh "brew shellenv zsh" brew
_init_cache_ensure() {
    local name="$1" generator="$2" probe current stored=""
    shift 2

    local cache_file="$__shell_cache_dir/$name"
    local version_file="$cache_file.version"

    current=""
    for probe in "$@"; do
        current="$current|$probe=$(_init_cache_probe_meta "$probe")"
    done

    [ -f "$version_file" ] && stored="$(cat "$version_file")"

    if [ ! -f "$cache_file" ] || [ "$stored" != "$current" ]; then
        mkdir -p "$__shell_cache_dir"
        eval "$generator" >"$cache_file" 2>/dev/null
        printf '%s' "$current" >"$version_file"
    fi
}

# Remove cached init output and version stamp
_init_cache_invalidate() {
    rm -f "$__shell_cache_dir/$1" "$__shell_cache_dir/$1.version"
}

# Name of the running shell, for per-shell cache files and init output
_init_shell_name() {
    if [ -n "${ZSH_VERSION:-}" ]; then
        echo zsh
    elif [ -n "${BASH_VERSION:-}" ]; then
        echo bash
    else
        echo sh
    fi
}
