.PHONY: dead-code flake-check
dead-code:
	nix run github:astro/deadnix

flake-check:
	nix run github:DeterminateSystems/flake-checker

lint:
	nix run nixpkgs#statix -- check

# # Too initialize a machine
# # https://github.com/nix-community/nixos-anywhere/blob/main/docs/reference.md
# .PHONY: init-junkr
#
# init-junkr:
#  SSHPASS=temporaryPass nix run github:nix-community/nixos-anywhere -- --env-password --generate-hardware-config nixos-generate-config ./hosts/Junkr/hardware-configuration.nix --flake .#junkr -L --build-on-remote --target-host root@ip.or.host.name
