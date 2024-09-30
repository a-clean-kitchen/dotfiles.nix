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
        default = true;
        description = "enable wallpapers";
      };
      
      script = mkOption {
        type = types.path;
        default = writeShellScript "wall"
          ''
          swww=${pkgs.swww}/bin/swww

          $swww-daemon &
          $swww img $1 --transition-type grow --transition-duration 3 --transition-pos "$(hyprctl cursorpos)"
          '';
        description = "script to manage wallpapers";
      };

      images = mkOption {
        type = types.path;
        default = ./wallpapers;
        description = "directory with all the actual wallpaper images";
      };
    };
  

  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      xdg.configFile."hypr/wallpapers" = {
        source = config.graphical.wallpapers.images;
        recursive = true;
      };
    };
  };
}
