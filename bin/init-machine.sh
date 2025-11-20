#!/usr/bin/env bash
SSHPASS=temppass nix \
  run github:nix-community/nixos-anywhere \
  -- --env-password \
  --disk-encryption-keys "/tmp/luks.secret.key" "/tmp/luks.secret.key" \
  --flake .#kanna \
  -L \
  --build-on remote \
  --target-host root@192.168.1.133 \
  --copy-host-keys \
  --debug



# --generate-hardware-config nixos-generate-config ./hosts/Kanna/hardware-configuration.nix \
