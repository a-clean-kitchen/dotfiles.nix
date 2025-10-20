{ disk, config, ... }:

{
  # Setup the primary disk
  disk.primary = {
    device = "${disk}";
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
          content = {
            name = "root";
            type = "luks";
            passwordFile = config.sops.secrets."luks/password".path;
            settings = {
              allowDiscards = true;
            };
            content = {
              type = "btrfs";
              extraArgs = ["-L" "nixos" "-f"];
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                "/swap" = {
                  mountpoint = "/.swapvol";
                  swap.swapfile.size = "16G";
                };
              };
            };
          };
        };
      };
    };
  };
}
