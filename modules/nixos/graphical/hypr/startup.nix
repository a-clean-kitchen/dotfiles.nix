{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.hyprland.scripts;

  inherit (lib) mkIf mkOption types;
  inherit (pkgs) writeShellScript;
in
{
  options.graphical.hyprland.scripts = {
    xdgNuke = mkOption {
      type = types.path;
      description = "nuclear startup script for xdg portals";
      default = writeShellScript "xdg-nuke"
        ''
          killall=${pkgs.killall}/bin/killall
          portal=${pkgs.xdg-desktop-portal}/bin/xdg-desktop-portal
          portalhyprland=${pkgs.xdg-desktop-portal-hyprland}/bin/xdg-desktop-portal-hyprland
          portalgtk=${pkgs.xdg-desktop-portal-gtk}/bin/xdg-desktop-portal-gtk
          sleep 1
          $killall -e xdg-desktop-portal-hyprland
          $killall -e xdg-desktop-portal-wlr
          $killall xdg-desktop-portal
          $portalhyprland &
          sleep 2
          $portal &
          $portalgtk &
        '';
    };
  };
}
