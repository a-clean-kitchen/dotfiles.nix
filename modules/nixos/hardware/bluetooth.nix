{ config, lib, pkgs, ... }:

let
  cfg = config.harderware.bluetooth;
  gcfg = config.graphical;
  inherit (lib) mkIf mkOption types;
in
{
  options.harderware.bluetooth = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable ";
    };
  };


  config = mkIf cfg.enable {
    hardware = {
      bluetooth = {
        enable = true;
      };
    };
    environment.systemPackages = with pkgs; [ bluetui ];
  };
}
