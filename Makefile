.PHONY: dead-code flake-check agenix-shell
dead-code:
	nix run github:astro/deadnix

flake-check:
	nix run github:DeterminateSystems/flake-checker

lint:
	nix run nixpkgs#statix -- check

agenix-shell:
	nix shell github:ryantm/agenix#default

# To initialize a machine
# https://github.com/nix-community/nixos-anywhere/blob/main/docs/reference.md

.PHONY: init-machine

init-machine:
	SSHPASS=temppass nix run github:nix-community/nixos-anywhere -- --env-password --generate-hardware-config nixos-generate-config ./hosts/Kanna/hardware-configuration.nix --disk-encryption-keys "/tmp/luks.secret.key" "/tmp/luks.secret.key" --flake .#kanna -L --build-on local --target-host root@192.168.1.133

# LUKS SETUP
.PHONY: luks-init-machine

luks-init-machine:
	SSHPASS=temppass nix run github:nix-community/nixos-anywhere -- --env-password --generate-hardware-config nixos-generate-config ./hosts/Kanna/hardware-configuration.nix --disk-encryption-keys "/tmp/luks.secret.key" "/tmp/luks.secret.key" --flake .#kanna -L --build-on local --target-host root@192.168.1.133
