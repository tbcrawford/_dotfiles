# Version-aware cache helpers for _init_* functions.
# Loaded before 00-init.fish so caches can be validated during startup.
#
# Uses binary metadata (mtime + size) instead of --version subprocesses so
# fresh-cache startup stays fast while still detecting tool upgrades.

function _init_cache_probe_meta -d "Return mtime:size metadata for a command or path"
    set -l target $argv[1]
    set -l cache_key "__init_cache_meta_$target"

    if not set -q $cache_key
        set -l path $target
        if not test -e $path
            set path (command -v $target 2>/dev/null)
        end

        if test -n "$path"; and test -e $path
            set -g $cache_key (stat -L -f '%m:%z' $path 2>/dev/null)
        else
            set -g $cache_key missing
        end
    end

    eval "echo \$$cache_key"
end

function _init_cache_fingerprint -d "Build cache key from binary metadata"
    set -l parts
    for probe in $argv
        switch $probe
            case brew starship zoxide mise fish
                set -a parts "$probe="(_init_cache_probe_meta $probe)
            case '*'
                set -a parts "$probe=unknown"
        end
    end
    string join -- '|' $parts
end

function _init_cache_ensure -d "Regenerate cached init output when tool metadata changes"
    argparse 'n/name=' 'm/message=' 'g/generator=' -- $argv
    or return 2

    set -l cache_file "$__fish_cache_dir/$_flag_name"
    set -l version_file "$cache_file.version"
    set -l current (_init_cache_fingerprint $argv)

    set -l needs_refresh true
    if test -f $cache_file; and test -f $version_file
        read -l stored <$version_file
        test "$stored" = "$current"; and set needs_refresh false
    end

    if test $needs_refresh = true
        mkdir -p $__fish_cache_dir
        test -n "$_flag_message" && echo $_flag_message
        eval $_flag_generator >$cache_file
        echo -n $current >$version_file
    end
end

function _init_cache_invalidate -d "Remove cached init output and version stamp"
    argparse 'n/name=' -- $argv
    or return 2

    set -l cache_file "$__fish_cache_dir/$_flag_name"
    rm -f $cache_file "$cache_file.version"
end
