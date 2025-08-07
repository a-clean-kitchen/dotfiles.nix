{ lib, ... }:

{
  imports = [
    ./wifi.nix
    ./audio.nix
    ./server.nix
    ./bluetooth.nix
    ./networking.nix
    ./presets
  ];

  options = {
    physical = lib.mkEnableOption "Whether this machine is a physical device.";
    server = lib.mkEnableOption "Whether this machine is a server.";
  };

}
