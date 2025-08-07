{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.base.css;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.base.css = {
    enable = mkOption {
      type = types.bool;
      default = config.graphical.enable;
      description = "base css file";
    };
    text = mkOption {
      type = types.str;
      description = '''';
      default = /*css*/ ''
      @define-color rosewater #f5e0dc;
      @define-color flamingo #f2cdcd;
      @define-color pink #f5c2e7;
      @define-color mauve #cba6f7;
      @define-color red #f38ba8;
      @define-color maroon #eba0ac;
      @define-color peach #fab387;
      @define-color yellow #f9e2af;
      @define-color green #a6e3a1;
      @define-color teal #94e2d5;
      @define-color sky #89dceb;
      @define-color sapphire #74c7ec;
      @define-color blue #89b4fa;
      @define-color lavender #b4befe;
      @define-color text #cdd6f4;
      @define-color subtext1 #bac2de;
      @define-color subtext0 #a6adc8;
      @define-color overlay2 #9399b2;
      @define-color overlay1 #7f849c;
      @define-color overlay0 #6c7086;
      @define-color surface2 #585b70;
      @define-color surface1 #45475a;
      @define-color surface0 #313244;
      @define-color base #1e1e2e;
      @define-color mantle #181825;
      @define-color crust #11111b;
      '';
    };
  };
  

  config = mkIf config.graphical.enable {
    home-manager.users.${config.user} = {
      xdg.configFile = {
        "css/base.css" = {
          text = config.graphical.base.css.text;
        };
      };
    };

  };
}
