#!/usr/bin/env bash
#
# Provision a clean macOS VM from this working copy and verify it. Clones a
# vanilla Cirrus Labs image (no Homebrew, no Command Line Tools), applies the
# dotfiles over SSH, runs .ci/verify.sh, then deletes the VM.
#
# Usage: .ci/tart-verify.sh [--keep]
#   --keep  Leave the VM running afterwards for debugging
#           (ssh admin@"$(tart ip <vm>)", password "admin")
#
# Environment:
#   TART_VERIFY_IMAGE  Image to clone
#                      (default: ghcr.io/cirruslabs/macos-golden-gate-vanilla:27.0)

set -euo pipefail

image="${TART_VERIFY_IMAGE:-ghcr.io/cirruslabs/macos-golden-gate-vanilla:27.0}"
repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
vm="dotfiles-verify-$(date +%Y%m%d-%H%M%S)"
keep=false
[ "${1:-}" = "--keep" ] && keep=true

command -v tart >/dev/null 2>&1 || {
    echo "tart is not installed: brew install cirruslabs/cli/tart" >&2
    exit 1
}

work_dir="$(mktemp -d)"
run_pid=""

cleanup() {
    if [ "$keep" = true ]; then
        echo "Keeping VM $vm (ssh admin@$(tart ip "$vm" 2>/dev/null || echo '<ip>'), password admin)"
    else
        [ -n "$run_pid" ] && tart stop "$vm" >/dev/null 2>&1
        tart delete "$vm" >/dev/null 2>&1
    fi
    rm -rf "$work_dir"
}
trap cleanup EXIT

# Stage the working copy without git metadata or linked secrets
mkdir "$work_dir/dotfiles"
rsync -a --exclude .git --exclude .env "$repo_dir/" "$work_dir/dotfiles/"

# Vanilla images log in as admin/admin; feed the password to ssh non-interactively
cat >"$work_dir/askpass" <<'EOF'
#!/bin/sh
echo admin
EOF
chmod +x "$work_dir/askpass"

vm_ssh() {
    SSH_ASKPASS="$work_dir/askpass" SSH_ASKPASS_REQUIRE=force \
        ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR -o PubkeyAuthentication=no \
        "admin@$ip" "$@" </dev/null
}

echo "==> Cloning $image as $vm"
tart clone "$image" "$vm"

echo "==> Booting"
tart run --no-graphics --dir="dotfiles:$work_dir/dotfiles:ro" "$vm" >"$work_dir/run.log" 2>&1 &
run_pid=$!

ip="$(tart ip --wait 180 "$vm")"
for _ in $(seq 1 60); do
    vm_ssh true 2>/dev/null && break
    sleep 2
done
vm_ssh true

# Copy out of the read-only share so chezmoi works from a normal directory
vm_ssh 'cp -R "/Volumes/My Shared Files/dotfiles" ~/dotfiles'

echo "==> Provisioning"
start=$SECONDS
vm_ssh 'bash -l ~/dotfiles/.ci/provision.sh ~/dotfiles'
echo "==> Provisioned in $(((SECONDS - start) / 60))m$(((SECONDS - start) % 60))s"

echo "==> Verifying"
vm_ssh 'bash -l ~/dotfiles/.ci/verify.sh ~/dotfiles'
