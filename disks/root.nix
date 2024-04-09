{ disk, ... }: {
  disk = {
    boot = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          # Boot partition
          ESP = rec {
            size = "512M";
            type = "EF00";
            label = "boot";
            device = "/dev/disk/by-label/${label}";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              extraArgs = [ "-n ${label}" ];
            };
          };
          # Root partition ext4
          root = rec {
            size = "100%";
            label = "nixos";
            device = "/dev/disk/by-label/${label}";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              extraArgs = [ "-L ${label}" ];
            };
          };
        };
      };
    };
  };
}
