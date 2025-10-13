#
# Checkout git branch using fzf selector
#
# Interactive branch selection using fzf with fuzzy matching. Shows all local and
# remote branches, handles remote branch cleanup, and supports optional query for
# pre-filtering results. Automatically strips whitespace and remote prefixes.
#
# @param $argv[1] query - Optional search query to pre-filter branches
# @return 0 on successful checkout, non-zero if fzf cancelled or git checkout fails
# @example gco
# @example gco feature
# @example gco bugfix
#
function gco -d "Checkout git branch using fzf selector"
    set branch (git branch --all | fzf --exact -1 -0 --ansi --query "$argv[1]" | sed 's/remotes\/origin\///' | tr -d '*[:space:]')
    git checkout $branch
end
