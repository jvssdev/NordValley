{
  config,
  lib,
  pkgs,
  ...
}:
let
  grim = "${pkgs.grim}/bin/grim";
  slurp = "${pkgs.slurp}/bin/slurp";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
  pamixer = "${pkgs.pamixer}/bin/pamixer";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";

  moveStep = "100";
  resizeStep = "100";
  volumeStep = "5";
  brightnessStep = "5%";

  # Helper function to generate tag numbers
  tagNum = n: toString (builtins.bitShiftL 1 (n - 1));
in
{
  wayland.windowManager.river.settings = {
    map = {
      normal = {
        # Window management
        "Super Q" = "close";
        "Super Space" = "toggle-float";
        "Super F" = "toggle-fullscreen";
        "Super Return" = "zoom";

        # Application launchers
        "Super B" = "spawn zen-browser";
        "Super A" = "spawn fuzzel";
        "Super T" = "spawn ghostty";

        # Screenshots
        "Super P" = "spawn '${grim} -g \"$(${slurp})\" - | ${wl-copy}'";

        # Focus management
        "Super J" = "focus-view next";
        "Super K" = "focus-view previous";
        "Super+Shift J" = "swap next";
        "Super+Shift K" = "swap previous";

        # Output focus
        "Super Period" = "focus-output next";
        "Super Comma" = "focus-output previous";
        "Super+Shift Period" = "send-to-output next";
        "Super+Shift Comma" = "send-to-output previous";

        # Wideriver layout commands
        "Super H" = "send-layout-cmd wideriver '--ratio -0.025'";
        "Super L" = "send-layout-cmd wideriver '--ratio +0.025'";
        "Super+Shift H" = "send-layout-cmd wideriver '--count +1'";
        "Super+Shift L" = "send-layout-cmd wideriver '--count -1'";
        "Super Equal" = "send-layout-cmd wideriver '--ratio 0.50'";
        "Super M" = "send-layout-cmd wideriver '--layout-toggle'";

        # Layout switching
        "Super Up" = "send-layout-cmd wideriver '--layout top'";
        "Super Down" = "send-layout-cmd wideriver '--layout bottom'";
        "Super Left" = "send-layout-cmd wideriver '--layout left'";
        "Super Right" = "send-layout-cmd wideriver '--layout right'";

        # Move views
        "Super+Alt H" = "move left ${moveStep}";
        "Super+Alt J" = "move down ${moveStep}";
        "Super+Alt K" = "move up ${moveStep}";
        "Super+Alt L" = "move right ${moveStep}";

        # Snap views
        "Super+Alt+Control H" = "snap left";
        "Super+Alt+Control J" = "snap down";
        "Super+Alt+Control K" = "snap up";
        "Super+Alt+Control L" = "snap right";

        # Resize views
        "Super+Alt+Shift H" = "resize horizontal -${resizeStep}";
        "Super+Alt+Shift J" = "resize vertical ${resizeStep}";
        "Super+Alt+Shift K" = "resize vertical -${resizeStep}";
        "Super+Alt+Shift L" = "resize horizontal ${resizeStep}";

        # Passthrough mode
        "Super F11" = "enter-mode passthrough";

        # Tags (workspaces) 1-9
        "Super 1" = "set-focused-tags ${tagNum 1}";
        "Super 2" = "set-focused-tags ${tagNum 2}";
        "Super 3" = "set-focused-tags ${tagNum 3}";
        "Super 4" = "set-focused-tags ${tagNum 4}";
        "Super 5" = "set-focused-tags ${tagNum 5}";
        "Super 6" = "set-focused-tags ${tagNum 6}";
        "Super 7" = "set-focused-tags ${tagNum 7}";
        "Super 8" = "set-focused-tags ${tagNum 8}";
        "Super 9" = "set-focused-tags ${tagNum 9}";
        "Super 0" = "set-focused-tags 4294967295";

        "Super+Shift 1" = "set-view-tags ${tagNum 1}";
        "Super+Shift 2" = "set-view-tags ${tagNum 2}";
        "Super+Shift 3" = "set-view-tags ${tagNum 3}";
        "Super+Shift 4" = "set-view-tags ${tagNum 4}";
        "Super+Shift 5" = "set-view-tags ${tagNum 5}";
        "Super+Shift 6" = "set-view-tags ${tagNum 6}";
        "Super+Shift 7" = "set-view-tags ${tagNum 7}";
        "Super+Shift 8" = "set-view-tags ${tagNum 8}";
        "Super+Shift 9" = "set-view-tags ${tagNum 9}";
        "Super+Shift 0" = "set-view-tags 4294967295";

        "Super+Control 1" = "toggle-focused-tags ${tagNum 1}";
        "Super+Control 2" = "toggle-focused-tags ${tagNum 2}";
        "Super+Control 3" = "toggle-focused-tags ${tagNum 3}";
        "Super+Control 4" = "toggle-focused-tags ${tagNum 4}";
        "Super+Control 5" = "toggle-focused-tags ${tagNum 5}";
        "Super+Control 6" = "toggle-focused-tags ${tagNum 6}";
        "Super+Control 7" = "toggle-focused-tags ${tagNum 7}";
        "Super+Control 8" = "toggle-focused-tags ${tagNum 8}";
        "Super+Control 9" = "toggle-focused-tags ${tagNum 9}";

        "Super+Shift+Control 1" = "toggle-view-tags ${tagNum 1}";
        "Super+Shift+Control 2" = "toggle-view-tags ${tagNum 2}";
        "Super+Shift+Control 3" = "toggle-view-tags ${tagNum 3}";
        "Super+Shift+Control 4" = "toggle-view-tags ${tagNum 4}";
        "Super+Shift+Control 5" = "toggle-view-tags ${tagNum 5}";
        "Super+Shift+Control 6" = "toggle-view-tags ${tagNum 6}";
        "Super+Shift+Control 7" = "toggle-view-tags ${tagNum 7}";
        "Super+Shift+Control 8" = "toggle-view-tags ${tagNum 8}";
        "Super+Shift+Control 9" = "toggle-view-tags ${tagNum 9}";

        # Media keys
        "None XF86AudioRaiseVolume" = "spawn '${pamixer} -i ${volumeStep}'";
        "None XF86AudioLowerVolume" = "spawn '${pamixer} -d ${volumeStep}'";
        "None XF86AudioMute" = "spawn '${pamixer} --toggle-mute'";
        "None XF86AudioMedia" = "spawn '${playerctl} play-pause'";
        "None XF86AudioPlay" = "spawn '${playerctl} play-pause'";
        "None XF86AudioPrev" = "spawn '${playerctl} previous'";
        "None XF86AudioNext" = "spawn '${playerctl} next'";
        "None XF86MonBrightnessUp" = "spawn '${brightnessctl} set ${brightnessStep}+'";
        "None XF86MonBrightnessDown" = "spawn '${brightnessctl} set ${brightnessStep}-'";
      };

      passthrough = {
        "Super F11" = "enter-mode normal";
      };

      locked = {
        "None XF86AudioRaiseVolume" = "spawn '${pamixer} -i ${volumeStep}'";
        "None XF86AudioLowerVolume" = "spawn '${pamixer} -d ${volumeStep}'";
        "None XF86AudioMute" = "spawn '${pamixer} --toggle-mute'";
        "None XF86AudioMedia" = "spawn '${playerctl} play-pause'";
        "None XF86AudioPlay" = "spawn '${playerctl} play-pause'";
        "None XF86AudioPrev" = "spawn '${playerctl} previous'";
        "None XF86AudioNext" = "spawn '${playerctl} next'";
        "None XF86MonBrightnessUp" = "spawn '${brightnessctl} set ${brightnessStep}+'";
        "None XF86MonBrightnessDown" = "spawn '${brightnessctl} set ${brightnessStep}-'";
      };
    };

    map-pointer.normal = {
      "Super BTN_LEFT" = "move-view";
      "Super BTN_RIGHT" = "resize-view";
      "Super BTN_MIDDLE" = "toggle-float";
    };
  };
}
