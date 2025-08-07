{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.graphical.waybar;

  inherit (lib) mkIf mkOption types;
in {
  config = mkIf cfg.enable {
    graphical.waybar = {
      moduleSettings = {
        "custom/cycle_wall" = {
          tooltip = false;
          format = "{}";
          "on-click" = "${config.graphical.waybar.scripts.utilScript} cycle";
          exec = "${config.graphical.waybar.scripts.utilScript} wall";
        };
      };
      exclusiveModuleStyle = /*css*/ ''
        #custom-cycle_wall {
            background: linear-gradient(45deg, rgba(245,194,231,1) 0%, rgba(203,166,247,1) 0%, rgba(243,139,168,1) 13%, rgba(235,160,172,1) 26%, rgba(250,179,135,1) 34%, rgba(249,226,175,1) 49%, rgba(166,227,161,1) 65%, rgba(148,226,213,1) 77%, rgba(137,220,235,1) 82%, rgba(116,199,236,1) 88%, rgba(137,180,250,1) 95%);
            color: #fff;
            background-size: 500% 500%;
            animation: gradient 7s linear infinite;
            font-weight: bolder;
            padding: 5px;
            border-radius: 15px;
        }
      '';
    };
  };
}
  