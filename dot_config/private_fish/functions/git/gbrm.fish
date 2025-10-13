#
# Rename current branch with tcrawford/sc- prefix
#
# Renames the current git branch using a standardized naming convention with
# user prefix and ticket number. Uses git branch -m to perform the rename operation.
#
# @param $argv[1] ticket - Ticket number or identifier
# @param $argv[2] description - Brief description of the branch purpose
# @return 0 on success, non-zero if git branch -m fails
# @example gbrm 1234 fix-bug
# @example gbrm PROJ-567 add-feature
#
function gbrm -d "Rename current branch with tcrawford/sc- prefix"
    git branch -m "tcrawford/sc-$argv[1]/$argv[2]"
end
