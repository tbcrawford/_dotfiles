# Dotfiles

Bootstrap your macOS development environment with chezmoi.

## Quick Start

Run this single command to install chezmoi and apply your dotfiles:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/tbcrawford/_dotfiles.git
```

This will:
1. Install chezmoi
2. Clone your dotfiles repository from GitHub
3. Run the bootstrap scripts (including Homebrew installation)
4. Apply all your dotfiles

## What gets installed

- Homebrew (if not already installed)
- Your dotfiles and configuration files
- Any additional packages/tools defined in your chezmoi configuration
- The tools in `~/.config/mise/config.toml`, via `mise install`

`~/dev/github/ah` is a private repository, so it is skipped until GitHub is
logged in. After `gh auth login`, run `chezmoi apply` again to clone it.

## Verification

`.ci/verify.sh` checks a provisioned Mac: chezmoi has nothing left to apply,
the Homebrew packages are installed, the expected tools run from zsh and fish,
and fish, zsh and bash each start with a prompt and no errors.

- **CI** (required for every PR to `main`): applies the dotfiles to a GitHub
  macOS runner and runs the checks. The runner already has Homebrew and the
  Command Line Tools, so it is not a clean Mac.
- **Clean Mac** (run locally when needed): `.ci/tart-verify.sh` clones a
  vanilla macOS VM with [Tart](https://tart.run), provisions it from your
  working copy, runs the checks, and deletes the VM. The first run pulls a
  ~35 GB image. Set `TART_VERIFY_IMAGE` to test another macOS version, and
  pass `--keep` to leave the VM running for debugging.