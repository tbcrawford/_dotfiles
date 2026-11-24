#
# Complete Homebrew maintenance cycle
#
# Performs a comprehensive update and cleanup of all Homebrew packages including
# formulae and casks. Runs the full maintenance sequence: update package definitions,
# show outdated packages, upgrade everything, and clean up old versions.
#
# @return 0 on success, non-zero on brew command failure
# @example bop
#
function bop -d "Update Homebrew and all installed packages"
    brew update
    brew outdated
    brew upgrade --no-ask
    brew upgrade --cask --greedy --no-ask
    brew upgrade --formula --no-ask
    brew cleanup
    brew autoremove

    npx skills update -g

    # Executor 2 beta lives in Homebrew Node's global packages (the brew formula breaks its
    # Keychain binding). Plain `npm` is mise's Node, so call Homebrew's npm directly. Reinstalling
    # restarts the background server, so install and restart only when a newer beta is out.
    set -l executor_installed (executor --version 2>/dev/null | string replace 'executor v' '')
    set -l executor_latest (/opt/homebrew/bin/npm view executor@beta version 2>/dev/null)
    if test -n "$executor_latest"; and test "$executor_installed" != "$executor_latest"
        echo "Updating Executor $executor_installed -> $executor_latest"
        /opt/homebrew/bin/npm install --global executor@beta --include=optional
        and executor service restart
    end
end
