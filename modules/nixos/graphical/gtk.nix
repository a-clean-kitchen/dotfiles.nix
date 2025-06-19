{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.gtk;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.gtk = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable gtk";
    };
  };


  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      gtk = {
        enable = true;
      };
    };
  };
}
