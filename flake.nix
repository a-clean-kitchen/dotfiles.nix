{
  description = "My Dotfiles: Managed using Nix.";

  outputs = inputs @ { nixpkgs, home-manager, ... }: 
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

      hmConfig = nixosDerivedModules: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [(
            { lib, config, ... }:
            {
              options.home.news.json.output = lib.mkOption {
                type = lib.types.package;
                default = pkgs.writeText "hm-news.json"
                  (builtins.toJSON { inherit (config.news) display entries; } );
                description = "don't ask";
              };
            })
        ];
      } // nixosDerivedModules;
    in rec {
      # nix-shell
      devShells."${system}" = { default = import ./shell.nix { inherit pkgs; }; };

      nixosConfigurations = {
        deskBocks = import ./hosts/DeskBocks { inherit inputs globals overlays; };  
        junker = import ./hosts/Junker { inherit inputs globals overlays; };
      };
      
      homeConfigurations = {
        deskBocks = nixosConfigurations.deskBocks.config.home-manager.users.${globals.user};
        "${globals.user}@junker" = nixosConfigurations.junker.config.home-manager.users.${globals.user};
      };

      packages = {
        "${system}" = {
          # genuinely, this is not ok
          homeConfigurations = {
            "${globals.user}@junker" = let
              cfg = nixosConfigurations.junker.config.home-manager.users.${globals.user};
            in  {
              activationPackage = cfg.home.activationPackage;  
              config.news.json.output = cfg.news.json.output; 
            };
          };
        };
      };
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
      url = "github:a-clean-kitchen/nvim4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
