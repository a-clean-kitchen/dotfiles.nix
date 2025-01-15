{ config, lib, pkgs, ... }:

# let
#   cfg = config.services.upower;
#
#   inherit (lib) mkIf mkForce mkOption types;
# in
{
  # options.services.upower = {};


  config = {
    services.upower = {
      enable = true;
    };
  };
}
