# Fish PATH Configuration
# Adds essential development tools to PATH in priority order

# User local binaries (highest priority)
fish_add_path ~/.local/bin

# Go binaries (simple path)
if test -d "$HOME/go/bin"
    fish_add_path $HOME/go/bin
end

# PostgreSQL tools (via Homebrew)
if test -n "$HOMEBREW_PREFIX" -a -d "$HOMEBREW_PREFIX/opt/libpq/bin"
    fish_add_path $HOMEBREW_PREFIX/opt/libpq/bin
end

# Rust/Cargo binaries
if test -d "$HOME/.cargo/bin"
    fish_add_path $HOME/.cargo/bin
end

if test -d "$HOME/bin"
    fish_add_path $HOME/bin
end
