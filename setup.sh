#!/usr/bin/env bash
# lanbuf-setup — interactive configurator for lanbuf
# Creates ~/.config/lanbuf/server and path files

set -euo pipefail

cfg_dir="${XDG_CONFIG_HOME:-$HOME/.config}/lanbuf"
server_file="$cfg_dir/server"
path_file="$cfg_dir/path"

echo "🧠  LANBUF setup"
echo "This will configure where lanbuf stores and retrieves its shared buffer."
echo

read -rp "Enter SSH server (e.g. user@lanhost): " server
if [[ -z "$server" ]]; then
  echo "Error: server cannot be empty." >&2
  exit 1
fi

read -rp "Enter remote buffer file path [~/lanbuf/buf.txt]: " path
path="${path:-~/lanbuf/buf.txt}"

mkdir -p "$cfg_dir"
echo "$server" >"$server_file"
echo "$path" >"$path_file"

echo
echo "🔐 Verifying SSH access..."
if ! ssh -o BatchMode=yes -o ConnectTimeout=5 "$server" "echo ok" >/dev/null 2>&1; then
  echo "⚠️  Could not connect to $server — make sure SSH works without a password prompt." >&2
else
  echo "✅ SSH connection successful."
fi

echo
echo "📁 Creating directory on remote host..."
ssh "$server" "mkdir -p \"${path%/*}\" && touch \"$path\" && chmod 600 \"$path\"" || {
  echo "⚠️  Warning: could not create remote path (check permissions)." >&2
}

echo
echo "✨ Configuration saved:"
echo "  Server: $server"
echo "  Path:   $path"
echo
echo "You can now use lanbuf from any machine configured with these same files."
echo "Example:"
echo "  echo 'hi' | lanbuf"
echo "  lanbuf"
