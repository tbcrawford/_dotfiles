#
# Optimized grep with auto color support
#
# Enhanced grep wrapper that adds intelligent color support with performance
# optimization. Uses lazy initialization to test color support only on first use
# and caches the result to avoid repeated expensive checks during startup.
#
# @param $argv - All arguments passed through to grep
# @return Exit code from grep command
# @example grep "pattern" file.txt
# @example grep -r "pattern" directory/
#
function grep --description 'grep with auto color support'
    # Lazy initialization of color support on first use
    if not set -q __fish_grep_color_support
        if echo | command grep --color=auto "" >/dev/null 2>&1
            set -Ux __fish_grep_color_support true
        else
            set -Ux __fish_grep_color_support false
        end
    end

    # Call grep with or without color based on cached support
    if test "$__fish_grep_color_support" = true
        command grep --color=auto $argv
    else
        command grep $argv
    end
end
