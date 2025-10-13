#
# Load secrets from 1Password CLI with permanent caching
#
# Loads environment variables from 1Password using CLI with intelligent caching.
# Sources secrets mapping file to determine which variables to fetch, validates
# 1Password CLI availability and authentication, and caches results for performance.
# Supports force refresh to bypass cache.
#
# @option --force - Force refresh by bypassing existing cache
# @return 0 on successful loading, 1 on error (missing CLI, auth failure, no secrets loaded)
# @example load_secrets
# @example load_secrets --force
#
function load_secrets --description "Load secrets from 1Password CLI with permanent caching"
    # Initialize cache directory
    set -l cache_dir "$__fish_cache_dir/secrets"
    set -l cache_file "$cache_dir/cached_secrets.fish"
    set -l secrets_map "$__fish_config_dir/secrets/secrets_map.fish"

    # Check if secrets mapping file exists
    if not test -f "$secrets_map"
        echo "Error: Secrets mapping file not found at $secrets_map" >&2
        return 1
    end

    # Check for force refresh flag
    set -l force_refresh false
    if contains -- --force $argv
        set force_refresh true
    end

    # Use cached secrets if they exist and force refresh is not requested
    if test -f "$cache_file" -a "$force_refresh" = false
        source "$cache_file"
        return 0
    end

    # Check if 1Password CLI is available
    if not command -q op
        echo "Error: 1Password CLI (op) is not installed or not in PATH" >&2
        echo "Please install it from: https://developer.1password.com/docs/cli/get-started/" >&2
        return 1
    end

    # Check if user is signed in to 1Password
    if not op account list --format=json >/dev/null 2>&1
        echo "Error: Not signed in to 1Password CLI" >&2
        echo "Please run: op signin" >&2
        return 1
    end

    echo "Loading secrets from 1Password..."

    # Create cache directory if it doesn't exist
    mkdir -p "$cache_dir"

    # Create temporary file for building cache
    set -l temp_cache (mktemp)

    # Add header to cache file
    echo "# Cached secrets from 1Password CLI" >"$temp_cache"
    echo "# Generated on: $(date)" >>"$temp_cache"
    echo "" >>"$temp_cache"

    # Source the secrets mapping to get the variable definitions
    source "$secrets_map"

    # Counter for success/failure tracking
    set -l success_count 0
    set -l total_count 0

    # Parse the secrets mapping file to get all variable names and their 1Password references
    set -l secret_vars (grep -E '^set [A-Z_0-9]+ ' "$secrets_map" | string replace -r '^set ([A-Z_0-9]+).*' '$1')

    # Process each secret defined in the mapping
    for var_name in $secret_vars
        set total_count (math $total_count + 1)

        # Get the 1Password reference for this variable
        set -l op_ref $$var_name

        if test -z "$op_ref"
            echo "Warning: No 1Password reference found for $var_name" >&2
            continue
        end

        echo "  Fetching $var_name..."

        # Fetch the secret from 1Password
        set -l secret_value (op read "$op_ref" 2>/dev/null)

        if test $status -eq 0 -a -n "$secret_value"
            # Escape single quotes and backslashes in the secret value
            set secret_value (string replace -a "'" "'\\''" "$secret_value")
            set secret_value (string replace -a "\\" "\\\\" "$secret_value")

            # Write to cache file and set the variable
            echo "set -gx $var_name '$secret_value'" >>"$temp_cache"
            set -gx $var_name "$secret_value"

            set success_count (math $success_count + 1)
        else
            echo "Warning: Failed to fetch $var_name from 1Password" >&2
        end
    end

    # Move temp file to final cache location
    mv "$temp_cache" "$cache_file"

    echo "Successfully loaded $success_count/$total_count secrets from 1Password"

    if test $success_count -eq 0
        echo "Error: No secrets were successfully loaded" >&2
        return 1
    end

    return 0
end
