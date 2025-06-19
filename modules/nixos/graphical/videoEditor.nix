{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.videoEditor;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.videoEditor = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable video editor";
    };
  };


  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        kdePackages.kdenlive
      ];
    };
  };
}
