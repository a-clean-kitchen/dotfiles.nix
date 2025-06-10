{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.misc;

  inherit (lib) mkIf mkOption types;
  inherit (pkgs) writeShellScriptBin writeShellScript;
in
{
  options.graphical.misc = {
    enable = mkOption {
      type = types.bool;
      default = config.graphical.enable;
      description = "enable miscellaneous desktop things";
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
          kitty -T "project:$(cat $CHANGEDIR)" --detach -d $(cat $CHANGEDIR) --hold
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


  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      xdg.desktopEntries."nvim-eleetcode" = {
        exec = let
          scriptName = "leetcodeNvim.sh";
          leetcodeScript = let
            script = writeShellScriptBin scriptName ''
              kitty nvim leetcode.nvim
            '';
            scriptBuildInputs = with pkgs; [
              go
              rustc
              python3
              nodejs
              typescript
            ];
          in pkgs.symlinkJoin {
            name = scriptName;
            paths = [ script ] ++ scriptBuildInputs;
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = "wrapProgram $out/bin/${scriptName} --prefix PATH : $out/bin";
          };
        in "${leetcodeScript}/bin/${scriptName}";
        name = "neovim leetcode";
        genericName = "Terminal";
        terminal = false;
      };
    };
  };
}
