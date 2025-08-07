{ config, lib, pkgs, ... }:

let
  cfg = config.browser;

  inherit (lib) mkIf mkOption types;
in
{
  options.browser = {
    enable = mkOption {
      type = types.bool;
      default = config.graphical.enable;
      description = "enable chromium browser";
    };
  };

  config = mkIf (cfg.enable && config.graphical.enable) {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        zen-browser
      ];

      xdg.desktopEntries."zen" = {
        exec = "zen %U";
        name = "zen";
        genericName = "Web Browser";
        categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" ];
      };
    };
    graphical.hyprland.exclusiveHyprConfig = ''
        windowrulev2 = float, initialTitle:Picture-in-Picture
        windowrulev2 = pin, initialTitle:Picture-in-Picture
        windowrulev2 = move top right, initialTitle:Picture-in-Picture
        windowrulev2 = size 320 180, initialTitle:Picture-in-Picture
        windowrulev2 = opacity 1.0 override 1.0 override, initialTitle:Picture-in-Picture
        windowrulev2 = opacity 1.0 override 1.0 override, initialTitle:^(Zen Browser)$

    '';
  };
}
