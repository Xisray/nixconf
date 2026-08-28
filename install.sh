#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root!" >&2
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "usage: $0 <hostname> [<commit-sha>]" >&2
  exit 2
fi

NIX="nix --extra-experimental-features nix-command --extra-experimental-features flakes"
HOST=$1
REV=${2:-main}
FLAKE="github:Xisray/nixconf/${REV}#${HOST}"

cat <<EOF
About to install NixOS:
  host:  ${HOST}
  flake: ${FLAKE}

This will WIPE the target disk declared in modules/hosts/${HOST}/disko.nix.
EOF

$NIX run github:nix-community/disko/latest -- \
    --mode destroy,format,mount \
    --yes-wipe-all-disks \
    --flake "$FLAKE" </dev/tty

echo
echo "Set a password for the user account:"
PASSWD_HASH=$($NIX run nixpkgs#mkpasswd -- -m sha-512 </dev/tty)

mkdir -p /mnt/persist
echo "$PASSWD_HASH" | tee /mnt/persist/passwd >/dev/null
chmod 600 /mnt/persist/passwd
chown root:root /mnt/persist/passwd

nixos-install --no-root-passwd --flake "$FLAKE"
