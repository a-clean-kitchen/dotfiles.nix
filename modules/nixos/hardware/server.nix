{ config, lib, pkgs, ... }:

{
  config = lib.mkIf (config.server || config.physical) {
    # Servers need a bootloader or they won't start
    boot = { 
      loader = { 
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
    isNixos = true;
  };
}
