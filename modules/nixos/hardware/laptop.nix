{ config, lib, pkgs, ... }:

let
  cfg = config.laptop;

  inherit (lib) mkIf mkOption types mkDefault;
in
{
  options.laptop = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable laptop config";
      };
    };
  

  config = mkIf cfg.enable {
    physical = mkDefault true; 
  };
}
