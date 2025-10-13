# Non-secret environment variables
set -q FISH_THEME; or set -Ux FISH_THEME nord
set -q BAT_THEME; or set -Ux BAT_THEME Nord
set -q USE_GKE_GCLOUD_AUTH_PLUGIN; or set -Ux USE_GKE_GCLOUD_AUTH_PLUGIN True
set -q DOCKER_DEFAULT_PLATFORM; or set -Ux DOCKER_DEFAULT_PLATFORM "linux/arm64"