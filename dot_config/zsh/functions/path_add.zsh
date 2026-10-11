# Add directories to PATH, like fish_add_path.
#
# Prepends by default. Skips directories that don't exist or are already on PATH.
#
# @option --append - Add to the end of PATH instead of the front
# @example path_add "$HOME/go/bin"
# @example path_add --append "$HOME/.orbstack/bin"
path_add() {
    local append=false dir
    if [ "${1:-}" = "--append" ]; then
        append=true
        shift
    fi

    for dir in "$@"; do
        [ -d "$dir" ] || continue
        case ":$PATH:" in
            *":$dir:"*) continue ;;
        esac
        if [ "$append" = true ]; then
            PATH="$PATH:$dir"
        else
            PATH="$dir:$PATH"
        fi
    done
    export PATH
}
