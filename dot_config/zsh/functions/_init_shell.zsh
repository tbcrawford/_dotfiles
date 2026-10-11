# Base environment (mirrors fish _init_fish and the exported fish universal variables)
_init_shell() {
    # XDG directories
    export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
    export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
    export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
    export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

    # Editor preferences
    export EDITOR="${EDITOR:-nvim}"
    export VISUAL="${VISUAL:-nvim}"
    export PAGER="${PAGER:-less}"
    export NVIM_APPNAME="${NVIM_APPNAME:-lazyvim}"

    # Terminal settings
    export TERM="${TERM:-xterm-256color}"
    export COLORTERM="${COLORTERM:-truecolor}"

    # Locale
    export LC_ALL="${LC_ALL:-en_US.UTF-8}"
    export LANG="${LANG:-en_US.UTF-8}"
}
