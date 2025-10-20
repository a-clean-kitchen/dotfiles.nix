
{ inputs, globals, overlays, ... }:

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs; };
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
      
      desktop = true;
      nixpkgs.overlays = overlays;      
      services.openssh.enable = true;
      networking.hostName = "kanna";
 
      # graphical = {
      #   hyprland.sixteenbynine = true;
      # };

      harderware = {
        disko.devices.luks-encrypted.enable = true;
      };

      # Boot from a usb
      # Set password for "nixos" user: passwd
      # # Look in Makefile for an example init command once you have a root password and ip/hostname

      time.timeZone = "America/New_York";
      # A key of sorts
      # passwordHash = inputs.nixpkgs.lib.fileContents ../../misc/password.sha512;
    }
  ];
}
