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
        color: #${colors.base0E};
      }
      #tags button.urgent {
        color: #${colors.base08};
      }
      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray {
        padding: 0 10px;
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

        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
          "clock"
          "tray"
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
