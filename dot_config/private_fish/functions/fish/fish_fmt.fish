#
# Recursively format all *.fish files in a directory
#
# Automatically formats fish scripts using fish_indent --write to fix indentation and style.
# Uses fd for fast file discovery and modifies files in-place with progress reporting.
# Processes all .fish files found recursively in the target directory.
#
# @param $argv[1] directory - Target directory to format (optional, defaults to current directory)
# @option --help -h - Show detailed help message and exit
# @return 0 on successful formatting, 1 if target directory doesn't exist
# @example fish_fmt
# @example fish_fmt functions/
# @example fish_fmt ~/.config/fish
#
function fish_fmt -d "Fish Format - recursively format all *.fish files in a directory"
    # Handle help option
    if test "$argv[1]" = --help -o "$argv[1]" = -h
        echo "fish_fmt - Fish Format"
        echo ""
        echo "Usage: fish_fmt [directory]"
        echo ""
        echo "Recursively formats all *.fish files in the specified directory using fish_indent."
        echo "If no directory is specified, formats files in the current directory."
        echo ""
        echo "Examples:"
        echo "  fish_fmt                    # Format all .fish files in current directory"
        echo "  fish_fmt functions/         # Format all .fish files in functions/ directory"
        echo "  fish_fmt ~/.config/fish     # Format all .fish files in Fish config directory"
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

    echo "Formatting Fish files in: $target_dir"

    # Find and format all .fish files recursively
    set -l fish_files (fd -e fish . "$target_dir")

    if test (count $fish_files) -eq 0
        echo "No .fish files found in $target_dir"
        return 0
    end

    echo "Found "(count $fish_files)" Fish files to format"

    # Format each file and show progress
    for file in $fish_files
        echo "Formatting: $file"
        fish_indent --write "$file"
    end

    echo "✅ Formatted "(count $fish_files)" Fish files"
end
