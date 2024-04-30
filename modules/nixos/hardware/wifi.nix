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
  

  config = mkIf (cfg.enable && config.physical && !config.networking.networkmanager.enable) {
    # Enables wireless support via wpa_supplicant.
    networking.wireless.iwd = {
      enable = true;
      settings = {
        Settings = {
          AutoConnect = true;
        };
      };
    };

    home-manager.users.${config.user}.home.packages = with pkgs; [ iwgtk ];
    
    # Allows the user to control the WiFi settings.
    networking.wireless.userControlled.enable = true; 
  };
}
