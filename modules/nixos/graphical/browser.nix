{ config, lib, pkgs, ... }:

let
  cfg = config.browser;

  inherit (lib) mkIf mkOption types;
in
{
  options.browser = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable chromium browser";
      };
    };
  

  config = mkIf (cfg.enable && config.gui.enable) {
    home-manager.users.${config.user} = {
      programs.chromium = {
        enable = true;
      };
    };
  };
}
