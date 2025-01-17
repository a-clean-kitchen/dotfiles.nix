{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
in {
  config = mkIf (config.isNixos) {
    environment.systemPackages = with pkgs; [
      fzf
    ];
    services.greetd = {
      enable = true;
      settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet -w 40 -t --cmd Hyprland";
          };
        };
    };
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      # Without this errors will spam on screen
      StandardError = "journal";
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
