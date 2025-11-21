{
  pkgs,
  config,
  isRiver ? false,
  isMango ? false,
  ...
}:

let
  colors = config.colorScheme.palette;

  commonModulesRight = [
    "cpu"
    "memory"
    "battery"
    "tray"
    "network"
    "bluetooth"
    "pulseaudio"
  ];

  # ---------- RIVER ----------
  riverConfig = {
    modules-left = [ "river/tags" ];

    "river/tags" = {
      "hide-vacant" = true;
    };
  };

  # ---------- MANGOWC  ----------
  mangoConfig = {
    modules-left = [
      "custom/dwl-tags"
      "dwl/window"
    ];

    "custom/dwl-tags" = {
      num-tags = 9;
      hide-empty = true;
      format = "{index}";
      format-icons = [
        "一"
        "二"
        "三"
        "四"
        "五"
        "六"
        "七"
        "八"
        "九"
      ];
    };

    "dwl/window" = {
      format = "{title}";
      max-length = 50;
      separate-by-spaces = true;
    };
  };

  selectedConfig =
    if isRiver then
      riverConfig
    else if isMango then
      mangoConfig
    else
      riverConfig;

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
      #tags button,
      #custom-dwl-tags .tag {
        padding: 0 8px;
        margin: 0 2px;
        border-radius: 4px;
      }
      #tags button.occupied,
      #custom-dwl-tags .occupied {
        color: #${colors.base05};
      }
      #tags button.focused,
      #custom-dwl-tags .focused {
        background: #${colors.base0D};
        color: #${colors.base00};
      }
      #tags button.urgent,
      #custom-dwl-tags .urgent {
        color: #${colors.base08};
      }

      #clock, #battery, #cpu, #memory, #network, #bluetooth, #pulseaudio, #tray {
        padding: 0 10px;
      }
      #bluetooth.connected { color: #${colors.base0F}; }
    '';

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;

      modules-left = selectedConfig.modules-left or [ ];
      modules-center = [ "clock" ];
      modules-right = commonModulesRight;

      clock.format = "{:%H:%M %d/%m}";

      battery = {
        format = "{capacity}% {icon}";
        "format-icons" = [
          "four_level_battery"
          "three_level_battery"
          "two_level_battery"
          "one_level_battery"
          "empty_battery"
        ];
      };

      network = {
        "format-wifi" = "{essid} ({signalStrength}%) wifi";
        "format-ethernet" = "ethernet";
        "format-disconnected" = "Disconnected";
      };

      bluetooth = {
        format = "bluetooth {status}";
        "format-connected" = "bluetooth {num_connections} conected";
        "format-off" = "bluetooth off";
        "on-click" = "blueman-manager";
      };

      pulseaudio = {
        format = "{volume}% {icon}";
        "format-muted" = "muted";
        "format-icons".default = [
          "volume_low"
          "volume_medium"
          "volume_high"
        ];
      };

      cpu.format = "{usage}% cpu";
      memory.format = "{}% memory";
      tray.spacing = 10;
    }
    // selectedConfig;
  };
}
