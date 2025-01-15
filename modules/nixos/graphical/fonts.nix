{ config, lib, pkgs, ... }:

let
  bestFont = "CascadiaCode";
  inherit (lib) mkIf mkOption types;
in
{
  options.bestFont = mkOption {
    type = types.str;
    default = bestFont;
    description = "use the literal best font";
  };
  

  config = mkIf (config.gui.enable && pkgs.stdenv.isLinux) {
    fonts.packages = with pkgs.nerd-fonts; [
      caskaydia-cove
      caskaydia-mono
    ];

    home-manager.users.${config.user} = {
      home.packages = with pkgs.nerd-fonts; [
        caskaydia-cove
        caskaydia-mono
      ];
      programs.kitty.font.name = bestFont;
    };
  };
}
