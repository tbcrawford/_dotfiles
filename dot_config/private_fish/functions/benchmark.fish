#
# Run Fish performance tests
#
# Executes the Fish shell performance test suite by delegating to the perf_test.fish
# script. Passes through all command-line arguments to the underlying test script
# for flexible performance measurement and profiling.
#
# @param $argv - All arguments passed through to perf_test.fish script
# @return Exit code from the performance test script
# @example benchmark
# @example benchmark --verbose
#
function benchmark -d "Run Fish performance tests "
    fish $HOME/.config/fish/scripts/perf_test.fish $argv
end
