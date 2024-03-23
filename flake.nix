{
  description = "My Dotfiles: Managed using Nix.";

  outputs = inputs @ { self, nixpkgs, ... }: 
    let
      globals = let domain = "quade.dev";
      in rec {
        user = "qm";
        fullName = "Quade Mashaw";
        gitName = "a-clean-kitchen";
        dotfilesRepo = "https://github.com/a-clean-kitchen/dotfiles.nix";
        hostnames = {
          main = domain;
          # db = "db.${domain}"
        };
      };

      system = "x86_64-linux";
      
      overlays = [];

      # Extend lib with personal functions
      lib = nixpkgs.lib;#.extend
        #(self: { my = import ./lib { inherit pkgs inputs; lib = self; }; });

      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      devShells."${system}" = { default = import ./shell.nix { inherit pkgs; }; };

      nixosConfigurations = {
        Bocks1606 = import ./hosts/Bocks1606 { inherit inputs globals overlays; };  
      };

      nixdEntry = (lib.evalModules {
        modules = [
          globals
          inputs.home-manager.nixosModules.home-manager
          ./modules/nixos 
          ./modules/common
        ];
        specialArgs = {
          inherit pkgs;
        };
      }).options // {lib = lib; builtins = builtins;};

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

    nvim4 = {
      url = "github:a-clean-kitchen/nvim4";
    };
  };
}
