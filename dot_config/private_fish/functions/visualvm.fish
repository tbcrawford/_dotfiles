#
# Open VisualVM Java profiler
#
# Launches VisualVM application on macOS with proper Java home configuration.
# Uses the current JAVA_HOME environment variable to ensure compatibility
# with the active Java installation.
#
# @return Exit code from VisualVM application
# @example visualvm
#
function visualvm --description "Open VisualVM"
    /Applications/VisualVM.app/Contents/MacOS/visualvm --jdkhome "$JAVA_HOME"
end
