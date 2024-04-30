{ config, lib, pkgs, ... }:

let
  cfg = config.apps.kitty;

  inherit (lib) mkIf mkOption types;
in
{
  options.apps.kitty = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable kitty";
      };
    };
  

  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      programs.kitty = {
        enable = true;
        shellIntegration.enableFishIntegration = true;
        theme = "Catppuccin-Mocha";
        settings = {
          window_padding_width = 15;
          font_size = 11;
        };
      };
    };
  };
}
