{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.graphical.waybar;

  inherit (lib) mkIf mkOption types;
in {
  config = mkIf cfg.enable {
    graphical.waybar = {
      moduleSettings = {
        "hyprland/workspaces" = {
          format = "{icon}";
          "format-active" = " {icon} ";
        };
      };
      exclusiveModuleStyle = /*css*/ ''
        #workspaces {
            /* background-color: transparent; */
            margin: 10px 5px 10px 5px;
        }

        #workspaces button {
            box-shadow: rgba(0, 0, 0, 0.116) 2px 2px 5px 2px;
            background-color: #fff;
            border-radius: 15px;
            margin-right: 10px;
            padding: 4px 10px 2px;
            font-weight: bolder;
            color: #cba6f7;
        }

        #workspaces button.active {
            box-shadow: rgba(0, 0, 0, 0.288) 2px 2px 5px 2px;
            text-shadow: 0 0 5px rgba(0, 0, 0, 0.377);
            padding: 4px 20px 3px;
            background: linear-gradient(45deg, rgba(202,158,230,1) 0%, rgba(245,194,231,1) 43%, rgba(180,190,254,1) 80%, rgba(137,180,250,1) 100%);
            background-size: 300% 300%;
            animation: gradient 10s ease infinite;
            color: #fff;
        }
      '';
    };
  };
}
  