{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.pulsemixer;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.pulsemixer = {
    enable = mkOption {
      type = types.bool;
      default = config.graphical.enable;
      description = "enable pulsemixer";
    };
  };


  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        highlight
        pulsemixer
      ];
      xdg.desktopEntries."pulsemixer" = {
        exec = "kitty -T pulsemixer pulsemixer";
        name = "pulsemixer";
        genericName = "Terminal";
        terminal = false;
      };
    };
  };
}
