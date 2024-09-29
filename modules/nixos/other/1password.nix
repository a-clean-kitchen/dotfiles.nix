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
    # Enable the unfree 1Password packages
    # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    #   "1password-gui"
    #   "1password"
    # ];
    # Alternatively, you could also just allow all unfree packages
    nixpkgs.config.allowUnfree = true;

    programs._1password = {
      enable = true;
      package = pkgs._1password;
    };
    programs._1password-gui = {
      enable = true;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      polkitPolicyOwners = [ config.user ];
      package = pkgs._1password-gui;
    };
  };
}
