{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.waybar;

  inherit (lib) mkIf mkOption types;
  inherit (pkgs) writeShellScript;
in
{
  options.graphical.waybar = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable waybar";
    };
    utilScript = mkOption {
      type = types.path;
      description = "the utility script for all things waybar";
      default = let
        scripted = /*bash*/ ''
        TEMP=$XDG_DATA_HOME/current_wall
        cooldown=0.1
        files=(${config.graphical.wallpapers.images}/*)
        while true
        do 
          case \"$1\" in 
            \"cycle\")
              index=$(cat $TEMP)
              index=$((index+1))
              if [ $index -ge \$\{#files[@]\} ]; then
                index=0
              fi
              echo $index > $TEMP
              ${config.graphical.wallpapers.script}/wall \"\$\{files[$index]}\"
              exit 0
              ;;
            "*")
              echo "gottem"
              ;;
          esac
          sleep $cooldown
        done

        ''; 
      in writeShellScript "wayUtil" scripted;
    };
  };
  

  config = mkIf (cfg.enable && config.graphical.hyprland.enable) {
    home-manager.users.${config.user} = {
      programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            spacing = 5;
            layer = "top";
            position = "top";
            "margin-bottom" = -11;
            "modules-left" = [ "hyprland/workspaces" ];
            "hyprland/workspaces" = {
              format = "{icon}";
              "format-active" = " {icon} ";
            };
            "custom/cycle_wall" = {
              format = "{}";

            };
          };
        };
        style = /*css*/ ''
        * {
            font-family: ${config.bestFont};
            font-size: 13px;
        }

        window#waybar {
            background-color: transparent;
        }

        #workspaces{
            background-color: transparent;
            margin-top: 10px;
            margin-bottom: 10px;
            margin-right: 10px;
            margin-left: 25px;
        }
        #workspaces button{
            box-shadow: rgba(0, 0, 0, 0.116) 2 2 5 2px;
            background-color: #fff ;
            border-radius: 15px;
            margin-right: 10px;
            padding-top: 4px;
            padding-bottom: 2px;
            padding-right: 10px;
            font-weight: bolder;
            color: 	#cba6f7 ;
        }

        #workspaces button.active{
            padding-right: 20px;
            box-shadow: rgba(0, 0, 0, 0.288) 2 2 5 2px;
            text-shadow: 0 0 5px rgba(0, 0, 0, 0.377);
            padding-left: 20px;
            padding-bottom: 3px;
            background: rgb(202,158,230);
            background: linear-gradient(45deg, rgba(202,158,230,1) 0%, rgba(245,194,231,1) 43%, rgba(180,190,254,1) 80%, rgba(137,180,250,1) 100%); 
            background-size: 300% 300%;
            animation: gradient 10s ease infinite;
            color: #fff;
        }
        '';
      };
    };
  };
}
