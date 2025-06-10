{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.runbars;

  inherit (lib) mkIf mkOption types;
  inherit (pkgs) writeShellScript;
in
{
  imports = [
    ./app.nix
    ./projdrop.nix
  ];

  options.graphical.runbars = {
    enable = mkOption {
      type = types.bool;
      default = config.graphical.enable;
      description = "enable the various runbars";
    };
  };
  

  config = mkIf (cfg.enable && config.graphical.hyprland.enable) {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        rofi-wayland
      ];
    };
  };
}
