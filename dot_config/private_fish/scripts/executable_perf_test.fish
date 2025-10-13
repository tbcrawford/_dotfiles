#!/usr/bin/env fish

#
# Fish Configuration Performance Testing Script
#
# This script measures Fish shell startup performance and tracks
# changes over time to ensure configuration optimizations don't
# negatively impact startup speed.
#

set -l script_dir (dirname (status -f))
set -l config_dir $__fish_config_dir
set -l perf_dir $config_dir/.perf
set -l perf_log $perf_dir/startup_times.log
set -l perf_details $perf_dir/detailed_times.log

# Ensure performance directory exists
test -d $perf_dir || mkdir -p $perf_dir

# Function to format timing values for human readability
function format_time
    set -l time_value $argv[1]
    set -l unit $argv[2]

    # Ensure we have a numeric value (including negative numbers)
    if not string match -qr '^-?[0-9]+\.?[0-9]*$' -- $time_value
        echo $time_value
        return
    end

    # Convert to appropriate units and format
    switch $unit
        case ms milliseconds
            set -l time_float (math "$time_value")
            if test $time_float -ge 1000
                printf "%.2fs" (math "$time_float / 1000")
            else if test $time_float -ge 1
                printf "%.1fms" $time_float
            else
                printf "%.2fms" $time_float
            end
        case μs microseconds
            set -l time_int (math "floor($time_value)")
            if test $time_int -ge 1000000
                printf "%.2fs" (math "$time_int / 1000000")
            else if test $time_int -ge 1000
                printf "%.1fms" (math "$time_int / 1000")
            else
                printf "%dμs" $time_int
            end
        case "*"
            echo $time_value
    end
end

# Function to create visual progress bar (used for detailed analysis)
function progress_bar
    set -l current $argv[1]
    set -l total $argv[2]
    set -l width 20

    set -l filled (math "floor($current * $width / $total)")
    set -l empty (math "$width - $filled")

    printf "["
    for i in (seq $filled)
        printf "█"
    end
    for i in (seq $empty)
        printf "░"
    end
    printf "] %d/%d" $current $total
end

function show_help
    echo "Fish Configuration Performance Testing"
    echo ""
    echo "Usage: perf_test.fish [options]"
    echo ""
    echo "Options:"
    echo "  --save      Run test and save results to history (20 iterations)"
    echo "  --history   Show performance history"
    echo "  --compare   Compare latest with previous results"
    echo "  --detailed  Run detailed component analysis"
    echo "  --profile   Use Fish's built-in startup profiling"
    echo "  --clean     Clean old performance data"
    echo "  --help      Show this help message"
    echo ""
    echo "Without options, runs a basic performance test (20 iterations)."
end

function run_startup_benchmark
    set -l iterations $argv[1]
    test -n "$iterations" || set iterations 20

    echo "🚀 Running Fish startup benchmark ($iterations iterations)..."
    echo ""

    # Warm up
    printf "🔥 Warming up... "
    for i in (seq 3)
        fish -c exit >/dev/null 2>&1
    end
    echo done
    echo ""

    set -l times

    printf "⚡️ Running tests: "
    for i in (seq $iterations)
        # Measure full startup time including config loading
        set -l start_time (date +%s%N)
        fish -c true >/dev/null 2>&1
        set -l end_time (date +%s%N)

        set -l duration (math "($end_time - $start_time) / 1000000") # Convert to milliseconds
        set times $times $duration

        # Simple progress indicator
        printf "█"
    end
    printf " (%d/%d)\n\n" $iterations $iterations

    # Calculate statistics
    set -l total 0
    set -l min_time 999999
    set -l max_time 0

    for time in $times
        set total (math "$total + $time")
        test $time -lt $min_time && set min_time $time
        test $time -gt $max_time && set max_time $time
    end

    set -l avg_time (math "$total / $iterations")

    echo "📊 Results:"
    echo "┌─────────────┬─────────────┐"
    echo "│ Metric      │ Value       │"
    echo "├─────────────┼─────────────┤"
    printf "│ %-11s │ %-11s │\n" Average (format_time $avg_time "ms")
    printf "│ %-11s │ %-11s │\n" Minimum (format_time $min_time "ms")
    printf "│ %-11s │ %-11s │\n" Maximum (format_time $max_time "ms")
    printf "│ %-11s │ %-11s │\n" Total (format_time $total "ms")
    echo "└─────────────┴─────────────┘"
    echo ""
end

function run_startup_benchmark_quiet
    set -l iterations $argv[1]
    test -n "$iterations" || set iterations 20

    # Warm up
    for i in (seq 3)
        fish -c exit >/dev/null 2>&1
    end

    set -l times

    for i in (seq $iterations)
        # Measure full startup time including config loading
        set -l start_time (date +%s%N)
        fish -c true >/dev/null 2>&1
        set -l end_time (date +%s%N)

        set -l duration (math "($end_time - $start_time) / 1000000") # Convert to milliseconds
        set times $times $duration
    end

    # Calculate statistics
    set -l total 0
    for time in $times
        set total (math "$total + $time")
    end

    set -l avg_time (math "$total / $iterations")

    # Return only average time for saving
    echo $avg_time
end

function run_detailed_benchmark
    echo "🔍 Running detailed performance analysis with 20 iterations..."
    echo ""

    # Warmup phase
    printf "🔥 Warming up (3 iterations)... "
    for i in (seq 3)
        set -l temp_profile (mktemp)
        fish --profile-startup=$temp_profile -c exit >/dev/null 2>&1
        rm -f $temp_profile 2>/dev/null
    end
    echo done
    echo ""

    # Collect profile data from 20 runs
    echo "📊 Collecting profile data from 20 runs:"
    set -l all_profile_data (mktemp)
    set -l temp_files

    printf "⚡️ Running tests: "
    for i in (seq 20)
        set -l profile_file (mktemp)
        set temp_files $temp_files $profile_file

        fish --profile-startup=$profile_file -c exit >/dev/null 2>&1

        # Append this run's data to combined file (skip header for runs after first)
        if test $i -eq 1
            cat $profile_file >>$all_profile_data
        else
            tail -n +2 $profile_file >>$all_profile_data
        end

        # Simple progress indicator
        printf "█"
    end
    printf " (%d/%d)\n\n" 20 20

    echo ""
    echo "🔬 Top 10 unique slowest commands (aggregated from 20 runs):"
    echo "┌──────────┬───────────┬───────────────────────────────────────────────────────────┐"
    echo "│ Avg Time │ Max Time  │ Command                                                   │"
    echo "├──────────┼───────────┼───────────────────────────────────────────────────────────┤"

    # Process the combined data to find unique commands and their statistics
    set -l unique_commands (mktemp)

    # Use awk to parse the space-separated profile data
    tail -n +2 $all_profile_data | awk '
    BEGIN { 
        OFS="|" 
    }
    NF >= 3 && $1 ~ /^[0-9]+$/ && $2 ~ /^[0-9]+$/ {
        # Extract command (everything after the second field)
        cmd = $0
        sub(/^[[:space:]]*[0-9]+[[:space:]]+[0-9]+[[:space:]]+/, "", cmd)
        # Clean up command - remove leading arrows and whitespace
        gsub(/^-*>[ \t]*/, "", cmd)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", cmd)
        
        # Skip empty commands or very short ones, and filter for significant operations
        if(length(cmd) > 5 && $1 >= 10) {
            # Truncate very long commands for grouping
            if(length(cmd) > 80) {
                cmd = substr(cmd, 1, 80) "..."
            }
            
            times[cmd] += $1
            counts[cmd]++
            if($1 > max_times[cmd]) max_times[cmd] = $1
        }
    }
    END {
        for(cmd in times) {
            if(counts[cmd] > 0) {
                avg = times[cmd] / counts[cmd]
                printf "%.0f|%.0f|%s\n", avg, max_times[cmd], cmd
            }
        }
    }' | sort -t'|' -k1,1nr | head -10 >$unique_commands

    # Display the top 10 unique commands
    while read -l line
        if test -n "$line"
            set -l parts (string split "|" $line)
            if test (count $parts) -ge 3
                set -l avg_time $parts[1]
                set -l max_time $parts[2]
                set -l command $parts[3]

                if test -n "$avg_time" -a -n "$command"
                    set -l formatted_avg (format_time $avg_time "μs")
                    set -l formatted_max (format_time $max_time "μs")

                    # Properly truncate command with ellipsis if needed
                    set -l clean_command (string trim $command)
                    if test (string length $clean_command) -gt 57
                        set clean_command (string sub --length 54 -- $clean_command)"..."
                    end

                    printf "│ %8s │ %9s │ %-57s │\n" $formatted_avg $formatted_max $clean_command
                end
            end
        end
    end <$unique_commands

    echo "└──────────┴───────────┴───────────────────────────────────────────────────────────┘"
    echo ""

    echo "📊 Performance statistics across 20 runs:"

    # Calculate basic statistics
    set -l total_operations (tail -n +2 $all_profile_data | wc -l | string trim)
    set -l avg_operations_per_run (math "$total_operations / 20")
    set -l unique_count (cat $unique_commands | wc -l | string trim)

    echo "┌─────────────────────┬─────────────┐"
    echo "│ Metric              │ Value       │"
    echo "├─────────────────────┼─────────────┤"
    printf "│ %-19s │ %11s │\n" "Total operations" $total_operations
    printf "│ %-19s │ %11s │\n" "Avg ops per run" $avg_operations_per_run
    printf "│ %-19s │ %11s │\n" "Unique slow cmds" $unique_count
    echo "└─────────────────────┴─────────────┘"
    echo ""

    echo "📋 Component breakdown (5 iterations each):"
    echo ""

    set -l temp_config (mktemp -d)
    set -l components init_fish init_fisher init_homebrew init_starship init_zoxide

    # Test minimal Fish (no config)
    printf "🔧 Testing minimal Fish... "
    set -l times
    for i in (seq 5)
        set -l start_time (date +%s%N)
        env HOME=$temp_config fish -c true >/dev/null 2>&1
        set -l end_time (date +%s%N)
        set times $times (math "($end_time - $start_time) / 1000000")
    end
    set -l total 0
    for time in $times
        set total (math "$total + $time")
    end
    set -l minimal_time (math "$total / 5")
    echo done

    # Test each component incrementally
    cp $__fish_config_dir/config.fish $temp_config/config.fish.full 2>/dev/null
    cp -r $__fish_config_dir/functions $temp_config/ 2>/dev/null
    cp -r $__fish_config_dir/conf.d $temp_config/ 2>/dev/null

    set -l cumulative_time $minimal_time
    set -l component_results

    for component in $components
        printf "🔧 Testing $component... "

        # Create config with only this component and previous ones
        set -l test_config $temp_config/config.fish
        echo "# Test config for $component" >$test_config

        switch $component
            case init_fish
                echo init_fish >>$test_config
            case init_fisher
                echo -e "init_fish\ninit_fisher" >>$test_config
            case init_homebrew
                echo -e "init_fish\ninit_fisher\ninit_homebrew" >>$test_config
            case init_starship
                echo -e "init_fish\ninit_fisher\ninit_homebrew\ninit_starship" >>$test_config
            case init_zoxide
                echo -e "init_fish\ninit_fisher\ninit_homebrew\ninit_starship\ninit_zoxide" >>$test_config
        end

        # Measure startup time with this configuration (5 iterations)
        set -l times
        for i in (seq 5)
            set -l start_time (date +%s%N)
            env HOME=$temp_config fish -c true >/dev/null 2>&1
            set -l end_time (date +%s%N)
            set times $times (math "($end_time - $start_time) / 1000000")
        end

        # Calculate average
        set -l total 0
        for time in $times
            set total (math "$total + $time")
        end
        set -l avg_time (math "$total / 5")
        set -l component_time (math "$avg_time - $cumulative_time")

        # Store results for later display
        set component_results $component_results "$component|$component_time|$avg_time"
        set cumulative_time $avg_time

        echo done
    end

    echo ""

    # Display results table
    printf "┌─────────────────┬──────────────┬──────────────┐\n"
    printf "│ Component       │ Added Time   │ Total Time   │\n"
    printf "├─────────────────┼──────────────┼──────────────┤\n"
    printf "│ %-15s │ %12s │ %12s │\n" "Minimal Fish" - (format_time $minimal_time "ms")

    for result in $component_results
        set -l parts (string split "|" $result)
        set -l comp_name $parts[1]
        set -l comp_time $parts[2]
        set -l total_time $parts[3]
        printf "│ %-15s │ %12s │ %12s │\n" $comp_name (format_time $comp_time "ms") (format_time $total_time "ms")
    end

    printf "└─────────────────┴──────────────┴──────────────┘\n"

    # Clean up
    rm -rf $temp_config $all_profile_data $unique_commands 2>/dev/null
    for temp_file in $temp_files
        rm -f $temp_file 2>/dev/null
    end

    echo ""
    echo "💡 The analysis above shows command performance averaged across 20 startup runs"
    echo "   for more reliable performance insights and identification of bottlenecks."
end

function save_performance_result
    set -l avg_time $argv[1]
    set -l timestamp (date '+%Y-%m-%d %H:%M:%S')
    set -l git_hash unknown

    # Try to get git commit hash if in a git repo
    if git rev-parse --git-dir >/dev/null 2>&1
        set git_hash (git rev-parse --short HEAD 2>/dev/null || echo "unknown")
    end

    # Create the log entry
    set -l log_entry "$timestamp,$avg_time,$git_hash"

    # Save to log file - construct path inside function
    set -l log_path "$__fish_config_dir/.perf/startup_times.log"
    sh -c "echo '$log_entry' >> '$log_path'"

    echo "💾 Performance result saved: "(format_time $avg_time "ms")
end

function show_performance_history
    set -l log_path "$__fish_config_dir/.perf/startup_times.log"

    if not test -f $log_path
        echo "❌ No performance history found. Run with --save first."
        return 1
    end

    echo "📈 Performance History (last 20 entries):"
    echo ""
    echo "┌──────────────────────┬──────────────┬──────────────┐"
    echo "│ Date & Time          │ Startup Time │ Git Commit   │"
    echo "├──────────────────────┼──────────────┼──────────────┤"

    # Use a different approach to parse the CSV data
    tail -20 $log_path | while read -l line
        if test -n "$line"
            set -l timestamp (echo $line | cut -d, -f1)
            set -l avg_time (echo $line | cut -d, -f2)
            set -l git_hash (echo $line | cut -d, -f3)
            set -l formatted_time (format_time $avg_time "ms")
            printf "│ %-20s │ %12s │ %-12s │\n" "$timestamp" "$formatted_time" "$git_hash"
        end
    end
    echo "└──────────────────────┴──────────────┴──────────────┘"
    echo ""
end

function compare_performance
    set -l log_path "$__fish_config_dir/.perf/startup_times.log"

    if not test -f $log_path
        echo "❌ No performance history found. Run with --save first."
        return 1
    end

    set -l entries (cat $log_path | wc -l | string trim)
    if test $entries -lt 2
        echo "❌ Need at least 2 entries to compare. Current entries: $entries"
        return 1
    end

    set -l latest (tail -1 $log_path)
    set -l previous (tail -2 $log_path | head -1)

    set -l latest_time (echo $latest | cut -d, -f2)
    set -l previous_time (echo $previous | cut -d, -f2)
    set -l latest_date (echo $latest | cut -d, -f1)
    set -l previous_date (echo $previous | cut -d, -f1)

    set -l diff (math "$latest_time - $previous_time")
    set -l percent_change (math "($diff / $previous_time) * 100")

    echo "🔄 Performance Comparison:"
    echo ""
    echo "┌─────────────┬─────────────┐"
    echo "│ Metric      │ Value       │"
    echo "├─────────────┼─────────────┤"
    printf "│ %-11s │ %-11s │\n" Previous (format_time $previous_time "ms")
    printf "│ %-11s │ %-11s │\n" Latest (format_time $latest_time "ms")

    # Format difference with proper alignment
    set -l diff_formatted (printf "%+.1fms" $diff)
    set -l percent_formatted (printf "%+.1f%%" $percent_change)
    printf "│ %-11s │ %-11s │\n" Difference $diff_formatted
    printf "│ %-11s │ %-11s │\n" Percentage $percent_formatted
    echo "└─────────────┴─────────────┘"
    echo ""

    echo "📅 Comparison Details:"
    echo "┌─────────────┬─────────────────────┐"
    echo "│ Measurement │ Date & Time         │"
    echo "├─────────────┼─────────────────────┤"
    printf "│ %-11s │ %-19s │\n" Previous "$previous_date"
    printf "│ %-11s │ %-19s │\n" Latest "$latest_date"
    echo "└─────────────┴─────────────────────┘"
    echo ""

    if test $diff -gt 5
        echo "⚠️  Performance regression detected (+$(format_time $diff "ms"))"
        echo "   Consider investigating recent configuration changes."
    else if test $diff -lt -5
        echo "✅ Performance improvement! ($(format_time $diff "ms"))"
        echo "   Great work on optimizing the configuration!"
    else
        echo "➡️  Performance stable (within 5ms tolerance)"
        echo "   Configuration performance is consistent."
    end
    echo ""
end

function show_fish_profile
    echo "🔬 Fish Built-in Startup Profiling"
    echo ""

    set -l profile_file (mktemp)
    printf "📊 Running Fish startup profiling... "
    fish --profile-startup=$profile_file -c exit 2>/dev/null
    echo done
    echo ""

    echo "🕰️  Complete startup profile (operations >100μs):"
    echo "┌──────────┬──────────┬─────────────────────────────────────────────────────┐"
    echo "│   Time   │ Cum.Time │ Command                                             │"
    echo "├──────────┼──────────┼─────────────────────────────────────────────────────┤"

    # Show detailed profile, filtering out very fast operations
    tail -n +2 $profile_file | while read -l time sum command
        if test -n "$time" -a "$time" != ""
            # Check if time is numeric using regex
            if string match -qr '^\d+$' $time
                if test $time -gt 100 # Show operations > 100μs
                    set -l formatted_time (format_time $time "μs")
                    set -l formatted_sum (format_time $sum "μs")
                    set -l clean_command (string sub --length 51 -- $command)
                    printf "│ %8s │ %8s │ %-51s │\n" $formatted_time $formatted_sum $clean_command
                end
            end
        end
    end
    echo "└──────────┴──────────┴─────────────────────────────────────────────────────┘"
    echo ""

    echo "🏆 Top 15 slowest individual operations:"
    echo "┌──────────┬───────────────────────────────────────────────────────────────────┐"
    echo "│   Time   │ Command                                                           │"
    echo "├──────────┼───────────────────────────────────────────────────────────────────┤"

    tail -n +2 $profile_file | sort -rn | head -15 | while read -l time sum command
        if test -n "$time" -a "$time" != ""
            # Check if time is numeric using regex  
            if string match -qr '^\d+$' $time
                set -l formatted_time (format_time $time "μs")
                set -l clean_command (echo $command | string replace -r '^-*>' '' | string trim)
                set -l truncated_command (string sub --length 65 -- $clean_command)
                printf "│ %8s │ %-65s │\n" $formatted_time $truncated_command
            end
        end
    end
    echo "└──────────┴───────────────────────────────────────────────────────────────────┘"

    # Clean up
    rm -f $profile_file
end

function clean_old_data
    set -l log_path "$__fish_config_dir/.perf/startup_times.log"

    if not test -f $log_path
        echo "❌ No performance data to clean."
        return
    end

    set -l entries (cat $log_path | wc -l | string trim)
    if test $entries -le 50
        echo "📁 Performance log has $entries entries (≤50), no cleaning needed."
        return
    end

    echo "🧹 Cleaning old performance data (keeping last 50 entries)..."
    tail -50 $log_path >$log_path.tmp
    mv $log_path.tmp $log_path
    echo "✅ Cleaned. Entries remaining: 50"
end

# Main script logic
switch $argv[1]
    case --help
        show_help
    case --save
        run_startup_benchmark 20
        set -l result (run_startup_benchmark_quiet 20)
        save_performance_result $result
    case --history
        show_performance_history
    case --compare
        compare_performance
    case --detailed
        run_detailed_benchmark
    case --profile
        show_fish_profile
    case --clean
        clean_old_data
    case ""
        run_startup_benchmark 20
    case "*"
        echo "❌ Unknown option: $argv[1]"
        echo "Use --help for usage information."
        exit 1
end
