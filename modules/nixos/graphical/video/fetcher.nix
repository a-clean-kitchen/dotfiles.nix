{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.video.fetcher;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.video.fetcher = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable fun video fetcher apps";
    };
  };


  config = mkIf cfg.enable {
    # nixpkgs.config.permittedInsecurePackages = [ 
    #   "python3.12-youtube-dl-2021.12.17"
    # ];
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        yt-dlp
      ];
    };
  };
}
