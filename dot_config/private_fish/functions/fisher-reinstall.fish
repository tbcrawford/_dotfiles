function fisher-reinstall --description 'Remove, then install plugin(s)'
    # Check if we have plugins to reinstall
    if test (count $argv) -eq 0
        echo "Error: No plugins specified for reinstall"
        echo "Usage: fisher reinstall <plugin1> [plugin2] ..."
        return 1
    end

    # Loop through each plugin
    for plugin in $argv
        echo "Reinstalling $plugin..."

        # Remove the plugin (suppress error if not installed)
        fisher remove $plugin 2>/dev/null

        # Install the plugin
        if fisher install $plugin
            echo "Successfully reinstalled $plugin"
        else
            echo "Error: Failed to reinstall $plugin"
            return 1
        end
    end
end
