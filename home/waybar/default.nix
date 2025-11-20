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
      #tags button {
        padding: 0 10px;
      }
      #tags button.focused {
        background: #${colors.base0D};
        color: #${colors.base00};
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
          "river/window"
        ];
        modules-center = [ "river/layout" ];
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
          num-tags = 9;
        };

        "river/window" = {
          max-length = 50;
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
