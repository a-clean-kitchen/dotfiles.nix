{ config, lib, pkgs, ... }:

let
  cfg = config.audio;

  inherit (lib) mkIf mkOption types mkForce;
in
{
  options.audio = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable audio";
    };

    bluetooth = mkOption {
      type = types.bool;
      default = false;
      description = "enable bluetooth audio";
    };
  };


  config = mkIf cfg.enable {
    services.pulseaudio.enable = mkForce false;
    hardware = {
      bluetooth = {
        enable = if cfg.bluetooth then true else false;
      };
      pulseaudio = {
        enable = true;
        support32Bit = true;
        package = pkgs.pulseaudioFull;
      };
    };
  };
}
