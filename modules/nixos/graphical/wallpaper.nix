{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.wallpapers;

  inherit (lib) mkIf mkOption types;
  inherit (pkgs) writeShellScript;
in
{
  options.graphical.wallpapers = {
      enable = mkOption {
        type = types.bool;
        default = config.graphical.enable;
        description = "enable wallpapers";
      };
      
      script = mkOption {
        type = types.path;
        default = writeShellScript "wall"
          ''
          swww=${pkgs.swww}/bin/swww

          case "$1" in
            "init")
              $swww-daemon &
              $swww img $2 --transition-type grow --transition-duration 3 --transition-pos "$(hyprctl cursorpos)" --invert-y &
              ;;
            *)
              sleep 1
              $swww img $1 --transition-type grow --transition-duration 3 --transition-pos "$(hyprctl cursorpos)" --invert-y &
              ;;
          esac
          '';
        description = "script to manage wallpapers";
      };

      images = mkOption {
        type = types.path;
        default = ../../../assets/wallpapers;
        description = "directory with all the actual wallpaper images";
      };
    };
  

  config = mkIf (cfg.enable && config.graphical.hyprland.enable) {
    home-manager.users.${config.user} = {
      home.file."Pictures/wallpapers" = {
        source = config.graphical.wallpapers.images;
        recursive = true;
      };
    };
  };
}
