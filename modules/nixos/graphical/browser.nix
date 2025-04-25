{ config, lib, pkgs, ... }:

let
  cfg = config.browser;

  inherit (lib) mkIf mkOption types;
in
{
  options.browser = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable chromium browser";
      };
    };
  

  config = mkIf (cfg.enable && config.gui.enable) {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        zen-browser

        # enable chromecasting
        fx-cast-bridge
      ];

      xdg.desktopEntries."zen" = {
        exec = "zen %U";
        name = "zen";
        genericName = "Web Browser";
        terminal = false;
        categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [ "text/html" "text/xml" ];
      };
    };
  };
}
