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
    echo "Homebrew installed successfully!"
else
    echo "Homebrew is already installed"
fi