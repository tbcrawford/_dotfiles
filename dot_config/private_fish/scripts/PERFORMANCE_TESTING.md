# Fish Shell Performance Testing Guide

A comprehensive guide to measuring, monitoring, and optimizing Fish shell startup performance using the built-in `benchmark` function.

## Overview

The Fish performance testing system provides tools to measure shell startup times, track performance changes over time, and identify optimization opportunities. It's designed to help maintain fast shell startup times as your configuration evolves.

All commands are available through the built-in `benchmark` function that accepts optional arguments.

## Quick Start

```bash
# Run basic performance test (20 iterations)
benchmark

# Save results to history for tracking
benchmark --save

# Compare with previous results
benchmark --compare

# View performance history
benchmark --history
```

## Command Reference

### Basic Commands

| Command | Description | Iterations |
|---------|-------------|------------|
| `benchmark` | Basic performance test | 20 |
| `benchmark --save` | Run test and save to history | 20 |
| `benchmark --compare` | Compare latest with previous results | - |
| `benchmark --history` | Show performance history (last 20 entries) | - |
| `benchmark --help` | Show help message | - |

### Advanced Analysis

| Command | Description | Use Case |
|---------|-------------|----------|
| `benchmark --detailed` | Component-by-component analysis | Identify slow components |
| `benchmark --profile` | Fish built-in startup profiling | Debug specific operations |
| `benchmark --clean` | Clean old performance data | Maintenance |

## Understanding Output

### Basic Results Table

```
📊 Results:
┌─────────────┬─────────────┐
│ Metric      │ Value       │
├─────────────┼─────────────┤
│ Average     │ 55.1ms      │  ← Primary metric for comparison
│ Minimum     │ 40.0ms      │  ← Best case performance
│ Maximum     │ 64.8ms      │  ← Worst case (outliers)
│ Total       │ 1.10s       │  ← Sum of all measurements
└─────────────┴─────────────┘
```

**Key Metrics:**
- **Average**: The primary metric for tracking performance trends
- **Minimum**: Shows the fastest possible startup time
- **Maximum**: Helps identify inconsistent performance or outliers
- **Total**: Total time spent across all test iterations

### Comparison Output

```
🔄 Performance Comparison:
┌─────────────┬─────────────┐
│ Metric      │ Value       │
├─────────────┼─────────────┤
│ Previous    │ 52.6ms      │
│ Latest      │ 50.9ms      │
│ Difference  │ -1.7ms      │  ← Negative = improvement
│ Percentage  │ -3.2%       │  ← Percentage change
└─────────────┴─────────────┘
```

**Performance States:**
- **🟢 Improvement**: Difference < -5ms (faster startup)
- **🟡 Stable**: Difference between -5ms and +5ms (no significant change)
- **🔴 Regression**: Difference > +5ms (slower startup)

## Performance Benchmarks

### Target Performance Goals

| Performance Level | Startup Time | User Experience |
|------------------|---------------|-----------------|
| **Excellent** | < 50ms | Instant, imperceptible |
| **Good** | 50-100ms | Very fast, barely noticeable |
| **Acceptable** | 100-200ms | Noticeable but not annoying |
| **Slow** | 200-500ms | Clearly noticeable delay |
| **Poor** | > 500ms | Frustrating user experience |

### Typical Component Timings

Based on detailed analysis, here are typical timings for common components:

| Component | Typical Time | Notes |
|-----------|--------------|-------|
| Minimal Fish | 15-25ms | Base Fish shell with no config |
| Basic Fish Init | 5-10ms | Essential Fish initialization |
| Fisher Plugin Manager | 10-20ms | Plugin loading overhead |
| Homebrew Integration | 5-15ms | With caching optimization |
| Starship Prompt | 10-25ms | Depends on prompt complexity |
| Mise/Tool Management | 20-40ms | Without lazy loading |

## Identifying Performance Issues

### 1. Regular Monitoring

**Establish Baseline:**
```bash
# Run and save your first measurement
benchmark --save

# After configuration changes, compare
benchmark --save
benchmark --compare
```

**Track Trends:**
```bash
# View history to spot gradual degradation
benchmark --history
```

### 2. Component Analysis

When performance degrades, use detailed analysis to identify the culprit:

```bash
# Identify slow components
benchmark --detailed

# See specific operations
benchmark --profile
```

**Interpreting Detailed Output:**
- Look for components taking >20ms
- Pay attention to operations that run multiple times
- Focus on the highest individual operation times

### 3. Common Performance Problems

| Issue | Symptoms | Solution |
|-------|----------|----------|
| **Uncached `brew --prefix`** | 20-30ms+ for Homebrew | Implement caching (see example below) |
| **Synchronous tool loading** | High mise/asdf times | Implement lazy loading |
| **Heavy prompt initialization** | 30ms+ Starship time | Optimize prompt config |
| **Excessive plugin loading** | High Fisher times | Remove unused plugins |
| **Repeated network calls** | Inconsistent high times | Cache network-dependent operations |

## Optimization Strategies

### 1. Caching Expensive Operations

**Example: Homebrew Prefix Caching**
```fish
# In functions/init_homebrew.fish
function init_homebrew
    # Check for cached value first
    if test -f ~/.cache/brew_prefix
        set -gx HOMEBREW_PREFIX (cat ~/.cache/brew_prefix)
    else
        # Cache the result for future use
        set -gx HOMEBREW_PREFIX (brew --prefix)
        echo $HOMEBREW_PREFIX > ~/.cache/brew_prefix
    end
    
    # Rest of Homebrew initialization...
end
```

### 2. Lazy Loading

**Example: Mise Lazy Loading**
```fish
# In conf.d/01-mise-optimization.fish
# Instead of running mise immediately, set up lazy loading
function mise
    # Remove this function and load mise on first use
    functions -e mise
    mise activate fish | source
    mise $argv
end
```

### 3. Conditional Loading

**Load components only when needed:**
```fish
# Only load development tools in development directories
if test -f .env || test -f package.json || test -f Cargo.toml
    init_development_tools
end
```

### 4. Parallel Initialization

**For independent operations:**
```fish
# Start multiple operations in background
init_homebrew &
init_starship &
wait  # Wait for all background jobs to complete
```

## Monitoring and Maintenance

### Regular Performance Audits

**Weekly/Monthly Checks:**
```bash
# Quick health check
benchmark --compare

# If regression detected, investigate
benchmark --detailed
```

**After Configuration Changes:**
```bash
# Always test after modifying config files
benchmark --save
benchmark --compare
```

### Performance History Management

**View trends:**
```bash
# See recent performance history
benchmark --history

# Clean old data (keeps last 50 entries)
benchmark --clean
```

### Setting Up Automated Testing

**Git Hook Example (`.git/hooks/pre-commit`):**
```bash
#!/bin/sh
# Run performance test before commit
cd ~/.config/fish
benchmark --save >/dev/null 2>&1

# Check for major regression
if benchmark --compare | grep -q "regression detected"; then
    echo "⚠️  Performance regression detected in Fish config"
    echo "Consider reviewing your recent changes"
    # Don't fail the commit, just warn
fi
```

## Troubleshooting

### Common Issues

**1. Inconsistent Results**
- **Symptoms**: Large variance between min/max times
- **Causes**: System load, background processes, thermal throttling
- **Solutions**: Close other applications, run multiple tests, test at different times

**2. False Regressions**
- **Symptoms**: Sudden performance drop without config changes
- **Causes**: System updates, different system load, disk I/O
- **Solutions**: Run test multiple times, restart terminal, check system resources

**3. Can't Identify Slow Component**
- **Symptoms**: Overall slowness but detailed analysis doesn't show clear culprit
- **Causes**: Cumulative effect of many small slowdowns
- **Solutions**: Binary search approach - disable half of config, test, narrow down

### Performance Testing Best Practices

1. **Consistent Testing Environment**
   - Close unnecessary applications
   - Test at similar system load levels
   - Use consistent terminal settings

2. **Multiple Measurements**
   - Don't rely on single test runs
   - The 20-iteration default provides good statistical accuracy
   - Look for trends over time, not single-point comparisons

3. **Document Changes**
   - Note configuration changes in commits
   - Keep track of optimization attempts
   - Use performance history to validate improvements

4. **Set Realistic Goals**
   - Aim for sub-100ms for good user experience
   - Focus on the biggest improvements first
   - Don't over-optimize at the expense of functionality

## Advanced Topics

### Custom Performance Testing

**Testing Specific Components:**
```bash
# Create isolated test for specific component
function test_component
    set -l start_time (date +%s%N)
    your_component_function
    set -l end_time (date +%s%N)
    set -l duration (math "($end_time - $start_time) / 1000000")
    echo "Component took: $(duration)ms"
end
```

**A/B Testing Configurations:**
```bash
# Test two different approaches
cp config.fish config.fish.backup
# Modify config with approach A
fish scripts/perf_test.fish --save
# Modify config with approach B  
fish scripts/perf_test.fish --save
fish scripts/perf_test.fish --compare
```

### Integration with CI/CD

For team environments, consider integrating performance testing:

```yaml
# Example GitHub Action
name: Fish Config Performance
on: [push, pull_request]
jobs:
  performance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install Fish
        run: sudo apt-get install fish
      - name: Test Performance
        run: benchmark
```

## Conclusion

Regular performance monitoring helps maintain a responsive shell environment. Use the benchmark function provided to:

1. **Establish baselines** with `benchmark --save`
2. **Monitor changes** with `benchmark --compare`
3. **Investigate issues** with `benchmark --detailed`
4. **Track trends** with `benchmark --history`

Remember: A fast shell startup time significantly improves daily productivity. Aim for sub-100ms startup times, and investigate any regression over 5ms.