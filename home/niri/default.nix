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
