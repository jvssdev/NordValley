{
  config,
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.river.settings.map.normal = {
    # Apps
    "Super T" = "spawn ghostty";
    "Super A" = "spawn fuzzel";
    "Super B" = "spawn helium";
    "Super E" = "spawn thunar";
    "Super X" = "spawn wlogout";

    # Screenshot area
    "Super P" = "spawn 'grim -g \"$(slurp)\" - | wl-copy'";

    # Clipboard history
    "Super V" = "spawn fuzzel-clipboard";
    "Super+Shift V" = "spawn fuzzel-clipboard-clear";

    # Dunst history
    "Super N" = "spawn dunst-fuzzel";

    # Window control
    "Super Q" = "close";
    "Super Space" = "toggle-float";
    "Super F" = "toggle-fullscreen";
    "Super Return" = "zoom";

    # Focus
    "Super J" = "focus-view next";
    "Super K" = "focus-view previous";
    "Super H" = "send-layout-cmd wideriver '--ratio -0.05'";
    "Super L" = "send-layout-cmd wideriver '--ratio +0.05'";

    # Master count
    "Super I" = "send-layout-cmd wideriver '--count +1'";
    "Super D" = "send-layout-cmd wideriver '--count -1'";

    # Layouts
    "Super M" = "send-layout-cmd wideriver '--layout monocle'";
    "Super+Shift M" = "send-layout-cmd wideriver '--layout left'";

    # Move/Resize
    "Super+Alt H" = "move left 100";
    "Super+Alt J" = "move down 100";
    "Super+Alt K" = "move up 100";
    "Super+Alt L" = "move right 100";

    # Tags (workspaces)
    "Super 1" = "set-focused-tags 1";
    "Super 2" = "set-focused-tags 2";
    "Super 3" = "set-focused-tags 4";
    "Super 4" = "set-focused-tags 8";
    "Super 5" = "set-focused-tags 16";
    "Super 6" = "set-focused-tags 32";
    "Super 7" = "set-focused-tags 64";
    "Super 8" = "set-focused-tags 128";
    "Super 9" = "set-focused-tags 256";

    "Super+Shift 1" = "set-view-tags 1";
    "Super+Shift 2" = "set-view-tags 2";
    "Super+Shift 3" = "set-view-tags 4";
    "Super+Shift 4" = "set-view-tags 8";
    "Super+Shift 5" = "set-view-tags 16";
    "Super+Shift 6" = "set-view-tags 32";
    "Super+Shift 7" = "set-view-tags 64";
    "Super+Shift 8" = "set-view-tags 128";
    "Super+Shift 9" = "set-view-tags 256";

    # Outputs
    "Super Period" = "focus-output next";
    "Super Comma" = "focus-output previous";
    "Super+Shift Period" = "send-to-output next";
    "Super+Shift Comma" = "send-to-output previous";

    # Media keys
    "None XF86AudioRaiseVolume" = "spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+'";
    "None XF86AudioLowerVolume" = "spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-'";
    "None XF86AudioMute" = "spawn 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'";
    "None XF86MonBrightnessUp" = "spawn 'brightnessctl s 5%+'";
    "None XF86MonBrightnessDown" = "spawn 'brightnessctl s 5%-'";
    "None XF86AudioPlay" = "spawn 'playerctl play-pause'";
    "None XF86AudioNext" = "spawn 'playerctl next'";
    "None XF86AudioPrev" = "spawn 'playerctl previous'";
  };

  wayland.windowManager.river.settings.map-pointer.normal = {
    "Super BTN_LEFT" = "move-view";
    "Super BTN_RIGHT" = "resize-view";
    "Super BTN_MIDDLE" = "toggle-float";
  };
}
