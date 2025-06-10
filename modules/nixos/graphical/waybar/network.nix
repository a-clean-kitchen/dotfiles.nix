{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.graphical.waybar;

  inherit (lib) mkIf mkOption types;
in {
  config = mkIf cfg.enable {
    graphical = {
      waybar = {
        moduleSettings = {
          network = let 
            netScript = "${inputs.sqripts.packages."${config.nixpkgs.hostPlatform.system}".impala-runna}/bin/impala-runna";
          in {
            interface = "wlan0";
            format = "{ifname}";
            "format-icons" = ["󰤫 " "󰤠 " "󰤢 " "󰤨 "];
            "format-wifi" = "{icon}";
            "format-ethernet" = " ";
            "format-disconnected" = "";
            "tooltip-format" = "{ifname} via {gwaddr} 󰊗";
            "tooltip-format-wifi" = "{essid} ({signalStrength}%)\nUP: {bandwidthUpBytes}\nDOWN: {bandwidthDownBytes}\nGW: {gwaddr}";
            "tooltip-format-ethernet" = "{ifname} {ipaddr}/{cidr}\nUP: {bandwidthUpBytes}\nDOWN: {bandwidthDownBytes}\nGW: {gwaddr}";
            "tooltip-format-disconnected" = "Disconnected";
            "max-length" = 50;
            "on-click" = "${netScript}";
          };
        };
      };
      hyprland.exclusiveHyprConfig = ''
          windowrulev2 = float, initialTitle:impala-window
          windowrulev2 = move center, initialTitle:impala-window
          windowrulev2 = size 960 720, initialTitle:impala-window
      '';
    };
  };
}
  
