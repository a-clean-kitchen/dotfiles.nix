{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.graphical.hyprland;

  inherit (lib) mkIf mkDefault mkOption types;
in {
  options.graphical.hyprland = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "enable hyprland";
      };
      
      scriptsDir = mkOption {
        type = types.path;
        default = "/home/${config.user}/.config/hypr/scripts";
      };
    };
  
  config = let
    hyprInit =
      ''
        #! ${pkgs.runtimeShell}
        hyprDir=~/.config/hypr
        hyprScripts=$hyprDir/scripts
        hyprPapers=$hyprDir/wallpapers
        ${config.graphical.wallpapers.script} init $hyprPapers/office.jpg
        waybar
      '';
  in mkIf (cfg.enable && config.gui.enable) {
    environment.systemPackages = with pkgs; [
      fzf
    ];
    hardware.graphics.enable = mkDefault true;
    security.polkit.enable = mkDefault true;
    programs = {
      dconf.enable = mkDefault true;
    };
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
      xdg.configFile = {
        "hypr/scripts/hyprInit" = {
          executable = true;
          text = hyprInit;
        };
      };
      wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = /*hyprlang*/ ''
          $terminal = kitty
          
          misc {
            # sowwy hypr
            disable_hyprland_logo = true
            disable_splash_rendering = true

            font_family = ${config.bestFont}
          }
          
          # Some default env vars.
          env = XCURSOR_SIZE,24
          env = QT_QPA_PLATFORMTHEME,qt5ct # change to qt6ct if you have that
          
          exec-once = ${cfg.scriptsDir}/hyprInit
           
          # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
          input {
              kb_layout = us
              kb_variant =
              kb_model =
              kb_options =
              kb_rules =

              follow_mouse = 1

              touchpad {
                  natural_scroll = no
              }

              sensitivity = 0 # -1.0 to 1.0, 0 means no modification.
          }

          general {
              gaps_in=8
              gaps_out=15
              border_size=5
              col.active_border=0xfff5c2e7
              col.inactive_border=0xff45475a
              # apply_sens_to_raw=0 # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
          }

          decoration {
              drop_shadow = true
              shadow_range=100
              shadow_render_power=5
              col.shadow= 0x33000000
              col.shadow_inactive=0x22000000
              rounding=15
          }

          animations {
              enabled = yes
              bezier=overshot,0.13,0.99,0.29,1.1
              animation=windows,1,4,overshot,slide
              animation=border,1,10,default
              animation=fade,1,10,default
              animation=workspaces,1,6,overshot,slidevert
          }

          dwindle {
              # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
              pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
              preserve_split = yes # you probably want this
          }

          master {
              # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
              # new_is_master = true
          }

          gestures {
              # See https://wiki.hyprland.org/Configuring/Variables/ for more
              workspace_swipe = ${if (config.laptop) then "on" else "off"}
          }

          windowrulev2 = suppressevent maximize, class:.* # You'll probably like this.


          # See https://wiki.hyprland.org/Configuring/Keywords/ for more
          $mainMod = SUPER

          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          bind = $mainMod, Q, exec, $terminal
          bind = $mainMod, C, killactive, 
          bind = $mainMod, M, exit, 
          bind = $mainMod, V, togglefloating, 
          bind = $mainMod, P, pseudo, # dwindle
          bind = $mainMod, J, togglesplit, # dwindle

          # Move focus with mainMod + arrow keys
          bind = $mainMod, left, movefocus, l
          bind = $mainMod, right, movefocus, r
          bind = $mainMod, up, movefocus, u
          bind = $mainMod, down, movefocus, d

          # Switch workspaces with mainMod + [0-9]
          bind = $mainMod, 1, workspace, 1
          bind = $mainMod, 2, workspace, 2
          bind = $mainMod, 3, workspace, 3
          bind = $mainMod, 4, workspace, 4
          bind = $mainMod, 5, workspace, 5
          bind = $mainMod, 6, workspace, 6
          bind = $mainMod, 7, workspace, 7
          bind = $mainMod, 8, workspace, 8
          bind = $mainMod, 9, workspace, 9
          bind = $mainMod, 0, workspace, 10

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          bind = $mainMod SHIFT, 1, movetoworkspace, 1
          bind = $mainMod SHIFT, 2, movetoworkspace, 2
          bind = $mainMod SHIFT, 3, movetoworkspace, 3
          bind = $mainMod SHIFT, 4, movetoworkspace, 4
          bind = $mainMod SHIFT, 5, movetoworkspace, 5
          bind = $mainMod SHIFT, 6, movetoworkspace, 6
          bind = $mainMod SHIFT, 7, movetoworkspace, 7
          bind = $mainMod SHIFT, 8, movetoworkspace, 8
          bind = $mainMod SHIFT, 9, movetoworkspace, 9
          bind = $mainMod SHIFT, 0, movetoworkspace, 10

          # Example special workspace (scratchpad)
          bind = $mainMod, S, togglespecialworkspace, magic
          bind = $mainMod SHIFT, S, movetoworkspace, special:magic

          # Scroll through existing workspaces with mainMod + scroll
          bind = $mainMod, mouse_down, workspace, e+1
          bind = $mainMod, mouse_up, workspace, e-1

          # Move/resize windows with mainMod + LMB/RMB and dragging
          bindm = $mainMod, mouse:272, movewindow
          bindm = $mainMod, mouse:273, resizewindow

          bind = $mainMod, space, exec, wofi --show drun
          bind = $mainMod, l, ${config.graphical.wlogout.homePath}
        '';
        systemd = {
          enable = true;
        };
      };
    };
  };
}
