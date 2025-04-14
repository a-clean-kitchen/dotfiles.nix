{ config, lib, inputs, pkgs, ... }:

let
  cfg = config.secrets.sops;
  
  inherit (lib) mkIf mkOption types;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.sops-nix.nixosModules.sops
  ];

  options.secrets.sops = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "enable secrets encryption using sops";
    };

    sopsFolder = builtins.toString inputs.my-secrets + "/sops";
  };


  config = mkIf cfg.enable {

    sops = {


    };
  };
}
