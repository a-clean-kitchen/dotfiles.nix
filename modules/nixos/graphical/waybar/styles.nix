{ config, lib, ... }:
let
  cfg = config.graphical.waybar;

  inherit (lib) mkIf;
in
{
  home-manager.users.${config.user} = {
    programs.waybar = mkIf cfg.enable {
      style = /*css*/ ''
        * {
          font-family: ${config.bestFont};
          font-size: 13px;
        }

        @keyframes blink {
            to {
                background-color: #f9e2af;
                color:#96804e;
            }
        }

        window#waybar {
            background-color: transparent;
        }

        #cpu,
        #battery,
        #custom-cycle_wall,
        #custom-expand,
        #custom-bluetoof,
        #network,
        #custom-idle_inhibitor,
        #pulseaudio {
            padding: 0 10px;
            border-radius: 15px;
            box-shadow: rgba(0, 0, 0, 0.116) 2px 2px 5px 2px;
            margin: 10px 5px 10px 0px;
            background-color: #cdd6f4;
            /* color: #516079; */
        }

        #battery,
        #network {
            padding: 0 10px 0 15px;
            font-weight: bolder;
            font-size: 20px;
        }

        #battery.charging, 
        #battery.plugged {
            background-color: #94e2d5;
        }

        /* Network and Bluetooth status styles */
        #custom-bluetoof.off,
        #network.disconnected,
        #network.disabled,
        #custom-idle_inhibitor.off {
            background-color: #f38ba8;
            font-weight: bolder;
            font-size: 20px;
            color: #fff;
        }

        #custom-bluetoof.on,
        #network.linked,
        #network.wifi,
        #network.ethernet,
        #custom-idle_inhibitor.on {
            background-color: #94e2d5;
            font-weight: bolder;
            font-size: 20px;
            color: #fff;
        }

        /* exclusive module styles */
        ${cfg.exclusiveModuleStyle}
      '';
    };
  };
}
