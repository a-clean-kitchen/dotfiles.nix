{ lib, ... }:

{
  imports = [
    ./wifi.nix
    ./server.nix
    ./networking.nix
    ./presets
  ];

  options = {
    physical = lib.mkEnableOption "Whether this machine is a physical device.";
    server = lib.mkEnableOption "Whether this machine is a server.";
  };

}
