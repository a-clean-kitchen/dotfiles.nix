{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.hypridle;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.hypridle = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable hypridle";
      };
    };
  

  config = mkIf (cfg.enable && config.graphical.hyprland.enable) {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        hypridle
      ];
      xdg.configFile = {
        "hypr/hypridle.conf" = {
          text = /*hyprlang*/ ''
          general {
              # lock_cmd = notify-send "lock!"          # dbus/sysd lock command (loginctl lock-session) 
              # unlock_cmd = notify-send "unlock!"      # same as above, but unlock
              ignore_dbus_inhibit = false             # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
              lock_cmd = pidof hyprlock || hyprlock # avoid starting multiple hyprlock instances.
              before_sleep_cmd = loginctl lock-session    # lock before suspend.
              after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
          }

          # Screenlock
          listener {
              timeout = 180                            # in seconds
              on-timeout = hyprlock # command to run when timeout has passed
              # on-resume = notify-send "Welcome back to your desktop!"  # command to run when activity is detected after timeout has fired.
          }

          # Suspend
          listener {
              timeout = 360                            # in seconds
              on-timeout = systemctl suspend # command to run when timeout has passed
              # on-resume = notify-send "Welcome back to your desktop!"  # command to run when activity is detected after timeout has fired.
          }
          '';
        };
      };

    };
    
  };
}
