{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles.git;

  inherit (lib) mkIf mkOption types;
in
{
  options = {
    gitName = mkOption {
      type = types.str;
      description = "Name to use for git commits";
    };
    dotfiles.git = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable git";
      };
    };
  };
  

  config = mkIf cfg.enable {};
}
