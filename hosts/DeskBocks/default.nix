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
      publicKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQcdy3fe9wP0zmx/TMPcZ3r4b38sitxg3ieTSkPbvju"
      ];
      services.openssh.enable = true;
      networking.hostName = "deskbocks";
     
      # Boot from a usb
      # Set password for root: sudo -s; passwd
      # nix run github:nix-community/nixos-anywhere -- --flake .#DeskBocks -L root@ip.or.host.name
      disko = {
        enableConfig = true;
        devices = (import ../../disks/root.nix { disk = "/dev/sda"; });
      };

      # I will never touch these
      boot.initrd.availableKernelModules = 
        [ "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];

      boot.kernelModules = [ "kvm-intel" ];

      # A key of sorts
      passwordHash = inputs.nixpkgs.lib.fileContents ../../misc/password.sha512;
    }
  ];
}
