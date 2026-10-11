# PATH configuration (mirrors fish 02-path.fish)
# Later entries are prepended last, so they end up first on PATH.

# PostgreSQL tools (via Homebrew)
[ -n "${HOMEBREW_PREFIX:-}" ] && path_add "$HOMEBREW_PREFIX/opt/libpq/bin"

# Go binaries
path_add "$HOME/go/bin"

# Rust/Cargo binaries
path_add "$HOME/.cargo/bin"

path_add "$HOME/bin"

# User local binaries (highest priority)
path_add "$HOME/.local/bin"
