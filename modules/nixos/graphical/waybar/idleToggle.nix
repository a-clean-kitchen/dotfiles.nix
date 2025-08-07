{ config, lib, inputs, ... }:

let 
  cfg = config.graphical.waybar;

  inherit (lib) mkIf;
in {
  config = mkIf cfg.enable {
    graphical.waybar = {
      moduleSettings = let 
        toggleScript = "${inputs.sqripts.packages."${config.nixpkgs.hostPlatform.system}".idle-toggle}/bin/idle-toggle";
      in {
        "custom/idle_inhibitor" = {
          format = "{}";
          "return-type" = "json";
          exec = "${toggleScript} WAYBAR";
          "on-click" = "${toggleScript} TOGGLE";
        };
      };
    };
  };
}