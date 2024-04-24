{ config, lib, pkgs, ... }:

let 
  bestFont = "Monocraft Nerd Font";
in {
  config = lib.mkIf (config.gui.enable && pkgs.stdenv.isLinux) {
    fonts.packages = with pkgs; [
      monocraft
    ];

    home-manager.users.${config.user} = {
      programs.kitty.font.name = bestFont;
    };
  };
}
