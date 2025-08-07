{ inputs, globals, overlays, ... }:

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    globals
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    ../../modules/common
    ../../modules/nixos
    {
      dotfiles.enable = true;
      
      server = true;
      nixpkgs.overlays = overlays;      
      services.openssh.enable = true;
      networking.hostName = "deskbocks";
      time.timeZone = "America/New_York";
     
      # Boot from a usb
      # Set password for root: sudo -s; passwd
      # nix run github:nix-community/nixos-anywhere -- --flake .#DeskBocks -L root@ip.or.host.name
      disko = {
        enableConfig = true;
        devices = (import ../../disks/root.nix { disk = "/dev/sda"; });
      };

      # A key of sorts
      passwordHash = inputs.nixpkgs.lib.fileContents ../../misc/password.sha512;
    }
  ];
}
