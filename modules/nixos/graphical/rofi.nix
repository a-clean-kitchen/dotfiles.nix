{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.rofi;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.rofi = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable rofi";
      };
    };
  

  config = mkIf (cfg.enable && config.graphical.hyprland.enable) {
    # home-manager
  };
}
