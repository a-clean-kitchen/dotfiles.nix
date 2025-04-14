{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.apps.discord;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.apps.discord = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable discord";
    };
  };


  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        discord
      ];
    };
  };
}
