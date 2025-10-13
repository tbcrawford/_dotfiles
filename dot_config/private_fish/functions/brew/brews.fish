#
# Display installed Homebrew packages with enhanced formatting
#
# Shows formulae as dependency trees starting from leaf packages (top-level packages
# with no dependents), plus all casks with descriptions. Uses batch API calls for
# performance and provides colorized tree output with package counts and summaries.
#
# @option --simple - Use simple list format without colors or tree structure
# @option --help -h - Show detailed help message and exit
# @return 0 on success, 1 if brew is not available
# @example brews
# @example brews --simple
# @example brews --help
#
function brews -d "Show installed Homebrew formulae and casks with dependency tree"
    # Parse arguments
    set -l simple_mode false

    for arg in $argv
        switch $arg
            case --help -h
                echo "brews - Show Homebrew packages"
                echo ""
                echo "Usage: brews [options]"
                echo ""
                echo "Displays installed Homebrew formulae with their dependencies and all casks."
                echo "Formulae are shown as dependency trees starting from 'leaves' (top-level packages)."
                echo ""
                echo "Options:"
                echo "  --simple             Use simple output format (similar to original)"
                echo "  -h, --help           Show this help message"
                return 0
            case --simple
                set simple_mode true
        end
    end

    # Check if brew is available
    if not command -q brew
        echo (set_color red)"✗ Error:"(set_color normal)" Homebrew is not installed or not in PATH" >&2
        return 1
    end

    # Get formulae with dependency information
    set -l formulae_raw (brew leaves | xargs brew deps --installed --for-each 2>/dev/null)
    set -l casks (brew list --cask 2>/dev/null)

    # Get all installed formulae and casks for batch description lookup
    set -l all_formulae (brew list --formula 2>/dev/null)

    # Batch get all descriptions in one call (much faster)
    set -l formula_descs
    set -l cask_descs

    if test (count $all_formulae) -gt 0
        set formula_descs (brew desc $all_formulae 2>/dev/null)
    end

    if test (count $casks) -gt 0
        set cask_descs (brew desc $casks 2>/dev/null)
    end

    # Helper function to get description from batched results
    function _get_desc
        set -l package $argv[1]
        set -l desc_lines $argv[2..-1]

        for line in $desc_lines
            if string match -q "$package:*" $line
                echo (string split -m 1 ':' $line)[2] | string trim
                return
            end
        end
        echo "No description available"
    end

    # Simple mode (similar to original)
    if test $simple_mode = true
        echo (set_color blue)"==>"(set_color --bold normal)" Formulae"(set_color normal)
        if test (count $formulae_raw) -gt 0
            for line in $formulae_raw
                set -l parts (string split -m 1 ':' $line)
                set -l package $parts[1]
                set -l deps $parts[2]

                if test -n "$deps"
                    echo $package(set_color blue)$deps(set_color normal)
                else
                    echo $package
                end
            end
        else
            echo "  No formulae installed"
        end

        echo
        echo (set_color blue)"==>"(set_color --bold normal)" Casks"(set_color normal)
        if test (count $casks) -gt 0
            printf '%s\n' $casks
        else
            echo "  No casks installed"
        end
        return 0
    end

    # Enhanced mode (default)
    # Header
    echo (set_color cyan --bold)"🍺 Homebrew Packages"(set_color normal)
    echo (set_color black --bold)"─"(string repeat -n 50 "─")(set_color normal)
    echo

    # Display formulae section with tree structure
    if test (count $formulae_raw) -gt 0
        echo (set_color green --bold)"📦 Formulae ("(count $formulae_raw)")"(set_color normal)

        for line in $formulae_raw
            set -l parts (string split -m 1 ':' $line)
            set -l package $parts[1]
            set -l deps $parts[2]

            # Get description from batched results
            set -l desc (_get_desc $package $formula_descs)

            if test -n "$deps"
                # Package with dependencies - show as tree
                echo "  "(set_color yellow --bold)"$package"(set_color normal)" "(set_color brblack)"- $desc"(set_color normal)
                set -l dep_list (string split ' ' (string trim $deps))
                for i in (seq (count $dep_list))
                    set -l dep $dep_list[$i]
                    if test $i -eq (count $dep_list)
                        # Last dependency - use └─
                        echo "    "(set_color black --bold)"└─ "(set_color blue)"$dep"(set_color normal)
                    else
                        # Not last dependency - use ├─
                        echo "    "(set_color black --bold)"├─ "(set_color blue)"$dep"(set_color normal)
                    end
                end
            else
                # Package with no dependencies - just show package name
                echo "  "(set_color yellow --bold)"$package"(set_color normal)" "(set_color brblack)"- $desc"(set_color normal)
            end
            echo
        end
    else
        echo (set_color green --bold)"📦 Formulae"(set_color normal)
        echo "  "(set_color black)"No formulae installed"(set_color normal)
        echo
    end

    # Display casks section with descriptions
    if test (count $casks) -gt 0
        echo (set_color magenta --bold)"🪣 Casks ("(count $casks)")"(set_color normal)

        for cask in $casks
            # Get description from batched results
            set -l desc (_get_desc $cask $cask_descs)
            echo "  "(set_color cyan --bold)"$cask"(set_color normal)" "(set_color brblack)"- $desc"(set_color normal)
        end
        echo
    else
        echo (set_color magenta --bold)"🪣 Casks"(set_color normal)
        echo "  "(set_color black)"No casks installed"(set_color normal)
        echo
    end

    # Summary with visual separator
    echo (set_color black --bold)"─"(string repeat -n 50 "─")(set_color normal)
    set -l formula_count (count $formulae_raw)
    set -l cask_count (count $casks)
    set -l total_count (math $formula_count + $cask_count)

    echo (set_color white --bold)"📊 Total: $total_count packages"(set_color normal)" ("(set_color green)"$formula_count formulae"(set_color normal)", "(set_color magenta)"$cask_count casks"(set_color normal)")"
end
