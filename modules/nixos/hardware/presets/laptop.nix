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
    wifi.enable = mkDefault true;
    gui.enable = mkDefault true;
  };
}
