{
  description = "My Dotfiles: Managed using Nix.";

  outputs = inputs @ { self, nixpkgs, ... }: 
    let
      globals = let domain = "quade.dev";
      in {
        user = "qm";
        fullName = "Quade Mashaw";
        gitName = "a-clean-kitchen";
        dotfilesRepo = "https://github.com/a-clean-kitchen/dotfiles.nix";
        hostnames = {
          main = domain;
        };
      };

      system = "x86_64-linux";
      
      overlays = [
        (import ./overlays/nvim4.nix inputs)
        (import ./overlays/swww.nix inputs)
      ];

      # Extend lib with personal functions
      lib = nixpkgs.lib.extend
        (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      mkHomeConfig = {
        username ? globals.user,
        system ? "x86_64-linux",
        nixpkgs ? inputs.nixpkgs,
        baseModules ? [
          {
            home = {
              sessionVariables = {
                NIX_PATH = "nixpkgs=${nixpkgs}";
              };
            };
          }
        ],
        extraModules ? []
      }: 
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
          };
          modules = baseModules ++ extraModules;
        };
    in rec {
      # nix-shell
      devShells."${system}" = { default = import ./shell.nix { inherit pkgs; }; };

      nixosConfigurations = {
        DeskBocks = import ./hosts/DeskBocks { inherit inputs globals overlays; };  
        junker = import ./hosts/Junker { inherit inputs globals overlays; };
      };
      
      # diskoConfigurations = { root = nixosConfigurations.DeskBocks.config; };

      homeConfigurations = {
        DeskBocks = nixosConfigurations.DeskBocks.config.home-manager.users.${globals.user};
        "${globals.user}@junker" = mkHomeConfig {
          extraModules = [ nixosConfigurations.junker.config.home-manager.users.${globals.user} ];
        };
      };

      # This is where I'm having nixd get all it's facts from
      nixdEntry = (lib.nixosSystem {
        system = "x86_64-linux";
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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim4 = {
      url = "github:a-clean-kitchen/nvim4/dynamic-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    swww = {
      url = "github:a-clean-kitchen/swww";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
