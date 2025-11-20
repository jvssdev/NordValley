{ pkgs, config, ... }:

let
  colors = config.colorScheme.palette;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    style = ''
      * {
        font-family: JetBrainsMono Nerd Font, Montserrat;
        font-size: 13px;
      }
      window#waybar {
        background: #${colors.base00};
        color: #${colors.base05};
        border-bottom: 2px solid #${colors.base02};
      }
      #tags {
        padding: 0px 6px;
      }
      #tags button {
        padding: 0px 6px;
        min-width: 0px;
        border-radius: 0px;
        color: #${colors.base05};
      }
      #tags button.occupied {
        color: #${colors.base05};
      }
      #tags button.focused {
        color: #${colors.base0F};
      }
      #tags button.urgent {
        color: #${colors.base08};
      }
      #clock, #battery, #cpu, #memory, #network, #bluetooth,#pulseaudio, #tray {
        padding: 0 10px;
      }
      #bluetooth.connected {
        color: #${colors.base0F};
      }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [
          "river/tags"
        ];

        modules-center = [ "clock" ];

        modules-right = [
          "cpu"
          "memory"
          "battery"
          "tray"
          "network"
          "bluetooth"
          "pulseaudio"
        ];

        "river/tags" = {
          "hide-vacant" = true;
        };

        "clock" = {
          format = "{:%H:%M  %d/%m}";
        };

        "battery" = {
          format = "{capacity}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        "network" = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "";
          format-disconnected = "Disconnected";
        };

        "bluetooth" = {
          format = " {status}";
          format-connected = " {num_connections} conected";
          format-disabled = "󰂲 off";
          format-off = "󰂲 off";
          format-on = " on";
          tooltip-format = "{controller_alias}\t{controller_address}";
          on-click = "blueman-manager";
          on-click-right = "rfkill toggle bluetooth";
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            default = [
              ""
              ""
            ];
          };
        };

        "cpu" = {
          format = "{usage}% ";
        };

        "memory" = {
          format = "{}% ";
        };

        "tray" = {
          spacing = 10;
        };
      };
    };
  };
}
