#
# Open GitHub PR for current branch or repository
#
# Intelligently opens the pull request for the current git branch in the browser.
# If no PR exists for the current branch, falls back to opening the repository
# homepage. Uses GitHub CLI for PR detection and URL retrieval.
#
# @return 0 on successful browser opening, 1 if not in a git repository
# @example gho
#
function gho -d "Open GitHub PR for current branch or repository"
    # Get the current Git branch
    set branch (git symbolic-ref --short HEAD 2>/dev/null)

    if test -z "$branch"
        echo "Not in a Git repository or unable to determine branch."
        return 1
    end

    # Try to get the PR URL for the current branch
    set pr_url (gh pr view $branch --json url | jq -r .url)

    if test "$pr_url" != null -a -n "$pr_url"
        echo "Opening PR for branch '$branch'"
        open $pr_url
    else
        echo "No open PR found for branch '$branch'; opening repository instead."
        gh browse
    end
end
