{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.graphical.waybar;

  inherit (lib) mkIf mkOption types;
in {
  config = mkIf cfg.enable {
    graphical = {
      waybar = {
        moduleSettings = {
          "custom/bluetoof" = let
            script = "${inputs.sqripts.packages."x86_64-linux".bluetooth}/bin/bluetooth";
          in
          {
            format = "{}";
            "return-type" = "json";
            "on-click" = "${script} TUI";
            "on-click-right" = "${script} TOGGLE && sleep 2";
            exec = "${script} WAYBAR";
          };      
        };
        exclusiveModuleStyle = /*css*/ ''
          #custom-bluetoof {
              padding: 0px 15px 0 15px;
          }
        '';
      };
      hyprland.exclusiveHyprConfig = ''
        windowrulev2 = float, initialTitle:bluetui-window
        windowrulev2 = pin, initialTitle:bluetui-window
        windowrulev2 = move center, initialTitle:bluetui-window
        windowrulev2 = size 600 450, initialTitle:bluetui-window
      '';
    };
  };
}
  
