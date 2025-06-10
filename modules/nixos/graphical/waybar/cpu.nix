{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.graphical.waybar;

  inherit (lib) mkIf mkOption types;
in {
  config = mkIf cfg.enable {
    graphical = {
      waybar = {
        moduleSettings = let
          btopuiScript = "${inputs.sqripts.packages."${config.nixpkgs.hostPlatform.system}".btop-runna}/bin/btop-runna";
        in {
          cpu = {
            interval = 1;
            format = "{icon0} {icon1} {icon2} {icon3}";
            "format-icons" = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
            "on-click" = "${btopuiScript}";
          };
        };
        exclusiveModuleStyle = /*css*/ ''
          #cpu {
              text-shadow: 0 0 5px rgba(0, 0, 0, 0.377);
              color: #fff;
              background-color: #b4befe;
          }
        '';
      };
      hyprland.exclusiveHyprConfig = ''
        windowrulev2 = fullscreen, initialTitle:btop-window
      '';
    };
  };
}
  
