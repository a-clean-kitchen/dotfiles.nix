{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.graphical.waybar;

  inherit (lib) mkIf mkOption types;
in {
  config = mkIf cfg.enable {
    graphical.waybar = {
      moduleSettings = {
        "custom/expand" = {
          tooltip = false;
          format = "{}";
          "on-click" = "${config.graphical.waybar.scripts.expandLockScript}";
          exec = "${config.graphical.waybar.scripts.utilScript} arrow-icon";
        };
      };
    };
  };
}
  
