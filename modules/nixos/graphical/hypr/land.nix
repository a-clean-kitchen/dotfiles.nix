{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.graphical.hyprland;

  inherit (lib) mkIf mkDefault mkOption types;
in {
  imports = [
    ./scripts/startup.nix
  ];

  options.graphical.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = config.graphical.enable;
      description = "enable hyprland";
    };
    
    sixteenbynine = mkOption {
      type = types.bool;
      default = false;
    };
    exclusiveHyprConfig = mkOption {
      type = types.lines;
      default = "";
      description = "exclusive module style";
    };
  };
  
  config = mkIf (cfg.enable && config.graphical.enable) {
    environment.systemPackages = with pkgs; [
      fzf
      xdg-desktop-portal-hyprland
    ];
    hardware.graphics.enable = mkDefault true;
    security.polkit.enable = mkDefault true;
    programs = {
      dconf.enable = mkDefault true;
    };
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ 
        xdg-desktop-portal-termfilechooser
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        xdg-desktop-portal
      ];
      config = { 
        common.default = "*";
        hyprland = {
          default = [
            "hyprland"
            "termfilechooser"
            "gtk"
          ];
          "org.freedesktop.portal.FileManager" = [
            "termfilechooser"
          ];
          "org.freedesktop.portal.FileManager1" = [
            "termfilechooser"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [
            "termfilechooser"
          ];
          "org.freedesktop.portal.Settings" = [
            "gtk"
          ];
        };
      };
    };
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        wl-clipboard
      ];
      xdg.configFile = {
        "hypr/conf/startup.conf" = {
          text = /*hyprlang*/ ''
          # exec-once = ${config.graphical.hyprland.scripts.xdgNuke}
          exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

          $wallDIR = $HOME/Pictures/wallpapers
          exec-once = ${config.graphical.wallpapers.script} init $wallDIR/wanderer.jpg

          ${if config.graphical.waybar.enable then "exec-once = waybar &" else ""}
          ${if config.graphical.hypridle.enable then "exec-once = hypridle &" else ""}
          ${if config.graphical.dunst.enable then "exec-once = dunst &" else ""}

          exec-once = wl-paste --type text --watch cliphist store 
          exec-once = wl-paste --type image --watch cliphist store
          '';
        };
      };
      wayland.windowManager.hyprland = {
        enable = true;
        systemd = {
          enable = true;
        };
        extraConfig = let
          volScript = "${inputs.sqripts.packages."${config.nixpkgs.hostPlatform.system}".volume}/bin/volume";
          briScript = "${inputs.sqripts.packages."${config.nixpkgs.hostPlatform.system}".brightness}/bin/brightness";
          recScript = "${inputs.sqripts.packages."${config.nixpkgs.hostPlatform.system}".screenshot}/bin/screenshot";
        in /*hyprlang*/ ''
          $terminal = kitty
          $configs = $HOME/.config/hypr/conf

          source = $configs/startup.conf

          ${if cfg.sixteenbynine then "monitor = , 1920x1080@60, 0x0, 1" else ""}

          misc {
            # sowwy hypr
            disable_hyprland_logo = true
            disable_splash_rendering = true
            font_family = ${config.bestFont}
            # Needed for obsidian, I guess https://help.obsidian.md/web-clipper/troubleshoot#Obsidian+opens+but+only+the+file+name+is+saved
            focus_on_activate = true
          }
          
          # Some default env vars.
          env = XCURSOR_SIZE,24
          env = QT_QPA_PLATFORMTHEME,qt5ct # change to qt6ct if you have that
          env = TERM,xterm-$terminal
          env = EDITOR,nvim

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
          
          ecosystem {
            no_update_news = true
            no_donation_nag = true
          }
          general {
            gaps_in = 8
            gaps_out = 15
            border_size = 5
            col.active_border = 0xfff5c2e7
            col.inactive_border = 0xff45475a
            # apply_sens_to_raw=0 # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
          }

          decoration {
            shadow {
              enabled = true
              range = 100
              render_power = 5
              color = 0x33000000
              color_inactive = 0x22000000
            }
            rounding = 15
            active_opacity = 0.9
            inactive_opacity = 0.9
            fullscreen_opacity = 0.9
          }

          animations {
            enabled = yes
            bezier = overshot,0.13,0.99,0.29,1.1
            animation = windows,1,4,overshot,slide
            animation = border,1,10,default
            animation = fade,1,10,default
            animation = workspaces,1,6,overshot,slidevert
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
          bind = $mainMod, F, fullscreen,

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

          layerrule = blur, logout_dialog
          bind = CTRL_ALT, Delete, exec, ~/${config.graphical.wlogout.homePath}
          bind = $mainMod, l, exec, hyprlock

          bind = $mainMod SHIFT, S, exec, ${recScript} ROFI 
          bind = ,Print, exec, ${recScript} PRINTSCREEN

          binde = ,XF86MonBrightnessDown, exec, ${briScript} DEC 
          binde = ,XF86MonBrightnessUp, exec, ${briScript} INC
          binde = ,XF86AudioRaiseVolume, exec, ${volScript} INC
          binde = ,XF86AudioLowerVolume, exec, ${volScript} DEC
          bind = ,XF86AudioMute, exec, ${volScript} TOGGLE
          bind = ,XF86AudioMicMute, exec, ${volScript} TOGGLE-MIC

          # defined in config.graphical.hyprland.exclusiveHyprConfig
          ${cfg.exclusiveHyprConfig}
        '';
      };
    };
  };
}
