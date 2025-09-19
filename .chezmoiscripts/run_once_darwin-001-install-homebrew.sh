#!/usr/bin/env bash

set -euo pipefail

# Only run on macOS
if [ "$(uname)" != "Darwin" ]; then
    echo "This script is only for macOS"
    exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Source Homebrew into current environment and shell profiles
    echo "Configuring Homebrew in shell profiles..."
    
    # Add to bash profile if it exists or create it
    if [ -f "$HOME/.bash_profile" ] || [ -f "$HOME/.bashrc" ]; then
        BASH_PROFILE="$HOME/.bash_profile"
        [ ! -f "$BASH_PROFILE" ] && BASH_PROFILE="$HOME/.bashrc"
        # shellcheck disable=SC2016 
        # we want the literal string in grep
        if ! grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$BASH_PROFILE" 2>/dev/null; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$BASH_PROFILE"
        fi
    fi
    
    # Add to zsh profile
    if [ -f "$HOME/.zshrc" ] || [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ]; then
        ZSHRC="$HOME/.zshrc"
        [ ! -f "$ZSHRC" ] && touch "$ZSHRC"
        # shellcheck disable=SC2016 
        # we want the literal string in grep
        if ! grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$ZSHRC" 2>/dev/null; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$ZSHRC"
        fi
    fi
    
    # Source Homebrew for the current script execution
    eval "$(/opt/homebrew/bin/brew shellenv)"
    
    echo "Homebrew installed and configured successfully!"
else
    echo "Homebrew is already installed"
fi