{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.harderware.audio;

  inherit (lib) mkIf mkOption mkEnableOption types mkMerge;
in
{
  options.harderware.audio = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable audio";
    };
    ledMutePatch = mkEnableOption "turn on systemd patch to turn off";
  };


  config = mkIf cfg.enable (mkMerge [
    {
      services = {
        pipewire = {
          enable = true;
          pulse.enable = true;

          # keep this false
          systemWide = false;
        };
      };
    }
    (mkIf cfg.ledMutePatch {
      systemd.services.configure-sound-leds = rec {
        wantedBy = [ "sound.target" ];
        after = wantedBy;
        serviceConfig = {
          Type = "oneshot";
        };
        script =  ''
          echo 0 | tee /sys/class/leds/platform\:\:mute/brightness > /dev/null
          echo 0 | tee /sys/class/leds/platform\:\:micmute/brightness > /dev/null
        '';
      };
    })
  ]);
}
