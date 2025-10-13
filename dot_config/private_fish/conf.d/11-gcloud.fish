# Optimized Google Cloud SDK PATH configuration
# Performance-focused implementation using idiomatic Fish

set -l gcloud_bin_path $HOMEBREW_PREFIX/share/google-cloud-sdk/bin
if test -d $gcloud_bin_path
    fish_add_path --prepend $gcloud_bin_path
end
