{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.hyprlock;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.hyprlock = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable hyprlock";
      };
    };
  

  config = mkIf (cfg.enable && config.graphical.hyprland.enable) {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        hyprlock
      ];
      home.file."Pictures/lockpapers" = {
        source = ./lockPapers;
        recursive = true;
      };
      xdg.configFile = {
        "hypr/hyprlock.conf" = {
          text = /*hyprlang*/ ''
          general {
              hide_cursor = true
              fractional_scaling = 1
          }

          background {
              monitor =
              path = $HOME/Pictures/lockpapers/starry-clouds.png
              blur_size = 4
              blur_passes = 1 # 0 disables blurring
              noise = 0.0117
              contrast = 1.3000 # Vibrant!!!
              brightness = 0.8000
              vibrancy = 0.2100
              vibrancy_darkness = 0.0
          }

          # Hours
          label {
              monitor =
              text = cmd[update:1000] echo "<b><big> $(date +"%H") </big></b>"
              color = rgb(cba6f7)
              font_size = 112
              font_family = CascadiaCode
              shadow_passes = 3
              shadow_size = 4

              position = 0, 220
              halign = left
              valign = center
          }

          # Minutes
          label {
              monitor =
              text = cmd[update:1000] echo "<b><big> $(date +"%M") </big></b>"
              color = rgb(cba6f7)
              font_size = 112
              font_family = CascadiaCode
              shadow_passes = 3
              shadow_size = 4

              position = 0, 80
              halign = left
              valign = center
          }

          # Day of week
          label {
              monitor =
              text = cmd[update:18000000] echo "<b><big> "$(date +'%A')" </big></b>"
              color = rgb(cdd6f4)
              font_size = 22
              font_family = CascadiaCode

              position = 85, 0
              halign = left
              valign = center
          }

          # Month and it's day
          label {
              monitor =
              text = cmd[update:18000000] echo "<b> "$(date +'%d %b')" </b>"
              color = rgb(cdd6f4)
              font_size = 22
              font_family = CascadiaCode

              position = 85, -25
              halign = left
              valign = center
          }

          input-field {
              monitor =
              font_family = CascadiaCode
              size = 1, 50
              outline_thickness = 10
              placeholder_text = <i></i>
              hide_input = true
              rounding = -1
              outer_color = rgb(f5c2e7)
              inner_color = rgb(1e1e2e)
              fade_on_empty = true

              position = -50, 50
              halign = right
              valign = bottom
          }
          '';
        };
      };

    };
  };
}
