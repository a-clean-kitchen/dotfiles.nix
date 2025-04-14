
{ inputs, globals, overlays, ... }:

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    globals
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ../../modules/common
    ../../modules/nixos
    ./hardware-configuration.nix
    {
      dotfiles.enable = true;
      
      laptop = true;
      nixpkgs.overlays = overlays;      
      services.openssh.enable = true;
      networking.hostName = "junkr";
 
      graphical = {
        hyprland.sixteenbynine = true;
      };

      audio.bluetooth = true;

      # Boot from a usb
      # Set password for "nixos" user: passwd
      # # Look in Makefile for an example init command once you have a root password and ip/hostname
      disko = {
        enableConfig = true;
        # Find main drive's disk name --------------------\/\/\/\/\/\/
        devices = (import ../../disks/root.nix { disk = "/dev/nvme0n1"; });
      };

      time.timeZone = "America/New_York";
      # A key of sorts
      passwordHash = inputs.nixpkgs.lib.fileContents ../../misc/password.sha512;
    }
  ];
}
