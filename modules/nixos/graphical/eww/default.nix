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

    ewwStartWindows = mkOption {
      type = types.listOf (types.str);  
      default = [];
      description = "startup eww windows";
    };
    
    scripts = {
      starter = mkOption {
        type = types.path;
        description = "";
        default = let
        script = /*bash*/ ''
          pkill eww
          eww daemon --restart
          eww open-many ${builtins.concatStringsSep " " cfg.ewwStartWindows}
          '';
        in  writeShellScript "ewwStarter" script;
      };
    };
  };
  config = mkIf (cfg.enable && config.graphical.hyprland.enable) {
    graphical.eww.ewwStartWindows = [
      "topbgcorner-left" "topside-edge" "topbgcorner-right"
      "leftside-edge"                   "rightside-edge"
      "bgcorner-left"    "bar"          "bgcorner-right"
    ];

    # xdg.configFile."eww" = let
    #
    # in true;    
    home-manager.users.${config.user} = {
      programs.eww = {
        enable = true;
        enableFishIntegration = true;
        configDir = ./ewwConfig;
      };
    };
  };
}
