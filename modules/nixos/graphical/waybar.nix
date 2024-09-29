{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.waybar;

  inherit (lib) mkIf mkOption types;
  inherit (pkgs) writeShellScript;
in
{
  options.graphical.waybar = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable waybar";
      };

      launcherPath = mkOption {
        type = types.path;
        default = writeShellScript "waybar-launcher"
          ''
          waybar
          '';
        description = "path to waybar launcher script";
      };
    };
  

  config = mkIf cfg.enable {
    
  };
}
