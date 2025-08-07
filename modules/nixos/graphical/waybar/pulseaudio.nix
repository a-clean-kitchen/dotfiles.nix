{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.graphical.waybar;

  inherit (lib) mkIf mkOption types;
in {
  config = mkIf cfg.enable {
    graphical = {
      waybar = {
        moduleSettings = {
          pulseaudio = let
            volScript = "${inputs.sqripts.packages."${config.nixpkgs.hostPlatform.system}".volume}/bin/volume";
          in {
            format = "{icon}";
            "format-bluetooth" = "{icon}";
            "format-muted" = " ";
            "format-icons" = {
              "alsa_output.pci-0000_00_1f.3.analog-stereo" = " ";
              "alsa_output.pci-0000_00_1f.3.analog-stereo-muted" = " ";
              "headphone" = " ";
              "hands-free" = "󰋎 ";
              "headset" = "󰋎 ";
              "phone" = " ";
              "phone-muted" = " ";
              "portable" = " ";
              "car" = " ";
              "default" = [" " "  "];
            };
            "scroll-step" = 1;
            "on-click" = "${volScript} TUI";
            "ignored-sinks" = ["Easy Effects Sink"];
          };
        };
        exclusiveModuleStyle = /*css*/ ''
          #pulseaudio {
            background-color: #f8aa6a;
            color: #fff;
            padding: 0 10px 0 20px;
            font-weight: bolder;
            font-size: 20px;
          }
        '';
      };
      hyprland.exclusiveHyprConfig = ''
        windowrulev2 = float, initialTitle:pulsemixer-window
        windowrulev2 = move center, initialTitle:pulsemixer-window
        windowrulev2 = size 800 600, initialTitle:pulsemixer-window
      '';
    };
  };
}
  
