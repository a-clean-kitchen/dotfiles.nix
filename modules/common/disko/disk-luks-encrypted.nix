{ config, lib, pkgs, ... }:

let
  cfg = config.harderware.disko.devices.luks-encrypted;

  inherit (lib) mkIf mkOption types;
in
{
  options.harderware.disko.devices.luks-encrypted = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "use luks encrypted filesystem";
    };
  };

  config = mkIf cfg.enable {
    disko.devices.disk.luks-encrypted = {
      device = "${config.harderware.disko.disk}";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            # This code corresponds to a EFI system partition
            label = "boot";
            name = "ESP";
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "defaults" ];
              extraArgs = [ "-nboot" ];
            };
          };
          root = {
            # Take up the rest of the space on the disk
            size = "100%";
            label = "luks";
            content = {
              name = "cryptroot";
              type = "luks";
              passwordFile = config.sops.secrets."luks/password".path;
              content = {
                type = "btrfs";
                extraArgs = ["-L" "nixos" "-f"];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "subvol=root" "compress=zstd" "noatime" ];
                  };
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = [ "subvol=persist" "compress=zstd" "noatime" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "subvol=nix" "compress=zstd" "noatime" ];
                  };
                  "/persist/.swapvol" = {
                    mountpoint = "/persist/.swapvol";
                    mountOptions = [ "subvol=swap" "compress=no" "nodatacow" "noatime" ];
                    swap.swapfile.size = "18G";
                  };
                };
              };
            };
          };
        };
      };
    }; 

    fileSystems = {
      "/persist".neededForBoot = true; 
    };

    sops.secrets = {
      "luks/password" = {
        sopsFile = "${config.secrets.sops.sopsFolder}/${config.networking.hostName}.host.yaml";
        path = "/tmp/luks.secret.key";
      };
    };
  };
}
