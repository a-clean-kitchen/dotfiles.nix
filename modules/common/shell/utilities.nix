{ config, lib, pkgs, ... }:

{
  config = {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        # JSON stuff
        jq

        # find it 
        ripgrep
        
        # per-proj dependency management
        devbox
      ];
    };
  };
}
