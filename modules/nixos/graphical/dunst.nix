{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.dunst;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.dunst = {
    enable = mkOption {
      type = types.bool;
      default = config.graphical.enable;
      description = "enable dunst notifications";
    };
    maxWidth = mkOption {
      type = types.number;
      default = 600;
      description = "width for notification popup if you want to change per-machine";
    };
  };


  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        papirus-icon-theme        # fix "no icon theme found" issue when started manually
        notify-desktop            # neat tool for sending notifications to desktop
        libnotify
      ];
      services.dunst = {
        enable = true;
        iconTheme = {
          name = "Papirus";
          package = pkgs.papirus-icon-theme;
        };
        settings = {
          global = {
            width = "(0, ${toString cfg.maxWidth}";
            height = "(0, 200)";
            origin = "top-left";
            offset = "(15, 15)";
            notification_limit = 0;
            font = config.bestFont;
            markup = "full";
            ellipsize = "end";
            enable_recursive_icon_lookup = true;
            dmenu = "${pkgs.dmenu}/bin/dmenu -p ${pkgs.dunst}/bin/dunst";
            browser = "${pkgs.xdg-utils}/bin/xdg-open";
            corner_radius = 15;
            mouse_left_click = "do_action";
            mouse_middle_click = "context";
            mouse_right_click = "close_current";
            icon_theme = "Papirus";
          };
          urgency_low = {
            background = "#fff";
            foreground = "#89b4fa";
            frame_color = "#89b4fa";
            timeout = 3;
          };
          urgency_normal = {
            background = "#fff";
            foreground = "#a6e3a1";
            frame_color = "#a6e3a1";
            timeout = 3;
          };
          urgency_critical = {
            background = "#fff";
            foreground = "#f38ba8";
            frame_color = "#f38ba8";
            timeout = 3;
          };
        };
      };
    };      
  };
}
