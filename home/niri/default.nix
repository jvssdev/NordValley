{
  config,
  pkgs,
  lib,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  niriPackages = inputs.niri-flake.packages.${system};
  xwaylandSatellitePkg = niriPackages.xwayland-satellite;
  palette = config.colorScheme.palette;
in
{
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    settings = {
      prefer-no-csd = true;

      xwayland-satellite = {
        enable = true;
        path = lib.getExe xwaylandSatellitePkg;
      };

      animations = {
        enable = false;
      };

      spawn-at-startup = [
        { command = [ "blueman-applet" ]; }
        { command = [ "waybar" ]; }
        { command = [ "wpaperd" ]; }
        {
          command = [
            "nm-applet"
            "--indicator"
          ];
        }
        # Note: polkit agent is started via systemd service in environment.nix
        {
          sh = "sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP";
        }
        { command = [ "swaync" ]; }
        {
          command = [
            "wl-paste"
            "--type"
            "text"
            "--watch"
            "cliphist"
            "store"
          ];
        }
        {
          command = [
            "wl-paste"
            "--type"
            "image"
            "--watch"
            "cliphist"
            "store"
          ];
        }
        {
          command = [
            "wl-clip-persist"
            "--clipboard both"
          ];
        }
      ];

      window-rules = [
        {
          matches = [ { app-id = "com.mitchellh.ghostty"; } ];
          opacity = 0.9;
        }
        {
          matches = [
            { app-id = "(?i)pavucontrol"; }
            { app-id = "(?i)org\\.pulseaudio\\.pavucontrol"; }
          ];
          open-floating = true;
        }
        {
          matches = [ { app-id = "(?i)nm-connection-editor"; } ];
          open-floating = true;
        }
        {
          matches = [
            { app-id = "(?i)blueman-manager"; }
            { app-id = "(?i)blueberry"; }
          ];
          open-floating = true;
        }
        # {
        #   matches = [{ app-id = "(?i)org\\.gnome\\.Calculator"; }];
        #   open-floating = true;
        # }
        {
          matches = [
            { app-id = "(?i)mpv"; }
            { app-id = "(?i)imv"; }
          ];
          open-floating = true;
        }
        {
          matches = [ { title = "(?i)Picture[-\\s]?in[-\\s]?Picture"; } ];
          open-floating = true;
        }
      ];

      binds = {
        "Mod+A".action.spawn = "fuzzel";
        "Mod+T".action.spawn = "ghostty";
        "Mod+B".action.spawn = "helium";

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        "Mod+Q".action = "close-window";
        "Mod+Shift+T".action = "toggle-window-floating";
        "Mod+Shift+F".action = "fullscreen-window";
        "Mod+Alt+F".action = "toggle-windowed-fullscreen";
        "Mod+F".action = "maximize-column";

        "Mod+W".action = "toggle-column-tabbed-display";

        # Tab Navigation
        "Mod+Left".action = "focus-window-down";
        "Mod+Right".action = "focus-window-up";

        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;

        "Mod+BracketLeft".action = "consume-or-expel-window-left";
        "Mod+BracketRight".action = "consume-or-expel-window-right";
        "Mod+Period".action = "expel-window-from-column";

        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";

        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        "Mod+H".action = "focus-column-left";
        "Mod+L".action = "focus-column-right";

        "Mod+J".action = "focus-workspace-up";
        "Mod+K".action = "focus-workspace-down";
        # "Mod+Page_Up".action = "focus-workspace-up";
        # "Mod+Control+Page_Down".action = "focus-workspace-down";
        # "Mod+Control+Page_Up".action = "focus-workspace-up";
        # "Mod+WheelScrollDown".action = "focus-workspace-down";
        "Mod+WheelScrollUp".action = "focus-workspace-up";
        "Control+Mod+WheelScrollDown".action = "focus-workspace-down";
        "Control+Mod+WheelScrollUp".action = "focus-workspace-up";
      };

      hotkey-overlay = {
        skip-at-startup = true;
      };

      layout = {
        focus-ring = {
          enable = true;
          width = 2;
          active = {
            color = "#${palette.base01}";
          };
          inactive = {
            color = "#${palette.base00}";
          };
        };
        border = {
          enable = true;
          width = 4;
          active = {
            color = "#${palette.base02}";
          };
          inactive = {
            color = "#${palette.base03}";
          };
        };
        tab-indicator = {
          width = 8;
          corner-radius = 0;
          place-within-column = true;
          length.total-proportion = 1.0;
        };
        window-rule = {
          geometry-corner-radius = 0;
          clip-to-geometry = true;
        };

        gaps = 5;

        # struts = {
        #   left = 20;
        #   right = 20;
        #   top = 20;
        #   bottom = 20;
        # };
      };

      input = {
        keyboard.xkb = {
          layout = "br";
          variant = "abnt2";
        };

        touchpad = {
          click-method = "button-areas";
          dwt = true;
          dwtp = true;
          natural-scroll = true;
          scroll-method = "two-finger";
          tap = true;
          tap-button-map = "left-right-middle";
          middle-emulation = true;
          accel-profile = "adaptive";
        };
        focus-follows-mouse.enable = true;
        warp-mouse-to-focus.enable = false;
      };

      outputs = {
        "DP-1" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 59.933998;
          };
          scale = 1.0;
          position = {
            x = 0;
            y = 0;
          };
        };
      };

      cursor = {
        size = 24;
        theme = "Bibata-Modern-Ice";
      };

      environment = {
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        ELECTRON_ENABLE_HARDWARE_ACCELERATION = "1";

        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "niri";
        DISPLAY = ":0";
      };
    };
  };
}
