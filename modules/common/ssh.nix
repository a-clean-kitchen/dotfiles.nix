{ config, lib, pkgs, ... }:

let
  cfg = config.tools.ssh;

  inherit (lib) mkIf mkOption types;
in
{
  options.tools.ssh = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable ssh";
      };
    };
  

  config = mkIf cfg.enable {
    
    home-manager.users.${config.user} = let
      onePassPath = "~/.1password/agent.sock";
    in {
      programs.ssh = {
        enable = true;
        extraConfig = if (config.tools.onepassword.enable) then
        "IdentityAgent ${onePassPath}"
        else ""; 
      };
    };
  };
}
