{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.yazi;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.yazi = {
    enable = mkOption {
      type = types.bool;
      default = config.graphical.enable;
      description = "enable yazi";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        highlight
      ];
      programs.yazi = {
        enable = true;
        enableFishIntegration = true;
      };
      xdg.desktopEntries."yazi" = {
        exec = "kitty -T yazi yazi";
        name = "yazi";
        genericName = "Terminal";
        terminal = false;
      };
    };
  };
}
