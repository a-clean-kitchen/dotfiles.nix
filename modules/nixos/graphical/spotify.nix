{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.spotify;
  sopscfg = config.secrets.sops;

  inherit (lib) mkIf mkOption types;
  inherit (pkgs) writeShellScript;
in
{
  options.graphical.spotify = {
    enable = mkOption {
      type = types.bool;
      default = config.graphical.enable;
      description = "enable spotify";
    };
  };


  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      programs = {
        spotify-player = {
          enable = true;
          settings = {
            client_id_command = let
              runner = writeShellScript "spotify-player-key-getter" ''
                echo -n "$(cat $1)"
              '';
            in  mkIf sopscfg.enable {
              command = "${runner}";
              args = [ config.home-manager.users.${config.user}.sops.secrets."api_keys/spotify/id".path ];
            };
          };
        };
      };
      sops.secrets."api_keys/spotify/id" = mkIf sopscfg.enable {};
    };
  };
}
