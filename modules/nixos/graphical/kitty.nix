{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.gui.enable {
    home-manager.users.${config.user} = {
      programs.kitty = {
        enable = true;
        settings = {
          window_padding_width = 15;
          font_size = 12;
        };
      };   
    };
  };
}
