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
        script = /*bash*/ ''
          TEMP=$XDG_DATA_HOME/current_wall
          cooldown=0.1
          files=(${config.graphical.wallpapers.images}/*)
          while true
          do
            case "$1" in 
              "cycle")
                index=$(cat $TEMP)
                index=$((index+1))
                if [ $index -ge ''${#files[@]} ]; then
                  index=0
                fi
                echo $index > $TEMP
                if [[ -e $XDG_DATA_HOME/current_wall_image.png ]]; then rm $XDG_DATA_HOME/current_wall_image.png; fi
                magick convert "''${files[$index]}" $XDG_DATA_HOME/current_wall_image.png
                ${config.graphical.wallpapers.script} "''${files[$index]}"
                exit 0
                ;;
              "arrow-icon")
                if ${config.graphical.waybar.expandStateScript}; then
                    echo "  "
                else
                    echo "  "
                fi
                ;;
              *)
                if ${config.graphical.waybar.expandStateScript}; then
                    echo "     "
                else
                    echo ""
                fi
                ;;
            esac
            sleep $cooldown
          done
        ''; 
      in writeShellScript "wayUtil" script;
    };
    expandStateScript = mkOption {
      type = types.path;
      description = "script to determine expand lock state of waybar";
      default = let
        script = /*bash*/ ''
          LOCK=$XDG_DATA_HOME/expand.lock
          if [ -f "$LOCK" ]; then
              exit 0
          else 
              exit 1
          fi
        '';
      in writeShellScript "toolbar-state" script;
    };
    expandLockScript = mkOption {
      type = types.path;
      description = "script to set expand lock state of waybar";
      default = let
        script = /*bash*/ ''
          LOCK=$XDG_DATA_HOME/expand.lock
          if [ -f "$LOCK" ]; then
              echo expand
              rm -f "$LOCK"
          else 
              echo collapse
              touch "$LOCK"
          fi
        '';
    in writeShellScript "toolbar-lock" script;
    };
  };
  

  config = mkIf (cfg.enable && config.graphical.hyprland.enable) {
    home-manager.users.${config.user} = {
      programs.waybar = {
        enable = true;
        settings = {
          mainBar = let
            # disable hover
            tooltip = false;
          in  {
            reload_style_on_change = true;
            spacing = 5;
            layer = "top";
            position = "top";
            "margin-bottom" = -15;
            "modules-left" = [ "hyprland/workspaces" ];
            "modules-right" = [ "custom/cycle_wall" "custom/expand" "cpu" "battery" ];
            "hyprland/workspaces" = {
              format = "{icon}";
              "format-active" = " {icon} ";
            };
            "custom/cycle_wall" = {
              inherit tooltip;
              format = "{}";
              "on-click" = "${config.graphical.waybar.utilScript} cycle";
              exec = "${config.graphical.waybar.utilScript} wall";
            };
            "custom/expand" = {
              inherit tooltip;
              format = "{}";
              "on-click" = "${config.graphical.waybar.expandLockScript}";
              exec = "${config.graphical.waybar.utilScript} arrow-icon";
            };
            cpu = {
              interval = 1;
              format = "{icon0} {icon1} {icon2} {icon3}";
              "format-icons" = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
            };
            battery = {
              # Hide it when it's charging
              format-charging = "";
              format-plugged = "";

              states = {
                warning = 50;
                critical = 20;
              };
              format = "{icon}";
              "format-icons" = [" " " " " " " " " "];
            };
            "idle_inhibitor" = {
              inherit tooltip;
              format = "{icon}";
              "format-icons" = {
                activated = "";
                deactivated = "";
              };
            };
          };
        };
        style = /*css*/ ''
        * {
            font-family: ${config.bestFont};
            font-size: 13px;
        }

        @keyframes gradients {
          0% {
            background-position: 0% 50%;
          }
          50% {
            background-position: 100% 50%;
          }
          100% {
            background-position: 0% 50%;
          }
        }

        window#waybar {
            background-color: transparent;
        }

        #workspaces {
            background-color: transparent;
            margin-top: 10px;
            margin-bottom: 10px;
            margin-right: 10px;
            margin-left: 25px;
        }

        #workspaces button {
            box-shadow: rgba(0, 0, 0, 0.116) 2px 2px 5px 2px;
            background-color: #fff ;
            border-radius: 15px;
            margin-right: 10px;
            padding-top: 4px;
            padding-bottom: 2px;
            padding-right: 10px;
            font-weight: bolder;
            color: 	#cba6f7 ;
        }

        #workspaces button.active {
            padding-right: 20px;
            box-shadow: rgba(0, 0, 0, 0.288) 2px 2px 5px 2px;
            text-shadow: 0 0 5px rgba(0, 0, 0, 0.377);
            padding-left: 20px;
            padding-bottom: 3px;
            background: rgb(202,158,230);
            background: linear-gradient(45deg, rgba(202,158,230,1) 0%, rgba(245,194,231,1) 43%, rgba(180,190,254,1) 80%, rgba(137,180,250,1) 100%); 
            background-size: 300% 300%;
            animation: gradient 10s ease infinite;
            color: #fff;
        }
        
        #cpu,
        #battery,
        #custom-cycle_wall,
        #custom-expand {
            padding: 0 10px;
            border-radius: 15px;
            background-color: #cdd6f4;
            color: #516079;
            box-shadow: rgba(0, 0, 0, 0.116) 2px 2px 5px 2px;
            margin-top: 10px;
            margin-bottom: 10px;
            margin-right: 10px;
        }

        #custom-cycle_wall {
            background: rgb(245,194,231);
            background: linear-gradient(45deg, rgba(245,194,231,1) 0%, rgba(203,166,247,1) 0%, rgba(243,139,168,1) 13%, rgba(235,160,172,1) 26%, rgba(250,179,135,1) 34%, rgba(249,226,175,1) 49%, rgba(166,227,161,1) 65%, rgba(148,226,213,1) 77%, rgba(137,220,235,1) 82%, rgba(116,199,236,1) 88%, rgba(137,180,250,1) 95%); 
            color: #fff;
            background-size: 500% 500%;
            animation: gradient 7s linear infinite;
            font-weight:  bolder;
            padding: 5px;
            border-radius: 15px;
        }

        #cpu {
            background: rgb(180,190,254);
            background: linear-gradient(52deg, rgba(180,190,254,1) 0%, rgba(137,220,235,1) 32%, rgba(137,180,250,1) 72%, rgba(166,227,161,1) 100%); 
            background-size: 300% 300%;
            animation: gradient 20s ease infinite;
            text-shadow: 0 0 5px rgba(0, 0, 0, 0.377);
            /* background-color: #b4befe; */
            color: 	#fff;
        }

        #battery.charging, #battery.plugged {
            background-color: #94e2d5 ;
        }

        #battery {
            background-color: #fff;
            color:#a6e3a1;
            font-weight: bolder;
            font-size: 20px;
            padding-left: 15px;
            padding-right: 10px;
        }

        @keyframes blink {
            to {
                background-color: #f9e2af;
                color:#96804e;
            }
        }

        #battery.critical:not(.charging) {
            background-color:  #f38ba8;
            color:#bf5673;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }
        '';
      };
    };
  };
}
