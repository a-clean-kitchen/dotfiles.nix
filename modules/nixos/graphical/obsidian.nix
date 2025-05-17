{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.obsidian;

  inherit (lib) mkIf mkOption types;
in
{
  # imports = [
  #   ../../prerolls/obsidian.preroll.nix
  # ];
  options.graphical.obsidian = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable obsidian";
    };
  };


  config = mkIf cfg.enable {
    unfreePackages = [
      "obsidian"
    ];

    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        obsidian
      ];
      xdg.desktopEntries."obsidian" = {
        exec = "obsidian %u";
        name = "obsidian";
        terminal = false;
      };
    };
  };
}
