# Shell environment for zsh (and bash), structured like ~/.config/fish.
#
# Loaded from ~/.zshenv, so it runs for every zsh: interactive, login, and the
# non-interactive `zsh -c` shells that coding agents use. Keep it to
# environment setup (PATH, exported variables, tool init); there is no prompt,
# abbreviation, or plugin config here. Fish stays the interactive shell.
#
# Files are written to work in both zsh and bash so ~/.bash_profile and
# ~/.bashrc can load the same environment.

# Only run once per shell process (not exported, so child shells re-run it)
[ -n "${__shell_env_loaded:-}" ] && return 0
__shell_env_loaded=1

__shell_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

for __shell_file in "$__shell_config_dir"/functions/*.zsh "$__shell_config_dir"/conf.d/*.zsh; do
    [ -r "$__shell_file" ] && . "$__shell_file"
done
unset __shell_file

# Restored by ~/.zprofile after macOS's path_helper reorders PATH
__shell_env_path="$PATH"
