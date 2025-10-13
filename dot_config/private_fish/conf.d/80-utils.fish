#
# Simple Fish utilities setup
#
# Basic setup for any remaining utility functions
#

# Simple function subdirectory setup
set -l config_functions $__fish_config_dir/functions
for subdir in $config_functions/*/
    if test -d $subdir; and not contains $subdir $fish_function_path
        set -g fish_function_path $subdir $fish_function_path
    end
end