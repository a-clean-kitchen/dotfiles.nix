{ config, lib, pkgs, ... }:

let
  cfg = config.audio;

  inherit (lib) mkIf mkOption types;
in
{
  options.audio = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable audio";
    };
  };


  config = mkIf cfg.enable {
    services.pipewire = {
      audio.enable = true;
    };
  };
}
