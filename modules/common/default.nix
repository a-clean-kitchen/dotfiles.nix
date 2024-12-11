{ config, lib, pkgs, ... }: 

let
  inherit (lib) mkOption types mkEnableOption;
in {
  imports = [
    ./git.nix
    ./ssh.nix
    ./repos
    ./shell
    ./applications
  ];

  options = {
    isNixos = mkOption {
      type = types.bool;
      description = "Are you on a Nixos system?";
      default = false;
    };
    user = mkOption {
      type = types.str;
      description = "Primary user of the system";
    };
    fullName = mkOption {
      type = types.str;
      description = "Human readable name of the user";
    };
    homePath = mkOption {
      type = lib.types.path;
      description = "Path of user's home directory.";
      default = builtins.toPath (if pkgs.stdenv.isDarwin then
        "/Users/${config.user}"
      else
        "/home/${config.user}");
    };
    dotfilesPath = mkOption {
      type = types.path;
      description = "Path of dotfiles repository.";
      default = config.homePath + "/wksp/repos/dotfiles";
    };
    dotfilesRepo = mkOption {
      type = types.str;
      description = "Link to dotfiles repository HTTPS URL.";
    };
    unfreePackages = mkOption {
      type = types.listOf lib.types.str;
      description = "List of unfree packages to allow.";
      default = [ ];
    };
    gui = {
      enable = mkEnableOption {
        description = "Enable graphics.";
        default = false;
      };
    };
    hostnames = {
      main = mkOption {
        type = types.str;
        description = "Main domain/site.";
      };
    };
  };

  config = let
    stateVersion = "23.05";
  in {
    environment = {
      sessionVariables = {
        # These are the defaults, and xdg.enable does set them, but due to load
        # order, they're not set before environment.variables are set, which could
        # cause race conditions.
        XDG_CACHE_HOME  = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME   = "$HOME/.local/share";
        XDG_BIN_HOME    = "$HOME/.local/bin";
      };
      systemPackages = with pkgs; [ git tldr wget curl gnumake ];
    };

    home-manager = {
      # Use the system-level nixpkgs instead of Home Manager's
      useGlobalPkgs = true;
      
      # Install packages to /etc/profiles instead of ~/.nix-profile, useful when
      # using multiple profiles for one user
      useUserPackages = true;
      users = {
        ${config.user} = {
          # Pin a state version to prevent warnings
          home = {
            stateVersion = stateVersion;
          };
          news = {
            display = "silent";
            entries = lib.mkForce [];
          };
          # activationPackage = config.home-manager.users.${config.user}.home.activationPackage;
          programs.home-manager.enable = true;
        };
        root.home.stateVersion = stateVersion;
      };
    };

    # Allow specified unfree packages (identified elsewhere)
    # Retrieves package object based on string name
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) config.unfreePackages;
  };
}

