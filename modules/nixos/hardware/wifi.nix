{ config, lib, pkgs, ... }:

let
  cfg = config.wifi;

  inherit (lib) mkIf mkOption types;
in
{
  options.wifi = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "enable wifi";
      };
    };
  

  config = mkIf (cfg.enable && config.physical) {
    networking = {
      wireless.iwd = {
        enable = true;
        settings = {
          Settings = {
            AutoConnect = true;
          };
        };
      };
      networkmanager = {
        wifi.backend = "iwd";
      };
    };

    # environment.systemPackages = [ pkgs.iwgtk ];
    # Allows the user to control the WiFi settings.
    networking.wireless.userControlled.enable = true; 
  };
}
