{ config, lib, pkgs, ... }:

let 
  bestFont = "CascadiaCode";
in {
  config = lib.mkIf (config.gui.enable && pkgs.stdenv.isLinux) {
    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ bestFont ]; })
    ];

    home-manager.users.${config.user} = {
      programs.kitty.font.name = bestFont;
    };
  };
}
