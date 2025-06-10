{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.wlogout;

  inherit (lib) mkIf mkOption types;
  inherit (pkgs) writeShellScript;
in
{
  options.graphical.wlogout = {
    enable = mkOption {
      type = types.bool;
      default = config.graphical.enable;
      description = "enable wlogout";
    };
    
    script = mkOption {
      type = types.path;
      description = "wlogout script";
      default = let
        script = /*bash*/ ''
        # Check if wlogout is already running
        if pgrep -x "wlogout" > /dev/null; then
          pkill -x "wlogout"
          exit 0
        fi

        height=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .height')
        Vmargin=$((($height / 2) - 100))

        width=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .width')
        Hmargin=$((($width / 2) - 550))

        wlogout \
        --protocol layer-shell -b 5 \
        -L $Hmargin -R $Hmargin \
        -T $Vmargin -B $Vmargin &
        '';
      in writeShellScript "wlogout.sh" script;
    };
    homePath = mkOption {
      type = types.str;
      description = "home based path to wlogout script";
    };
  };
  

  config = let
    path = "wlogout";
  in mkIf (cfg.enable && config.graphical.hyprland.enable) {
    graphical.wlogout.homePath = ".config/wlogout/wlogout.sh";
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        wlogout
      ];
      xdg.configFile = {
        "${path}/wlogout.sh" = {
          executable = true;
          source = config.graphical.wlogout.script;
        };
        "${path}/icons" = {
          source = ../../../assets/lockIcons;
          recursive = true;
        };
        "${path}/style.css" = {
          text = /*css*/ ''
          @import '../css/base.css';

          * {
            all: unset;
          }

          window {
            font-family: ${config.bestFont};
            font-size: 16pt;
            background-color: rgba(24, 27, 32, 0.1);
          } 

          button {
            min-width: 200px;
            min-height: 200px;
            background-repeat: no-repeat;
            background-position: center;
            background-size: 20%;
            background-color: transparent;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s ease-in;
            box-shadow: 0 0 10px 2px transparent;
            border-radius: 36px;
            border: 0;
            margin: 10px;
            color: @text;
          }

          button:focus {
            box-shadow: none;
            background-size : 20%;
          }

          button:hover {
            background-size: 50%;
            box-shadow: 0 0 10px 3px rgba(0,0,0,.4);
            background-color: @pink;
            color: transparent;
            transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
          }

          #shutdown {
            background-image: image(url("./icons/power.png"));
          }
          #shutdown:hover {
            background-image: image(url("./icons/power-hover.png"));
          }

          #logout {
            background-image: image(url("./icons/logout.png"));

          }
          #logout:hover {
            background-image: image(url("./icons/logout-hover.png"));
          }

          #reboot {
            background-image: image(url("./icons/restart.png"));
          }
          #reboot:hover {
            background-image: image(url("./icons/restart-hover.png"));
          }

          #lock {
            background-image: image(url("./icons/lock.png"));
          }
          #lock:hover {
            background-image: image(url("./icons/lock-hover.png"));
          }

          #sleep {
            background-image: image(url("./icons/sleep.png"));
          }
          #sleep:hover {
            background-image: image(url("./icons/sleep-hover.png"));
          }
          '';
        };
        "${path}/layout" = {
          text = ''
          {
              "label" : "shutdown",
              "action" : "systemctl poweroff",
              "text" : "Shutdown",
              "keybind" : "u"
          }
          {
              "label" : "reboot",
              "action" : "systemctl reboot",
              "text" : "Reboot",
              "keybind" : "r"
          }
          {
              "label" : "logout",
              "action" : "loginctl kill-session $XDG_SESSION_ID",
              "text" : "Logout",
              "keybind" : "e"
          }
          {
              "label" : "sleep",
              "action" : "loginctl lock-session && systemctl sleep # && hyprctl dispatch dpms on",
              "text" : "Sleep",
              "keybind" : "s"
          }
          {
              "label" : "lock",
              "action" : "hyprlock",
              "text" : "Lock",
              "keybind" : "l"
          }
          '';
        };
      };
    };
  };
}
