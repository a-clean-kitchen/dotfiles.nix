{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.youtube-tui;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.youtube-tui = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable youtube-tui";
    };
  };


  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        youtube-tui
        catt
      ];
      xdg.desktopEntries."youtube-tui" = {
        exec = "kitty youtube-tui";
        name = "youtube-tui";
        genericName = "Terminal";
        terminal = false;
      };
    };
  };
}
