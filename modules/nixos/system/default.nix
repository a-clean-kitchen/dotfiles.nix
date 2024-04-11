{ lib, pkgs, config, ... }:

{
  imports = [
    ./doas.nix
    ./user.nix
  ];

  config = lib.mkIf pkgs.stdenv.isLinux {
    # Pin a state version to prevent warnings
    system.stateVersion =
      config.home-manager.users.${config.user}.home.stateVersion;

    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
