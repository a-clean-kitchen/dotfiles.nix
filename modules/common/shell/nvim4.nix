{ config, lib, pkgs, ... }:

{
  config = {
    # Need to fix in my nvim project but will leave this for now...
    nixpkgs.config.permittedInsecurePackages = [ "nix-2.16.2" ];

    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ nvim4 ];
    };
  }; 
}
