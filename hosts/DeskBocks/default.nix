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
      server = true;
      nixpkgs.overlays = overlays;      
      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQcdy3fe9wP0zmx/TMPcZ3r4b38sitxg3ieTSkPbvju"
      ];
      services.openssh.enable = true;
      networking.hostName = "DeskBocks";
      disko = {
        enableConfig = true;
        devices = (import ../../disks/root.nix { disk = "/dev/sda"; });
      };
      boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];
      passwordHash = inputs.nixpkgs.lib.fileContents ../../misc/password.sha512;

#       fileSystems."/" =
#         { device = "/dev/disk/by-label/nixos";
#           fsType = "ext4";
#         };
# 
#       fileSystems."/boot/efi" =
#         { device = "/dev/disk/by-label/boot";
#           fsType = "vfat";
#         };


    }
  ];
}
