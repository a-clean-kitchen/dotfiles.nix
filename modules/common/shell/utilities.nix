{ config, lib, pkgs, ... }:

{
  config = {
    unfreePackages = [
      "ngrok"
    ];
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        # JSON stuff
        jq

        ngrok

        # find it 
        ripgrep
        
        # per-proj dependency management
        devbox

        killall

        wikiman

        just
      ];
    };
  };
}
