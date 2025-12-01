{
  config,
  pkgs,
  lib,
  ...
}:
let
  palette = config.colorScheme.palette;
in
{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      prefer-no-csd = true;

      binds = {
        "Mod+A".action.spawn = "fuzzel";
        "Mod+T".action.spawn = "ghostty";
        "Mod+T".action.spawn = "helium";

        
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        "Mod+Q".action = actions.close-window;
        "Mod+Shift+T".action = actions.toggle-window-floating;
        "Mod+Shift+F".action = actions.fullscreen-window;
        "Mod+Alt+F".action = actions.toggle-windowed-fullscreen;
        "Mod+F".action = actions.maximize-column;

        "Mod+W".action = actions.toggle-column-tabbed-display;

        # Tab Navigation
        "Mod+Left".action = actions.focus-window-down;
        "Mod+Right".actions = actions.focus-window-up;

        "Mod+Shift+1".action = actions.move-column-to-workspace 1;
        "Mod+Shift+2".action = actions.move-column-to-workspace 2;
        "Mod+Shift+3".action = actions.move-column-to-workspace 3;
        "Mod+Shift+4".action = actions.move-column-to-workspace 4;
        "Mod+Shift+5".action = actions.move-column-to-workspace 5;
        "Mod+Shift+6".action = actions.move-column-to-workspace 6;
        "Mod+Shift+7".action = actions.move-column-to-workspace 7;
        "Mod+Shift+8".action = actions.move-column-to-workspace 8;
        "Mod+Shift+9".action = actions.move-column-to-workspace 9;

        "Mod+BracketLeft".action = actions.consume-or-expel-window-left;
        "Mod+BracketRight".action = actions.consume-or-expel-window-right;
        "Mod+Period".actions.expel-window-from-column;
        
        "Mod+Minus".action = actions.set-column-width "-10%";
        "Mod+Equal".action = actions.set-column-width "+10%";

        "Mod+Shift+Minus".action = actions.set-window-height "-10%";
        "Mod+Shift+Equal".action = actions.set-window-height "+10%";
             
        "Mod+H".action = actions.focus-column-left;
        "Mod+L".action = actions.focus-column-right;
        
        "Mod+J".action = actions.focus-workspace-up;
        "Mod+K".action = actions.focus-workspace-down;
        # "Mod+Page_Up".action = actions.focus-workspace-up;
        # "Mod+Control+Page_Down".action = actions.focus-workspace-down;
        # "Mod+Control+Page_Up".action = actions.focus-workspace-up;
        # "Mod+WheelScrollDown".action = actions.focus-workspace-down;
        "Mod+WheelScrollUp".action = actions.focus-workspace-up;
        "Control+Mod+WheelScrollDown".action = actions.focus-workspace-down;
        "Control+Mod+WheelScrollUp".action = actions.focus-workspace-up;
      };


      hotkey-overlay = {
        skip-at-startup = true;
      };
      layout = {
        focus-ring = {
          enable = true;
          width = 2;
          active = {
            color = ${palette.base02};
          };
          inactive = {
            color = ${palette.base01};
          };
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
