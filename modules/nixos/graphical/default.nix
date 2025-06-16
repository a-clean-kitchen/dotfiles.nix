{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in {
  imports = [
    ./eww
    ./hypr
    ./video
    ./waybar
    ./runners
    
    ./obsidian

    ./misc.nix
    ./yazi.nix
    ./dunst.nix
    ./fonts.nix
    ./greetd.nix
    ./baseCSS.nix
    ./blender.nix
    ./browser.nix
    ./discord.nix
    ./wlogout.nix
    ./windsurf.nix
    ./wallpaper.nix
    ./pulsemixer.nix
  ];

  options.graphical = {
    enable = mkEnableOption {
      description = "Enable graphics.";
      default = false;
    }; 
  };
}
