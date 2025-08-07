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
    home-manager.users = {
      ${config.user} = {
        programs = {
          ssh.matchBlocks = mkIf config.tools.ssh.enable {
            "github.com" = {
              user = "git";
              identitiesOnly = true;
              identityFile = "~/.ssh/private.personal.key";
            };
          };
          fish = {
            functions = {
              prune-branches = let
                pruneScript = writeShellScript "gitPruneLocalExclusives.sh" ''
                  git fetch -p
                  toBeDeleted=$(git branch -r | \
                    awk '{print $1}' | \
                    egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | \
                    awk '{print $1}')
                  oldAllBranch=$(git branch -a)
                  echo "The following branches will be deleted:"
                  echo ""
                  echo "$toBeDeleted"
                  echo ""
                  while true; do
                      read -p "Is that okay? " yn
                      case $yn in
                          [Yy]* ) 
                            echo "$toBeDeleted" | xargs git branch -D;
                            diff <(echo "$oldAllBranch") <(git branch -a)
                            exit;;
                          [Nn]* ) exit;;
                          * ) echo "Okay then"; exit;;
                      esac
                  done

                '';
              in{
                body = ''${pruneScript}'';
              };
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
    };
    # programs.ssh = mkIf config.tools.ssh.enable {
    #   extraConfig = ''
    #     Host github.com
    #       IdentitiesOnly yes
    #       User git
    #       identityFile /etc/ssh/ssh_host_ed25519_key
    #   '';
    # };
  };
}
