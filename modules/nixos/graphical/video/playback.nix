{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.video.playback;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.video.playback = {
    enable = mkOption {
      type = types.bool;
      default = config.graphical.enable;
      description = "enable video playback tools";
    };
  };


  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      # home.packages = with pkgs; [];
      programs.mpv = {
        enable = true;
      };
    };

  };
}
