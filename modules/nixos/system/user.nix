{ config, lib, pkgs, ... }:

{
  config = {
    users.users.${config.user} = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
    };
  };
}
