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
    fonts.packages = with pkgs; [
      # turn this into conditional
      cascadia-code
    ];

    home-manager.users.${config.user} = {
      programs.kitty.font.name = bestFont;
    };
  };
}
