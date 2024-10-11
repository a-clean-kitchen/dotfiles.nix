{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.wlogout;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.wlogout = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable wlogout";
      };
      
    script = mkOption {};
    homePath = mkOption {};
    };
  

  config = mkIf cfg.enable {
    
  };
}
