{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.ranger;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.ranger = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable ranger";
    };
  };


  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        highlight
      ];
      programs.ranger = {
        enable = true;
        extraConfig = ''
          set preview_images_method kitty
        '';
      };
      xdg.desktopEntries."ranger" = {
        exec = "kitty -T ranger ranger";
        name = "ranger";
        genericName = "Terminal";
        terminal = false;
      };
    };
  };
}
