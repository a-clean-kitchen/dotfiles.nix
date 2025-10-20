
{ config, lib, pkgs, ... }:

let
  cfg = config.harderware.disko.devices.basic;

  inherit (lib) mkIf mkOption types;
in
{
  options.harderware.disko.devices.basic = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "use basic filesystem";
    };
  };


  config = mkIf cfg.enable {
    disko.devices.disk.basic = {
      type = "disk";
      device = "${config.harderware.disko.disk}";
      content = {
        type = "gpt";
        partitions = {
          # Boot partition
          ESP = rec {
            size = "512M";
            type = "EF00";
            label = "boot";
            device = "/dev/disk/by-partlabel/boot";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              extraArgs = [ "-nboot" ];
            };
          };
          # Root partition ext4
          root = rec {
            size = "100%";
            label = "nixos";
            # device = "/dev/disk/by-partlabel/nixos";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              extraArgs = [ "-L nixos" ];
            };
          };
        };
      };
    }; 
  };
}
