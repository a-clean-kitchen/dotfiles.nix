{ config, lib, pkgs, ... }:

let
  cfg = config.shell.github;

  inherit (lib) mkIf mkOption types;
in
{
  options.shell.github = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable github cli";
      };
    };
  

  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ gh ];
    };
  };
}
