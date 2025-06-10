{ config, lib, pkgs, ... }:

# This module is not used atm.
# Still deciding if I want to migrate to ghostty.
let
  cfg = config.graphical.ghostty;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.ghostty = {
    enable = mkOption {
      type = types.bool;
      default = config.graphical.enable;
      description = "enable ghostty";
    };
  };


  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        ghostty
      ];
      # xdg.desktopEntries."ghostty" = {
      #   exec = "ghostty";
      #   name = "ghostty";
      #   genericName = "Terminal";
      #   terminal = false;
      # };
    };
  };
}
