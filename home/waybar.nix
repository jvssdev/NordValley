{ config, pkgs, ... }:

let
  palette = config.stylix.base16Scheme.palette;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = [
      {
        layer = "top";
        reload_style_on_change = true;

        modules-left = [
          "river/tags"
          "custom/player"
        ];
        modules-center = [ ];
        modules-right = [
          "custom/record"
          "custom/inbox"
          "bluetooth"
          "custom/mute"
          "battery"
          "custom/clock"
        ];

        "custom/clock" = {
          exec = "date +'%a %I:%M'";
          interval = 15;
          tooltip = false;
          "on-click" = "month";
        };

        battery = {
          bat = "BAT1";
          adapter = "ACAD";
          interval = 60;
          states = {
            warning = 50;
            critical = 25;
          };
          format = "{icon} {capacity}%";
          "format-charging" = "<span color=\"#${palette.base0B}\">Charging</span> {capacity}%";
          "format-icons" = [
            "<span color=\"#${palette.base08}\">Low</span>"
            "<span color=\"#${palette.base08}\">Low</span>"
            "<span color=\"#${palette.base0A}\">Low</span>"
            "<span color=\"#${palette.base0B}\">Low</span>"
            "<span color=\"#${palette.base0B}\">Low</span>"
          ];
        };

        "custom/mute" = {
          exec = "mute";
          format = "<span color=\"#${palette.base0E}\">{}</span>";
          tooltip = false;
          signal = 5;
        };

        bluetooth = {
          format = "";
          "format-off" = "Bluetooth OFF";
          "format-disabled" = "Bluetooth OFF";
          "format-connected" = "<span color=\"#${palette.base0D}\">Bluetooth</span> {num_connections}";
          "format-connected-battery" =
            "<span color=\"#${palette.base0D}\">Bluetooth</span> {num_connections}";
          "tooltip-format-enumerate-connected" = "{device_alias}";
          "tooltip-format-enumerate-connected-battery" = "{device_alias}: {device_battery_percentage}%";
          "tooltip-format" = "{device_enumerate}";
        };

        "custom/inbox" = {
          exec = "inbox";
          tooltip = false;
          "on-click" = "mailsync";
          signal = 4;
        };

        "custom/record" = {
          exec = "record";
          tooltip = false;
          signal = 3;
        };

        "custom/player" = {
          exec = "player";
          "exec-if" = "pgrep mpd";
          tooltip = false;
          "on-click" = "mpc toggle";
          signal = 1;
        };

        "river/tags" = {
          "hide-vacant" = true;
        };
      }
    ];

    style = with palette; ''
      * {
        border: none;
        border-radius: 0px;
        font-family: "JetBrainsMono Nerd Font";
        font-weight: bold;
        font-size: 15px;
        min-height: 13px;
      }

      window#waybar {
        background: #${base00};
        color: #${base05};
      }

      window#waybar.hidden {
        background: transparent;
      }

      #tags {
        padding: 0px 6px;
      }

      #custom-player,
      #custom-record,
      #custom-inbox,
      #bluetooth,
      #custom-mute,
      #battery,
      #custom-clock {
        padding: 0px 12px;
      }

      #tags button {
        padding: 0px 6px;
        min-width: 0px;
        border-radius: 0px;
        color: #${base05};
      }

      #tags button.occupied {
        color: #${base05};
      }

      #tags button.focused {
        color: #${base0E};
      }

      #tags button.urgent {
        color: #${base08};
      }

      #battery.warning,
      #battery.critical {
        color: #${base08};
      }

      #bluetooth.on {
        color: #${base0D};
      }
    '';
  };
}
