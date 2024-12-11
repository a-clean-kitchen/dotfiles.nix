{ config, lib, pkgs, ... }:

let
  cfg = config.tools.onepassword;

  inherit (lib) mkIf mkOption types;
in
{
  options.tools.onepassword = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable 1Password";
      };
    };
  

  config = mkIf cfg.enable {
    unfreePackages = [
      "1password-gui"
      "1password-cli"
      "1password"
    ];

    programs = {
      _1password = {
        enable = true;
        package = pkgs._1password-cli;
      };
      _1password-gui = {
        enable = true;
        # Certain features, including CLI integration and system authentication support,
        # require enabling PolKit integration on some desktop environments (e.g. Plasma).
        polkitPolicyOwners = [ config.user ];
        package = pkgs._1password-gui;
      };
    };
  };
}
