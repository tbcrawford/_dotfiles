#
# Create and checkout new branch with tcrawford/sc- prefix
#
# Creates a new git branch using standardized naming convention and immediately
# checks it out. Uses git checkout -b for atomic branch creation and switching.
#
# @param $argv[1] ticket - Ticket number or identifier
# @param $argv[2] description - Brief description of the branch purpose
# @return 0 on success, non-zero if git checkout -b fails
# @example gcbt 1234 fix-bug
# @example gcbt PROJ-567 add-feature
#
function gcbt -d "Create and checkout new branch with tcrawford/sc- prefix"
    git checkout -b "tcrawford/sc-$argv[1]/$argv[2]"
end
