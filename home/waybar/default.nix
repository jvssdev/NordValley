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

  # ---------- MANGOWC ----------
  mangoConfig = {
    modules-left = [
      "ext/workspaces"
      "dwl/tags"
      "dwl/window"
    ];

    "ext/workspaces" = {
      format = "{icon}";
      "ignore-hidden" = true;
      "on-click" = "activate";
      "on-click-right" = "deactivate";
      "sort-by-id" = true;
    };

    "dwl/tags" = {
      "num-tags" = 9;
    };

    "dwl/window" = {
      format = "[{layout}]{title}";
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
      #tags, #workspaces, #ext-workspaces {
        padding: 0px 6px;
      }
      #tags button, #workspaces button, #ext-workspaces button {
        padding: 0px 6px;
        min-width: 0px;
        border-radius: 0px;
        color: #${colors.base05};
      }
      #tags button.occupied, #workspaces button.occupied {
        color: #${colors.base05};
      }
      #tags button.focused, #workspaces button.focused {
        color: #${colors.base0F};
      }
      #tags button.urgent, #workspaces button.urgent {
        color: #${colors.base08};
      }
      #clock, #battery, #cpu, #memory, #network, #bluetooth, #pulseaudio, #tray {
        padding: 0 10px;
      }
      #bluetooth.connected {
        color: #${colors.base0F};
      }
    '';

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;

      modules-left = selectedConfig.modules-left or [ ];
      modules-center = [ "clock" ];
      modules-right = commonModulesRight;

    }
    // selectedConfig
    // {
      clock = {
        format = "{:%H:%M %d/%m}";
      };
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
        "format-disabled" = "bluetooth off";
        "format-off" = "bluetooth off";
        "format-on" = "bluetooth on";
        "tooltip-format" = "{controller_alias}\t{controller_address}";
        "on-click" = "blueman-manager";
        "on-click-right" = "rfkill toggle bluetooth";
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
    };
  };
}
