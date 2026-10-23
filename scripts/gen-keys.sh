#!/usr/bin/env bash
# Generate the throwaway SSH key pair used by the Docker test target.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
key_dir="$repo_root/keys"

mkdir -p "$key_dir"
chmod 700 "$key_dir"

if [[ -f "$key_dir/robot_test" ]]; then
    echo "key already exists: $key_dir/robot_test"
    exit 0
fi

ssh-keygen -t ed25519 -N "" -C "robot-test" -f "$key_dir/robot_test"
chmod 600 "$key_dir/robot_test"
echo "generated $key_dir/robot_test"
