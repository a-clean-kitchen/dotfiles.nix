{ config, lib, pkgs, ... }:
let
  cfg = config.graphical.waybar;

  inherit (lib) mkIf mkOption types;
  inherit (pkgs) writeShellScript;

  jsonFormat = pkgs.formats.json { };
in {
  imports = [
    ./styles.nix

    ./cpu.nix
    ./expand.nix
    ./battery.nix
    ./network.nix
    ./bluetoof.nix
    ./cycleWall.nix
    ./idleToggle.nix
    ./pulseaudio.nix
    ./hyprWorkspaces.nix
  ];

  options.graphical.waybar = {
    enable = mkOption {
      type = types.bool;
      default = false; # config.graphical.enable;
      description = "enable waybar";
    };

    moduleSettings = mkOption {
      type = jsonFormat.type;
      visible = false;
      default = null;
      description = "My module configurations.";
    };

    exclusiveModuleStyle = mkOption {
      type = types.lines;
      default = "";
      description = "exclusive module style";
    };

    scripts = {
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
                  if ${config.graphical.waybar.scripts.expandStateScript}; then
                      echo "  "
                  else
                      echo "  "
                  fi
                  ;;
                *)
                  if ${config.graphical.waybar.scripts.expandStateScript}; then
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
  };

  config = mkIf (cfg.enable && config.graphical.hyprland.enable) {
    home-manager.users.${config.user} = {
      programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            reload_style_on_change = true;
            spacing = 5;
            layer = "top";
            position = "top";
            "margin-bottom" = -15;
            "modules-left" = [ "hyprland/workspaces" ];
            "modules-right" = [ 
              "custom/bluetoof"
              "custom/cycle_wall"
              "custom/idle_inhibitor"
              "custom/expand" 
              "pulseaudio"
              "cpu" 
              "network"
              "battery" 
            ];
          } // cfg.moduleSettings;
        };
      };
    };
  };
}
