
{ inputs, globals, overlays, ... }:

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    globals
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    ../../modules/common
    ../../modules/nixos
    ./hardware-configuration.nix
    {
      dotfiles.enable = true;
      
      laptop = true;
      nixpkgs.overlays = overlays;      
      publicKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQcdy3fe9wP0zmx/TMPcZ3r4b38sitxg3ieTSkPbvju"
      ];
      services.openssh.enable = true;
      networking.hostName = "junkr";
     
      # Boot from a usb
      # Set password for root: sudo -s; passwd
      # # Look in Makefile for an example init command once you have a root password and ip/hostname
      disko = {
        enableConfig = true;
        devices = (import ../../disks/root.nix { disk = "/dev/nvme0n1"; });
      };

      time.timeZone = "America/New_York";
      # A key of sorts
      passwordHash = inputs.nixpkgs.lib.fileContents ../../misc/password.sha512;
    }
  ];
}
