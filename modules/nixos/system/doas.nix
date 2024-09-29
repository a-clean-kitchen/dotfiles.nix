{ config, lib, pkgs, ... }:

{
  config = lib.mkIf pkgs.stdenv.isLinux {

    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        doas
      ];
    };
    security = {
      sudo = {
        enable = true;

        # No password required for trusted users
        wheelNeedsPassword = false;

        # Pass environment variables from user to root
        # Also requires specifying that we are removing password here
        # extraRules = [{
          # groups = [ "wheel" ];
          # noPass = true;
          # keepEnv = true;
        # }];
      };
    };
  };
}
