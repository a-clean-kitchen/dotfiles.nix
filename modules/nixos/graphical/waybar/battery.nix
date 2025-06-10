{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.graphical.waybar;

  inherit (lib) mkIf mkOption types;
in {
  config = mkIf cfg.enable {
    graphical.waybar = {
      moduleSettings = {
        battery = {
          # Hide it when it's charging
          format-charging = "";
          format-plugged = "";

          states = {
            warning = 50;
            critical = 20;
          };
          "tooltip-format" = "{capacity}% remaining\n{timeTo}";
          format = "{icon}";
          "format-icons" = [" " " " " " " " " "];
        };
      };
      exclusiveModuleStyle = /*css*/ ''
        #battery {
            background-color: #fff;
            color: #a6e3a1;
        }
        #battery.critical:not(.charging) {
            background-color: #f38ba8;
            color: #bf5673;
            animation: blink 0.5s linear infinite alternate;
        }
      '';
    };
  };
}
  
