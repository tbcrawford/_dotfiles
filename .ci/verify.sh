#!/usr/bin/env bash
#
# Check that this Mac is provisioned from the dotfiles: chezmoi has nothing
# left to apply, the expected tools run, and fish, zsh and bash each start with
# a prompt and no errors. Reports every check and exits non-zero if any failed.
#
# Usage: .ci/verify.sh <source-dir>

set -uo pipefail

source_dir="$(cd "${1:?usage: verify.sh <source-dir>}" && pwd)"
ci_dir="$(cd "$(dirname "$0")" && pwd)"
failures=0

pass() {
    printf 'ok    %s\n' "$1"
}

fail() {
    printf 'FAIL  %s\n' "$1"
    [ -n "${2:-}" ] && printf '%s\n' "$2" | sed 's/^/      /'
    failures=$((failures + 1))
}

# Run a check command; pass if it exits 0, otherwise fail with its output.
check() {
    local name="$1" output
    shift
    if output="$("$@" 2>&1)"; then
        pass "$name"
    else
        fail "$name" "$output"
    fi
}

# Strip terminal escape sequences and carriage returns from a transcript.
strip_ansi() {
    perl -pe 's/\e\][^\a\e]*(?:\a|\e\\)//g; s/\eP[^\e]*\e\\//g; s/\e\[[0-9;?<>=]*[ -\/]*[@-~]//g; s/\e[=>]//g; s/\r//g'
}

chezmoi_cmd() {
    chezmoi --source "$source_dir" "$@"
}

# A second apply would change nothing; prints the pending diff if it would.
chezmoi_diff_empty() {
    local diff
    diff="$(chezmoi_cmd diff --no-pager)" || return 1
    [ -z "$diff" ] || {
        printf '%s\n' "$diff"
        return 1
    }
}

# Every brew and cask in .chezmoidata/packages.yaml is installed.
brew_bundle_check() {
    chezmoi_cmd data --format json |
        jq -r '(.packages.darwin.brews[] | "brew \"\(.)\""), (.packages.darwin.casks[] | "cask \"\(.)\"")' |
        brew bundle check --verbose --file=-
}

echo "== chezmoi"
check "chezmoi verify (target state matches source)" chezmoi_cmd verify
check "chezmoi diff is empty" chezmoi_diff_empty

echo "== homebrew packages"
check "brew bundle check" brew_bundle_check

# Each tool is looked up from a login zsh (the environment agents get) and a
# login fish (the interactive shell), so PATH problems in either show up.
echo "== tools"
for tool in brew chezmoi git jq rg fish starship zoxide mise; do
    check "$tool on PATH (zsh)" zsh -lc "command -v $tool"
    check "$tool on PATH (fish)" fish -lc "command -v $tool"
done

# mise shims exist only for installed tools, but run them to be sure.
for tool_cmd in "java -version" "node --version" "terraform version" "watchexec --version"; do
    check "${tool_cmd%% *} runs via mise (zsh)" zsh -lc "$tool_cmd"
    check "${tool_cmd%% *} runs via mise (fish)" fish -lc "$tool_cmd"
done

echo "== shell prompts"
for shell in fish zsh bash; do
    transcript="$(cd "$HOME" && /usr/bin/expect -f "$ci_dir/shell-prompt.exp" "$shell" -l -i 2>&1)"
    status=$?
    plain="$(printf '%s' "$transcript" | strip_ansi)"

    if [ "$status" -ne 0 ]; then
        fail "$shell starts, runs a command, and exits (status $status)" "$plain"
        continue
    fi

    errors="$(printf '%s\n' "$plain" | grep -iE 'command not found|unknown command|no such file|not found|error|warning|⚠️')"
    if [ -n "$errors" ]; then
        fail "$shell starts without errors" "$plain"
        continue
    fi

    # The line where the command was typed must start with a rendered prompt.
    if printf '%s\n' "$plain" | grep -qE '^.*[^[:space:]].*echo __verify_ready__'; then
        pass "$shell shows a prompt without errors"
    else
        fail "$shell shows a prompt" "$plain"
    fi
done

echo
if [ "$failures" -gt 0 ]; then
    echo "$failures check(s) failed"
    exit 1
fi
echo "all checks passed"
