{ config, lib, pkgs, ... }:

let
  cfg = config.harderware.audio;

  inherit (lib) mkIf mkOption types mkForce;
in
{
  options.harderware.audio = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable audio";
    };
  };


  config = mkIf cfg.enable {
    services = {
      pulseaudio = {
        enable = false;
        support32Bit = true;
        package = pkgs.pulseaudioFull;
      };
    };
    # environment.systemPackages = with pkgs; [ polybar-pulseaudio-control ];
  };
}
