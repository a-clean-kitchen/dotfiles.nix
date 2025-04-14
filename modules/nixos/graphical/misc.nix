{ config, lib, pkgs, ... }:

let
  cfg = config.graphical.misc;

  inherit (lib) mkIf mkOption types;
  inherit (pkgs) writeShellScriptBin;
in
{
  options.graphical.misc = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable miscellaneous desktop things";
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
