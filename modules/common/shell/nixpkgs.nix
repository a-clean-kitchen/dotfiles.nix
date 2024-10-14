{ config, pkgs, lib, ... }: {
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
            if test "$argv[1]" = "offline"
                set option "--option substitute false"
            end
            git -C ${config.dotfilesPath} add --intent-to-add --all
            commandline -r "sudo nixos-rebuild switch $option --flake ${config.dotfilesPath}#${config.networking.hostName}"
            commandline --function execute
          '';
        };
        rebuild-home = {
          body = ''
            git -C ${config.dotfilesPath} add --intent-to-add --all
            commandline -r "${pkgs.home-manager}/bin/home-manager switch --flake ${config.dotfilesPath}";
            commandline --function execute
          '';
        };
        proj = {
          body = ''
            commandline -r "cd $(find ~/wksp/repos ~/wksp/spaces ~/wksp/refDots -maxdepth 1 | fzf)"
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

}

