{ config, lib, pkgs, ... }:

let
  cfg = config.laptop;

  inherit (lib) mkIf mkOption types mkDefault;
in
{
  options.laptop = mkOption {
      type = types.bool;
      default = false;
      description = "enable laptop config";
  };
  

  config = mkIf cfg {
    physical = mkDefault true; 
    harderware = {
      audio.enable = mkDefault true;
      bluetooth.enable = mkDefault true;
    };
    wifi.enable = mkDefault true;
    graphical.enable = mkDefault true;
    isNixos = mkDefault true;
  };
}
