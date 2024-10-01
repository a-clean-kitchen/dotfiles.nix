{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.wofi;

  inherit (lib) mkIf mkOption types;
in
{
  options.graphical.wofi = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable wofi";
      };
    };
  

  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      programs.wofi = {
        enable = true;
        settings = {
          width = 400;
          height = 250;
          location = "center";
          show = "drun";
          prompt = "Go gettem'";
          filter_rate = 100;
          allow_markup = true;
          no_actions = true;
          halign = "fill";
          orientation = "vertical";
          content_halign = "fill";
          insensitive = true;
          allow_images = true;
          image_size = 40;
          gtk_dark = true;
        };
        style = /*css*/ ''
        window {
            margin: 0px;
            border: 5px solid #f5c2e7;
            background-color: #f5c2e7;
            border-radius: 15px;
            font-size: 13px;
            font-family: "${config.bestFont}";
        }

        #input {
            padding: 4px;
            margin: 4px;
            padding-left: 20px;
            border: none;
            color: #fff;
            font-weight: bold;
            background-color: #fff;
            background: linear-gradient(90deg, rgba(203,166,247,1) 0%, rgba(245,194,231,1) 100%);
            outline: none;
            border-radius: 15px;
            margin: 10px;
            margin-bottom: 2px;
        }

        #input:focus {
            border: 0px solid #fff;
            margin-bottom: 0px;
        }

        #inner-box {
            margin: 4px;
            border: 10px solid #fff;
            color: #cba6f7;
            font-weight: bold;
            background-color: #fff;
            border-radius: 15px;
        }

        #outer-box {
            margin: 0px;
            border: none;
            border-radius: 15px;
            background-color: #fff;
        }

        #scroll {
            margin-top: 5px;
            border: none;
            border-radius: 15px;
            margin-bottom: 5px;
            /* background: rgb(255,255,255); */
        }

        #text:selected {
            color: #fff;
            margin: 0px 0px;
            border: none;
            border-radius: 15px;
        }

        #entry {
            margin: 0px 0px;
            border: none;
            border-radius: 15px;
            background-color: transparent;
        }

        #entry:selected {
            margin: 0px 0px;
            border: none;
            border-radius: 15px;
            background: linear-gradient(45deg, rgba(203,166,247,1) 30%, rgba(245,194,231,1) 100%);
        }
        '';
      };
    };
  };
}
