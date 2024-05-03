{ config, lib, pkgs, ... }:

let
  cfg = config.portfolio;

  inherit (lib) mkIf mkOption types;


in
{
  options.portfolio = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "enable portoflio site service";
      };
    };
  

  config = mkIf cfg.enable {

  };
}
