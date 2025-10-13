#
# Recursively lint all *.fish files in a directory
#
# Validates formatting of fish scripts using fish_indent --check without modifying files.
# Uses fd for fast file discovery and provides detailed progress reporting with error counts.
# Suggests using fish_fmt to fix any formatting issues found.
#
# @param $argv[1] directory - Target directory to lint (optional, defaults to current directory)
# @option --help -h - Show detailed help message and exit
# @return 0 if all files are properly formatted, 1 if formatting issues found or directory doesn't exist
# @example fish_lint
# @example fish_lint functions/
# @example fish_lint ~/.config/fish
#
function fish_lint -d "Fish Lint - recursively lint all *.fish files in a directory"
    # Handle help option
    if test "$argv[1]" = --help -o "$argv[1]" = -h
        echo "fish_lint - Fish Lint"
        echo ""
        echo "Usage: fish_lint [directory]"
        echo ""
        echo "Recursively lints all *.fish files in the specified directory using fish_indent."
        echo "If no directory is specified, lints files in the current directory."
        echo ""
        echo "Examples:"
        echo "  fish_lint                    # Lint all .fish files in current directory"
        echo "  fish_lint functions/         # Lint all .fish files in functions/ directory"
        echo "  fish_lint ~/.config/fish     # Lint all .fish files in Fish config directory"
        echo ""
        echo "Options:"
        echo "  -h, --help           Show this help message"
        return 0
    end

    set -l target_dir $argv[1]

    # Use current directory if no directory specified
    if test -z "$target_dir"
        set target_dir "."
    end

    # Check if directory exists
    if not test -d "$target_dir"
        echo "Error: Directory '$target_dir' does not exist" >&2
        return 1
    end

    echo "Linting Fish files in: $target_dir"

    # Find and lint all .fish files recursively
    set -l fish_files (fd -e fish . "$target_dir")

    if test (count $fish_files) -eq 0
        echo "No .fish files found in $target_dir"
        return 0
    end

    echo "Found "(count $fish_files)" Fish files to lint"

    set -l lint_errors 0

    # Lint each file and show progress
    for file in $fish_files
        echo "Linting: $file"
        if not fish_indent --check "$file" >/dev/null 2>&1
            echo "❌ Formatting issues found in: $file"
            set lint_errors (math $lint_errors + 1)
        end
    end

    if test $lint_errors -eq 0
        echo "✅ All "(count $fish_files)" Fish files are properly formatted"
        return 0
    else
        echo "❌ Found formatting issues in $lint_errors file(s)"
        echo "Run 'fish_fmt $target_dir' to fix formatting issues"
        return 1
    end
end
