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
    brew upgrade
    brew upgrade --cask --greedy
    brew upgrade --formula
    brew cleanup
    brew autoremove

    set -l current_profile (opm show)
    opm use gsd
    npx npx @opengsd/get-shit-done-redux@latest --global --opencode --cursor
    opm use $current_profile

    gsd update

    codegraph upgrade
end
