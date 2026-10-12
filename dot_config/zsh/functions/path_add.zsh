# Add directories to PATH, like fish_add_path.
#
# Prepends by default, moving a directory already on PATH to the front (like
# fish_add_path --move) so an inherited, reordered PATH can't bury it. Skips
# directories that don't exist, and with --append, ones already on PATH.
#
# @option --append - Add to the end of PATH instead of the front
# @example path_add "$HOME/go/bin"
# @example path_add --append "$HOME/.orbstack/bin"
path_add() {
    local append=false dir rest
    if [ "${1:-}" = "--append" ]; then
        append=true
        shift
    fi

    for dir in "$@"; do
        [ -d "$dir" ] || continue
        if [ "$append" = true ]; then
            case ":$PATH:" in
                *":$dir:"*) continue ;;
            esac
            PATH="$PATH:$dir"
        else
            # Remove every existing occurrence, then prepend
            rest=":$PATH:"
            while [[ "$rest" == *":$dir:"* ]]; do
                rest="${rest//":$dir:"/:}"
            done
            rest="${rest#:}"
            rest="${rest%:}"
            PATH="$dir${rest:+:$rest}"
        fi
    done
    export PATH
}
