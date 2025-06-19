{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.yazi;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.yazi = {
    enable = mkOption {
      type = types.bool;
      default = config.graphical.enable;
      description = "enable yazi";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        highlight
        glow
      ];
      programs.yazi = {
        enable = true;
        package = pkgs.yazi;
        enableFishIntegration = true;
        plugins = let
          inherit (pkgs) yaziPlugins;
        in {
          inherit (yaziPlugins) chmod mount glow starship;
        };
        initLua = /*lua*/ ''
          require("starship"):setup()
        '';
        keymap = {
          manager = {
            prepend_keymap = [
              { run = "plugin chmod"; on = [ "c" "m" ]; desc = "chmod on selected files"; }
              { run = "plugin mount"; on = [ "M" ]; desc = "Navigate mounts"; }
              # { run = "plugin zoom 1"; on = [ "+" ]; desc = "zoom in"; }
              # { run = "plugin zoom -1"; on = [ "-" ]; desc = "zoom out"; }
            ];
          };
        };
        settings = {
          plugin = {
            prepend_previewers = [
              { name = "*.md"; run = "glow"; }
            ];
          };
        };
      };
      xdg.desktopEntries."yazi" = {
        exec = "kitty -T yazi yazi";
        name = "yazi";
        genericName = "Terminal";
        terminal = false;
      };
    };
  };
}
