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

    # Shell profiles are left alone: fish and ~/.config/zsh/env.zsh (bash and
    # zsh) already set up Homebrew. Appending `brew shellenv` to them would
    # rerun path_helper and push /usr/bin ahead of the mise shims.
    eval "$(/opt/homebrew/bin/brew shellenv)"
    
    echo "Homebrew installed and configured successfully!"
else
    echo "Homebrew is already installed"
fi