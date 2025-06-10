{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.blender;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.blender = {
    enable = mkOption {
      type = types.bool;
      default = config.graphical.enable;
      description = "enable blender";
    };
  };

  config = mkIf cfg.enable {
    unfreePackages = [
      "blender"
    ];

    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ blender ];
      xdg.desktopEntries."blender" = {
        exec = "blender %u";
        name = "blender";
        terminal = false;
      };
    };
  };
}
