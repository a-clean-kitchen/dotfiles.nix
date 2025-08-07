{ inputs, config, lib, pkgs, ... }:

let
  cfg = config.graphical.runbars;

  inherit (lib) mkIf mkOption types;
  inherit (pkgs) writeShellScript;
in
{
  config = mkIf (cfg.enable) {
    graphical.hyprland.exclusiveHyprConfig = let 
      projDropScript = "${inputs.sqripts.packages."${config.nixpkgs.hostPlatform.system}".projdrop}/bin/projdrop";
    in ''
      windowrule = float, initialTitle:projdrop-launcher
      windowrule = maximize, title:^(projdrop-launcher)$
      windowrule = move center, title:^(projdrop-launcher)$
      bind = $mainMod, D, exec, ${projDropScript}
    '';
  };
}
