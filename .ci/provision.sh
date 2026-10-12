#!/usr/bin/env bash
#
# Provision this Mac from a dotfiles checkout, as the README one-liner does,
# but from a local source directory so unmerged changes can be tested.
# Only meant for throwaway machines (CI runners, Tart VMs): it overwrites
# existing dotfiles without asking.
#
# Usage: .ci/provision.sh <source-dir>

set -euo pipefail

source_dir="$(cd "${1:?usage: provision.sh <source-dir>}" && pwd)"
bin_dir="$HOME/.local/bin"

# Make the Homebrew installer fail instead of prompting
export NONINTERACTIVE=1

if ! command -v chezmoi >/dev/null 2>&1; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$bin_dir"
    export PATH="$bin_dir:$PATH"
fi

chezmoi --source "$source_dir" apply --force --no-tty
