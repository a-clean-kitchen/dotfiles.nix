{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.runbars;

  inherit (lib) mkIf mkOption types;
  inherit (pkgs) writeShellScript;
in
{
  options.graphical.runbars = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable the various runbars";
    };
    projDropScript = mkOption {
      type = types.path;
      description = "script for dropping into a project";
      default = let
        script = /*bash*/ ''
        CHANGEDIR=$XDG_DATA_HOME/c2d
        rmcd () {
          if [ -f $CHANGEDIR ]; then
            rm $CHANGEDIR
          fi
        }

        rmcd
        if [[ $1 == "TERMINAL" ]]; then
          kitty --start-as=maximized -T "projdrop-launcher" sh -c "find ~/wksp/repos/* ~/wksp/spaces/*/* -maxdepth 0 -type d | fzf --margin=5%,15% -1 --preview-window=up:80% --preview '${pkgs.onefetch}/bin/onefetch {}' >>$CHANGEDIR"
          kitty -T "project:$(cat $CHANGEDIR)" --start-as=fullscreen --detach -d $(cat $CHANGEDIR) --hold
          rmcd
        else
          find ~/wksp/repos/* ~/wksp/spaces/*/* -maxdepth 0 -type d | fzf --margin=5%,15% -1 --preview-window=up:80% --preview '${pkgs.onefetch}/bin/onefetch {}' >>$CHANGEDIR
          cat $CHANGEDIR
          rmcd
        fi
        '';
      in writeShellScript "proj-drop.sh" script;
    };
  };
  

  config = mkIf (cfg.enable && config.graphical.hyprland.enable) {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        tofi
      ];
      xdg = {
        configFile = {
          "tofi/config" = {
            text = ''
            width = 100%
            height = 100%
            border-width = 0
            outline-width = 0
            padding-left = 20%
            padding-top = 20%
            result-spacing = 25
            num-results = 10
            font = monospace
            background-color = #000a
            text-color = #cdd6f4
            selection-color = #cba6f7
            fuzzy-match = true
            auto-accept-single = true
            drun-launch = true
            '';
          };
        };
        dataFile = {
          "applications/fish.desktop".text = "";
          "applications/nvim.desktop".text = "";
          "applications/nixos-manual.desktop".text = "";
        };
        # desktopEntries = {
        #   "fish" = {
        #     noDisplay = true;
        #     name = "fish";
        #   };
        #   "nvim" = {
        #     noDisplay = true;
        #     name = "Neovim wrapper";
        #   };
        #   "nixos-manual" = {
        #     noDisplay = true;
        #     name = "NIXOS Manual";
        #   };
        # };
      };
    };
  };
}
