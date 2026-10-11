# Initialize mise (mirrors fish _init_mise)
#
# Uses mise's shims instead of `mise activate`. Activation switches tool
# versions from a prompt hook, which never runs in the non-interactive shells
# agents use. Shims resolve the right version from the current directory's
# mise config each time a tool runs.
_init_mise() {
    command -v mise >/dev/null 2>&1 || return 1
    path_add "${MISE_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/mise}/shims"
}
