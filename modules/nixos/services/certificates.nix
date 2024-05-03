{ config, lib, pkgs, ... }:

let
  cfg = config.letscert;

  inherit (lib) mkIf mkOption types;
in
{
  options.letscert = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable self-hosted lets-encrypt service";
      };
    };

  config = mkIf cfg.enable {};
}
