{ config, pkgs, lib, ... }:
let
  inherit (lib) mkOption types;
  inherit (pkgs) writeShellScript;
in 
{
  options.scripts = {
    rebuildNixos = mkOption {
      type = types.path;
      description = "personal rebuild script";
      default = let
        script = /*bash*/ ''
          set -e

          DOTFILESPATH=${config.dotfilesPath}

          git -C $DOTFILESPATH add --intent-to-add --all

          if ! nixos-rebuild build --flake $DOTFILESPATH#junkr; then
              echo "Error: NixOS rebuild failed" >&2
              exit 1
          fi

          resultDir="$DOTFILESPATH/result"
          pathToConfig=$(readlink -f $resultDir)
          profile=/nix/var/nix/profiles/system

          sudo nix-env -p "$profile" --set "$pathToConfig"

          # Stole this from the original nixos-rebuild script, but basically
          # We use systemd-run to protect against PTY failures/network
          # disconnections during rebuild.
          # See: https://github.com/NixOS/nixpkgs/issues/39118
          cmd=(
              "systemd-run"
              "-E" "LOCALE_ARCHIVE" # Will be set to new value early in switch-to-configuration script, but interpreter starts out with old value
              "-E" "NIXOS_INSTALL_BOOTLOADER="
              "--collect"
              "--no-ask-password"
              "--pipe"
              "--quiet"
              "--service-type=exec"
              "--unit=nixos-rebuild-switch-to-configuration"
              "--wait"
              "$pathToConfig/bin/switch-to-configuration"
              "switch"
          )

          if ! sudo "''${cmd[@]}"; then
              # Switch failed
              exit 1
          else
              # Switch succeeded
              echo "$pathToConfig"
          fi 
        ''; 
      in writeShellScript "rebuildNixos" script; 
    };
  };

  config = {
    home-manager.users.${config.user} = {

      programs.fish = {
        shellAbbrs = {
          n = "nix";
          ns = "nix-shell -p";
          nsf = "nix-shell --run fish -p";
          nsr = "nix-shell-run";
          nps = "nix repl '<nixpkgs>'";
          nixo = "man configuration.nix";
          nixh = "man home-configuration.nix";
          nr = "rebuild-nixos";
          nro = "rebuild-nixos offline";
          hm = "rebuild-home";
          cdf = "cd $(${config.graphical.runbars.projDropScript}) && clear";
        };
        functions = {
          nix-shell-run = {
            body = ''
              set program $argv[1]
              if test (count $argv) -ge 2
                  commandline -r "nix run nixpkgs#$program -- $argv[2..-1]"
              else
                  commandline -r "nix run nixpkgs#$program"
              end
              commandline -f execute
            '';
          };
          nix-fzf = {
            body = ''
              commandline -i (nix-instantiate --eval --json \
                -E 'builtins.attrNames (import <nixpkgs> {})' \
                | jq '.[]' -r | fzf)
              commandline -f repaint
            '';
          };
          rebuild-nixos = {
            body = ''
              ${config.scripts.rebuildNixos}
            '';
          };
          rebuild-home = {
            body = ''
              git -C ${config.dotfilesPath} add --intent-to-add --all
              commandline -r "${pkgs.home-manager}/bin/home-manager switch --flake ${config.dotfilesPath}";
              commandline --function execute
            '';
          };
        };
      };

      # Provides "command-not-found" options
      programs.nix-index = {
        enable = true;
        enableFishIntegration = true;
      };

      # Set automatic generation cleanup for home-manager
      nix.gc = {
        automatic = config.nix.gc.automatic;
        options = config.nix.gc.options;
      };

    };

    nix = {
      # For security, only allow specific users
      settings = {
        allowed-users = [ "@wheel" config.user ];
        trusted-users = [ "root" config.user ];
      };

      # Enable features in Nix commands
      extraOptions = ''
        experimental-features = nix-command flakes
        warn-dirty = false
      '';

      gc = {
        automatic = true;
        options = "--delete-older-than 10d";
      };

    };
  };
}

