{ config, lib, pkgs, ... }:
let
  cfg = config.graphical.eww;

  inherit (lib) mkIf mkOption types;
  inherit (pkgs) writeShellScript;

  jsonFormat = pkgs.formats.json { };
in {
  imports = [];

  options.graphical.eww = {
    enable = mkOption {
      type = types.bool;
      default = false; # config.graphical.enable;
      description = "enable eww";
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

    scripts = {};
  };

  config = mkIf (cfg.enable && config.graphical.hyprland.enable) {
    home-manager.users.${config.user} = {
      programs.eww = {
        enable = true;
        enableFishIntegration = true;
        configDir = ./ewwConfig;
      };
    };
  };
}
