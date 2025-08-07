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

    ./gtk.nix
    ./misc.nix
    ./yazi.nix
    ./dunst.nix
    ./fonts.nix
    ./greetd.nix
    ./baseCSS.nix
    ./blender.nix
    ./browser.nix
    ./discord.nix
    ./spotify.nix
    ./wlogout.nix
    ./zathura.nix
    ./windsurf.nix
    ./wallpaper.nix
    ./videoEditor.nix
    ./pulsemixer.nix
  ];

  options.graphical = {
    enable = mkEnableOption {
      description = "Enable graphics.";
      default = false;
    }; 
  };
}
