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