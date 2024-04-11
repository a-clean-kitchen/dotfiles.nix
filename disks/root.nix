{ disk, ... }: {
  disk = {
    my-disk = {
      type = "disk";
      device = "${disk}";
      content = {
        type = "gpt";
        partitions = {
          # Boot partition
          ESP = rec {
            size = "512M";
            type = "EF00";
            label = "boot";
            # device = "/dev/disk/by-label/boot";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              extraArgs = [ "-n boot" ];
            };
          };
          # Root partition ext4
          root = rec {
            size = "100%";
            label = "nixos";
            # device = "/dev/disk/by-label/nixos";
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
