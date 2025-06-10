{ inputs, config, lib, pkgs, ... }:

let
  cfg = config.graphical.runbars;

  inherit (lib) mkIf mkOption types;
  inherit (pkgs) writeShellScript;
in
{
  config = mkIf (cfg.enable) {
    graphical.hyprland.exclusiveHyprConfig = let 
      launchScript = "${inputs.sqripts.packages."${config.nixpkgs.hostPlatform.system}".launcher}/bin/launcher";
    in ''
      bind = $mainMod, space, exec, ${launchScript}
    '';
    home-manager.users.${config.user} = {
      xdg = {
        # DON'T SHOW UP ON MY APP RUNNER YOU STUPID UGLY DESKTOP APPS
        desktopEntries = {
          "mpv" = {
            name = "mpv";
            noDisplay = true;
          };
          "fish" = {
            name = "fish";
            noDisplay = true;
          };
          "rofi" = {
            name = "Rofi";
            noDisplay = true;
            settings = {
              Version = "1.0";
            };
          };
          "nvim" = {
            name = "nvim";
            noDisplay = true;
          };
          "nixos-manual" = {
            name = "nixos-manual";
            noDisplay = true;
          };
          "Windsurf" = {
            name = "Windsurf";
            noDisplay = true;
          };
          "rofi-theme-selector" = {
            name = "Rofi Theme Selector";
            noDisplay = true;
            settings = {
              Version = "1.0";
            };
          };
        };
        dataFile = {
          "applications/rofi.desktop".text = ''
            [Desktop Entry]
            Name=Rofi
            NoDisplay=true
            Terminal=false
            Type=Application
            Version=1.0
          '';
          "applications/rofi-theme-selector.desktop".text = ''
            [Desktop Entry]
            Name=Rofi Theme Selector
            NoDisplay=true
            Terminal=false
            Type=Application
            Version=1.0
          '';
        };
      };
    };
  };
}
