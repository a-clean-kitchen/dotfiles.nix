.PHONY: dead-code flake-check agenix-shell
dead-code:
	nix run github:astro/deadnix

flake-check:
	nix run github:DeterminateSystems/flake-checker

lint:
	nix run nixpkgs#statix -- check

agenix-shell:
	nix shell github:ryantm/agenix#default

# # To initialize a machine
# # https://github.com/nix-community/nixos-anywhere/blob/main/docs/reference.md
#
# .PHONY: init-machine
#
# init-machine:
# 	SSHPASS=temporaryPass nix run github:nix-community/nixos-anywhere -- --env-password --generate-hardware-config nixos-generate-config ./hosts/DeskBocks/hardware-configuration.nix --flake .#deskBocks -L --build-on local --target-host root@192.168.0.99
