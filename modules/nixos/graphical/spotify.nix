{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.spotify;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.spotify = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "enable spotify";
    };
  };


  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      programs.spotify-player = {
        enable = true;
        settings = {
          client_id_command = "";
        };
      };
    };
  };
}
