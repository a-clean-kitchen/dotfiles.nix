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
        publicKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQcdy3fe9wP0zmx/TMPcZ3r4b38sitxg3ieTSkPbvju qm@junkr"
        ];
      };

      system = "x86_64-linux";
      
      overlays = [
        (import ./overlays/nvim4.nix inputs)
        (import ./overlays/zen-browser.nix inputs)
        (import ./overlays/network-manager.nix inputs)
        # (import ./overlays/ghostty.nix inputs) # will re-visit eventually
      ];

      # # Extend lib with personal functions
      # lib = nixpkgs.lib.extend
      #   (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in rec {
      # nix-shell
      devShells."${system}" = { default = import ./shell.nix { inherit pkgs; }; };

      nixosConfigurations = {
        deskBocks = import ./hosts/DeskBocks { inherit inputs globals overlays; };  
        junker = import ./hosts/Junker { inherit inputs globals overlays; };
        junkr = import ./hosts/Junkr { inherit inputs globals overlays; };
      };
      
      homeConfigurations = {
        "${globals.user}@deskBocks" = nixosConfigurations.deskBocks.config.home-manager.users.${globals.user};
        "${globals.user}@junkr" = nixosConfigurations.junkr.config.home-manager.users.${globals.user};
      };

      packages = {
        "${system}" = {
          # genuinely, this is not ok
          homeConfigurations = {
            "${globals.user}@junkr" = let
              cfg = nixosConfigurations.junkr.config.home-manager.users.${globals.user};
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
      # url = "github:a-clean-kitchen/nvim4";
      url = "git+file:///home/qm/wksp/repos/nvim4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    network-manager = {
      url = "git+https://github.com/Blazzzeee/network_manager_ui?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Not in nixpkgs yet
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # kept safe and away!
    my-secrets = {
      url = "git+ssh://git@github.com/a-clean-kitchen/seqrets.git?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sqripts = {
      url = "git+file:///home/qm/wksp/repos/sqripts";
      # url = "github:a-clean-kitchen/sqripts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
