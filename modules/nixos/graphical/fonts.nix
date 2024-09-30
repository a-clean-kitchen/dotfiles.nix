{ config, lib, pkgs, ... }:

let
  bestFont = "CascadiaCode";
  inherit (lib) mkIf mkOption types;
in
{
  options.bestFont = mkOption {
    type = types.string;
    default = bestFont;
    description = "use the literal best font";
  };
  

  config = mkIf (config.gui.enable && pkgs.stdenv.isLinux) {
    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ bestFont ]; })
    ];

    home-manager.users.${config.user} = {
      programs.kitty.font.name = bestFont;
    };
  };
}
