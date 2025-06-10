{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.discord;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.discord = {
    enable = mkOption {
      type = types.bool;
      default = config.graphical.enable;
      description = "enable discord";
    };
  };


  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        webcord
      ];
    };
  };
}
