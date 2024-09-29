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
    user = mkOption {
      type = types.str;
      description = "Primary user of the system";
    };
    fullName = mkOption {
      type = types.str;
      description = "Human readable name of the user";
    };
    homePath = lib.mkOption {
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
      default = config.homePath + "/wksp/dotfiles";
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
    
    # Basic common system packages for all devices
    environment.systemPackages = with pkgs; [ git tldr wget curl ];

    # Use the system-level nixpkgs instead of Home Manager's
    home-manager.useGlobalPkgs = true;

    # Install packages to /etc/profiles instead of ~/.nix-profile, useful when
    # using multiple profiles for one user
    home-manager.useUserPackages = true;

    # Allow specified unfree packages (identified elsewhere)
    # Retrieves package object based on string name
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) config.unfreePackages;

    # Pin a state version to prevent warnings
    home-manager.users.${config.user} = {
      # act
      home.stateVersion = stateVersion;
      programs.home-manager.enable = true;
    };

    home-manager.users.root.home.stateVersion = stateVersion;
  };
}

