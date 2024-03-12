{
  description = "My Dotfiles: Managed using Nix.";

  outputs = inputs @ { self, nixpkgs, ...}: 
    let
      system = "x86_64-linux";

      # Extend lib with personal functions
      lib = nixpkgs.lib.extend
        (self: { my = import ./lib { inherit pkgs inputs; lib = self; }; });

      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      devShells."${system}" = { default = import ./shell.nix { inherit pkgs; }; };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
