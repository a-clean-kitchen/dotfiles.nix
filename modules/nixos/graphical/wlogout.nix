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
      default = true;
      description = "enable wlogout";
    };
    
    script = mkOption {
      type = types.path;
      description = "wlogout script";
      default = let
        script = /*bash*/ ''
        A_1080=400
        B_1080=400

        # Check if wlogout is already running
        if ${pkgs.pgrep} -x "wlogout" > /dev/null; then
            pkill -x "wlogout"
            exit 0
        fi

        # Detect monitor resolution and scaling factor
        resolution=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .height / .scale' | awk -F'.' '{print $1}')
        hypr_scale=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .scale')
        wlogout \
          -C $HOME/.config/wlogout/nova.css \
          -l $HOME/.config/wlogout/layout \
          --protocol layer-shell -b 5 \
          -T $(awk "BEGIN {printf \"%.0f\", $A_1080 * 1080 * $hypr_scale / $resolution}") \
          -B $(awk "BEGIN {printf \"%.0f\", $B_1080 * 1080 * $hypr_scale / $resolution}") &
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
    graphical.wlogout.homePath = "~/.config/wlogout/wlogout.sh";
    home-manager.users.${config.user} = {
      xdg.configFile = {
        "${path}/wlogout.sh" = {
          executable = true;
          source = config.graphical.wlogout.script;
        };
        "${path}/icons" = {
          source = ./lockIcons;
          recursive = true;
        };
        "${path}/style.css" = {
          text = /*css*/ ''
          @define-color rosewater #f5e0dc;
          @define-color flamingo #f2cdcd;
          @define-color pink #f5c2e7;
          @define-color mauve #cba6f7;
          @define-color red #f38ba8;
          @define-color maroon #eba0ac;
          @define-color peach #fab387;
          @define-color yellow #f9e2af;
          @define-color green #a6e3a1;
          @define-color teal #94e2d5;
          @define-color sky #89dceb;
          @define-color sapphire #74c7ec;
          @define-color blue #89b4fa;
          @define-color lavender #b4befe;
          @define-color text #cdd6f4;
          @define-color subtext1 #bac2de;
          @define-color subtext0 #a6adc8;
          @define-color overlay2 #9399b2;
          @define-color overlay1 #7f849c;
          @define-color overlay0 #6c7086;
          @define-color surface2 #585b70;
          @define-color surface1 #45475a;
          @define-color surface0 #313244;
          @define-color base #1e1e2e;
          @define-color mantle #181825;
          @define-color crust #11111b;

          window {
              font-family: ${config.bestFont};
              font-size: 16pt;
              color: @base;
              background-color: rgba(24, 27, 32, 0.2);

          } 

          button {
              background-repeat: no-repeat;
              background-position: center;
              background-size: 20%;
              background-color: transparent;
              animation: gradient_f 20s ease-in infinite;
              transition: all 0.3s ease-in;
              box-shadow: 0 0 10px 2px transparent;
              border-radius: 36px;
              margin: 10px;
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

          #hibernate {
              background-image: image(url("./icons/hibernate.png"));
          }
          #hibernate:hover {
            background-image: image(url("./icons/hibernate-hover.png"));
          }
          '';
        };
        "${path}/layout" = {
          text = ''
          {
              "label" : "shutdown",
              "action" : "systemctl poweroff",
              "text" : "Shutdown",
              "keybind" : "s"
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
              "label" : "hibernate",
              "action" : "${pkgs.swaylock} -f && systemctl hibernate",
              "text" : "Hibernate",
              "keybind" : "h"
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
