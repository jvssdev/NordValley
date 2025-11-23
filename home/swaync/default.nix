{
  pkgs,
  lib,
  config,
  ...
}:
let
  c = config.colorScheme.palette;
in
{
  services.swaync = {
    enable = true;
    package = pkgs.swaynotificationcenter;

    settings = {
      "$schema" = "/etc/xdg/swaync/configSchema.json";
      positionX = "right";
      positionY = "top";
      cssPriority = "user";
      layer = "overlay";
      layer-shell = true;

      control-center-width = 380;
      control-center-height = 860;
      control-center-margin-top = 2;
      control-center-margin-bottom = 2;
      control-center-margin-right = 1;
      control-center-margin-left = 0;

      notification-window-width = 400;
      notification-icon-size = 48;
      notification-body-image-height = 160;
      notification-body-image-width = 200;

      timeout = 4;
      timeout-low = 2;
      timeout-critical = 6;

      fit-to-screen = false;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = false;
      script-fail-notify = true;

      scripts = {
        example-script = {
          exec = "echo 'Do something...'";
          urgency = "Normal";
        };
      };

      notification-visibility = {
        example-name = {
          state = "muted";
          urgency = "Low";
          app-name = "Spotify";
        };
      };

      widgets = [
        "label"
        "mpris"
        "title"
        "dnd"
        "notifications"
      ];

      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = " 󰎟 ";
        };
        dnd = {
          text = "Do not disturb";
        };
        label = {
          max-lines = 1;
          text = " ";
        };
        mpris = {
          image-size = 96;
          image-radius = 12;
        };
        volume = {
          label = "󰕾";
          show-per-app = true;
        };
      };
    };

    style = ''
      @define-color text            #${c.base05};
      @define-color background      #${c.base00};
      @define-color background-alt  #${c.base01};
      @define-color selected        #${c.base03};
      @define-color hover           #${c.base05};
      @define-color urgent          #${c.base08};

      * {
        color: @text;
        all: unset;
        font-size: 14px;
        font-family: "JetBrains Mono Nerd Font 10";
        transition: 200ms;
      }

      .notification-row {
        outline: none;
        margin: 0;
        padding: 0px;
      }

      .floating-notifications.background .notification-row .notification-background {
        background: alpha(@background, .55);
        box-shadow: 0 0 8px 0 rgba(0,0,0,.6);
        border: 1px solid @selected;
        border-radius: 24px;
        margin: 16px;
        padding: 0;
      }

      .floating-notifications.background .notification-row .notification-background .notification {
        padding: 6px;
        border-radius: 12px;
      }

      .floating-notifications.background .notification-row .notification-background .notification.critical {
        border: 2px solid @urgent;
      }

      .floating-notifications.background .notification-row .notification-background .notification .notification-content {
        margin: 14px;
      }

      .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * {
        min-height: 3.4em;
      }

      .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action {
        border-radius: 8px;
        background-color: @background-alt;
        margin: 6px;
        border: 1px solid transparent;
      }

      .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
        background-color: @hover;
        border: 1px solid @selected;
      }

      .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
        background-color: @selected;
        color: @background;
      }

      .image {
        margin: 10px 20px 10px 0px;
      }

      .summary {
        font-weight: 800;
        font-size: 1rem;
      }

      .body {
        font-size: 0.8rem;
      }

      .floating-notifications.background .notification-row .notification-background .close-button {
        margin: 6px;
        padding: 2px;
        border-radius: 6px;
        background-color: transparent;
        border: 1px solid transparent;
      }

      .floating-notifications.background .notification-row .notification-background .close-button:hover {
        background-color: @selected;
      }

      .floating-notifications.background .notification-row .notification-background .close-button:active {
        background-color: @selected;
        color: @background;
      }

      .notification.critical progress {
        background-color: @selected;
      }

      .notification.low progress,
      .notification.normal progress {
        background-color: @selected;
      }

      /* CENTRAL CONTROL.CSS */
      @define-color background-alt-ctrl  alpha(#${c.base01}, .4);
      @define-color selected-ctrl        #${c.base0E};
      @define-color hover-ctrl           alpha(#${c.base0E}, .4);
      @define-color background-sec       #${c.base00};

      .blank-window {
        background: transparent;
      }

      .control-center {
        background: alpha(@background, .55);
        border-radius: 24px;
        border: 1px solid @selected-ctrl;
        box-shadow: 0 0 10px 0 rgba(0,0,0,.6);
        margin: 18px;
        padding: 12px;
      }

      .control-center .notification-row .notification-background,
      .control-center .notification-row .notification-background .notification.critical {
        background-color: @background-alt-ctrl;
        border-radius: 16px;
        margin: 4px 0px;
        padding: 4px;
      }

      .control-center .notification-row .notification-background .notification.critical {
        color: @urgent;
      }

      .control-center .notification-row .notification-background .notification .notification-content {
        margin: 6px;
        padding: 8px 6px 2px 2px;
      }

      .control-center .notification-row .notification-background .notification > *:last-child > * {
        min-height: 3.4em;
      }

      .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action {
        background: alpha(@selected-ctrl, .6);
        color: @text;
        border-radius: 12px;
        margin: 6px;
      }

      .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
        background: @selected-ctrl;
      }

      .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
        background-color: @selected-ctrl;
      }

      .control-center .notification-row .notification-background .close-button {
        background: transparent;
        border-radius: 6px;
        color: @text;
        margin: 0px;
        padding: 4px;
      }

      .control-center .notification-row .notification-background .close-button:hover {
        background-color: @selected-ctrl;
      }

      .control-center .notification-row .notification-background .close-button:active {
        background-color: @selected-ctrl;
      }

      progressbar,
      progress,
      trough {
        border-radius: 12px;
      }

      progressbar {
        background-color: rgba(255,255,255,.1);
      }

      .notification-group {
        margin: 2px 8px 2px 8px;
      }

      .notification-group-headers {
        font-weight: bold;
        font-size: 1.25rem;
        color: @text;
        letter-spacing: 2px;
      }

      .notification-group-icon {
        color: @text;
      }

      .notification-group-collapse-button,
      .notification-group-close-all-button {
        background: transparent;
        color: @text;
        margin: 4px;
        border-radius: 6px;
        padding: 4px;
      }

      .notification-group-collapse-button:hover,
      .notification-group-close-all-button:hover {
        background: @hover-ctrl;
      }

      .widget-title {
        font-size: 1.2em;
        margin: 6px;
      }

      .widget-title button {
        background: @background-alt-ctrl;
        border-radius: 6px;
        padding: 4px 16px;
      }

      .widget-title button:hover {
        background-color: @hover-ctrl;
      }

      .widget-title button:active {
        background-color: @selected-ctrl;
      }

      .widget-dnd {
        margin: 6px;
        font-size: 1.2rem;
      }

      .widget-dnd > switch {
        background: @background-alt-ctrl;
        font-size: initial;
        border-radius: 8px;
        box-shadow: none;
        padding: 2px;
      }

      .widget-dnd > switch:hover {
        background: @hover-ctrl;
      }

      .widget-dnd > switch:checked {
        background: @selected-ctrl;
      }

      .widget-dnd > switch:checked:hover {
        background: @hover-ctrl;
      }

      .widget-dnd > switch slider {
        background: @text;
        border-radius: 6px;
      }

      .widget-mpris {
        background: @background-alt-ctrl;
        border-radius: 16px;
        color: @text;
        margin: 20px 6px;
      }

      .widget-mpris-player {
        background-color: @background-sec;
        border-radius: 22px;
        padding: 6px 14px;
        margin: 6px;
      }

      .widget-mpris > box > button {
        color: @text;
        border-radius: 20px;
      }

      .widget-mpris button {
        color: alpha(@text, .6);
      }

      .widget-mpris button:hover {
        color: @text;
      }

      .widget-mpris-album-art {
        border-radius: 16px;
      }

      .widget-mpris-title {
        font-weight: 700;
        font-size: 1rem;
      }

      .widget-mpris-subtitle {
        font-weight: 500;
        font-size: 0.8rem;
      }

      .widget-volume {
        background: @background-sec;
        color: @background;
        padding: 4px;
        margin: 6px;
        border-radius: 6px;
      }
    '';
  };
}
