{ config, pkgs, lib, ... }: {

  users.users.${config.user}.shell = pkgs.fish;
  programs.fish.enable = true; # Needed for LightDM to remember username

  home-manager.users.${config.user} = {

    # Packages used in abbreviations and aliases
    home.packages = with pkgs; [ curl ];

    programs.fish = {
      enable = true;
    };

    home.sessionVariables.fish_greeting = "";

    programs.starship.enableFishIntegration = true;
    programs.fzf.enableFishIntegration = true;
  };
}
