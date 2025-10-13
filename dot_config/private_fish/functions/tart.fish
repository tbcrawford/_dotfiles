#
# Wrapper for tart to inject extension subcommands
#
# Extends the tart VM management tool with additional convenience commands.
# Adds 'reset' subcommand that deletes a VM and recreates it from a template.
# All other commands pass through to the original tart binary unchanged.
#
# @param $argv[1] - Subcommand (reset or standard tart commands)
# @param $argv[2] - For reset: target VM name to delete/recreate
# @param $argv[3] - For reset: source template VM to clone from
# @return Exit code from tart commands
# @example tart reset my-vm base-template
# @example tart list
#
function tart --wraps tart --description "Wrapper for tart to inject extension subcommands"
    if test (count $argv) -gt 0; and test "$argv[1]" = reset
        set -l rest $argv[2..-1]

        command tart delete $argv[2]
        command tart clone $argv[3] $argv[2]

        return
    end

    # Otherwise, call the real external `tart`
    command tart $argv
end
