{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles.git;

  inherit (lib) mkIf mkOption types;
  inherit (pkgs) writeShellScript;
in
{
  options = {
    gitName = mkOption {
      type = types.str;
      description = "Name to use for git commits";
    };
    dotfiles.git = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable git";
      };
    };
  };
  

  config = mkIf cfg.enable {
    home-manager.users.${config.user} = {
      programs.fish = {
        functions = {
          gcl = {
            body = let
              gitScript = writeShellScript "gitClone.sh" /*bash*/ ''
              gitProject=$1
              gitProject="''${gitProject##*/}" # Remove all up to and including last /
              gitProject="''${gitProject%.*}"  # Remove up to the . (including) from the right
              git clone $1 ~/wksp/repos/$gitProject
              '';
            in ''
              set repoURL $argv[1]
              commandline -r "${gitScript} $repoURL"
              commandline -f execute
            '';
          };
        };
      };
    };
  };
}
