{ inputs, config, lib, ... }:

let
  cfg = config.graphical.runbars;

  inherit (lib) mkIf;
in
{
  config = mkIf (cfg.enable) {
    graphical.hyprland.exclusiveHyprConfig = let 
      quickObsiScript = "${inputs.sqripts.packages."${config.nixpkgs.hostPlatform.system}".quick-obsidian}/bin/quick-obsidian";
    in ''
      bind = $mainMod, O, exec, ${quickObsiScript} ${inputs.my-secrets.obsidian.vault}
    '';
  };
}
