{ config, lib, pkgs, ... }:

let
  cfg = config.desktop;

  inherit (lib) mkIf mkOption types mkDefault;
in
{
  options.desktop = mkOption {
      type = types.bool;
      default = false;
      description = "enable desktop config";
  };
  

  config = mkIf cfg {
    physical = mkDefault true; 
    graphical.enable = mkDefault true;
  };
}
