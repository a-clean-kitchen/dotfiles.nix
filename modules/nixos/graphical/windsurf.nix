{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.ide.windsurf;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.ide.windsurf = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable windsurf";
    };
  };


  config = mkIf cfg.enable {
    unfreePackages = [
      "windsurf"
    ];
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ windsurf ];
    };
  };
}
