{ config, lib, pkgs, ... }:

let
  cfg = config.harderware.disko;

  inherit (lib) mkIf mkOption types;
in
{
  imports = [
    ./disk-basic.nix
    ./disk-luks-encrypted.nix
  ];

  options.harderware.disko = {
    disk = mkOption {
      type = types.str;
      default = "/dev/nvme0n1";
      description = "the disk to use";
    };
  };

  config = {
    disko = {
      enableConfig = true;
    };
  };
}
