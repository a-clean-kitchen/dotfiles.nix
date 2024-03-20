.PHONY: dead-code flake-check
dead-code:
	nix run github:astro/deadnix

flake-check:
	nix run github:DeterminateSystems/flake-checker
