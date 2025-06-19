{ inputs, config, lib, pkgs, ... }:

let
  cfg = config.graphical.runbars;

  inherit (lib) mkIf;
in
{
  config = mkIf (cfg.enable) {
    graphical.hyprland.exclusiveHyprConfig = let 
      miniDmenusScript = "${inputs.sqripts.packages."${config.nixpkgs.hostPlatform.system}".minidmenus}/bin/minidmenus";
    in ''
      bind = $mainMod, U, exec, ${miniDmenusScript} DMENUS
    '';
  };
}
