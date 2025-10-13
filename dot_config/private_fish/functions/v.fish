#
# Start neovim with lazyvim configuration
#
# Launches neovim using the lazyvim configuration by setting NVIM_APPNAME environment
# variable. Provides a quick shortcut to access the enhanced lazyvim setup while
# preserving all original nvim command-line arguments.
#
# @param $argv - All arguments passed through to nvim
# @return Exit code from nvim
# @example v
# @example v file.txt
# @example v +10 file.txt
#
function v -w nvim -d 'Start neovim with lazyvim'
    NVIM_APPNAME=lazyvim nvim $argv
end
