#
# Better `which` command with abbreviation support
#
# Enhanced version of which that checks for fish abbreviations before falling
# back to standard type lookup. Shows abbreviation definitions alongside command
# locations for comprehensive command resolution information.
#
# @param $argv - Command name to look up
# @return 0 on successful lookup
# @example which ls
# @example which gco
#
function which --description 'better `which`'
    if abbr --query $argv
        echo "$argv is an abbreviation with definition"
        abbr --show | command grep "abbr -a -- $argv"
        type --all $argv 2>/dev/null
        return 0
    else
        type --all $argv
    end
end
