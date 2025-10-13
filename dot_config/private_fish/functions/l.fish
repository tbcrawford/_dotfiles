#
# Better ls using eza with enhanced formatting
#
# Modern replacement for ls using eza with sensible defaults: long format with
# hidden files, human-readable sizes, directories grouped first, and sorted by name.
# Automatically ignores .DS_Store files on macOS.
#
# @param $argv - Additional arguments passed to eza
# @return Exit code from eza
# @example l
# @example l /usr/local/bin
#
function l -w eza -d "Better ls"
    eza -alhB --ignore-glob=".DS_Store" --group-directories-first -s=name $argv
end
