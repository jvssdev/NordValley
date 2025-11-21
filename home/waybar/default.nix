{
  pkgs,
  config,
  isRiver ? false,
  isMango ? false,
  ...
}:

let
  colors = config.colorScheme.palette;

  commonModulesCenter = [
    "mpris"
    "clock"
  ];

  commonModulesRight = [
    "battery"
    "pulseaudio"
    # "custom/notification"
    "tray"
    "custom/power"
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
      "custom/dwl-tags"
      "dwl/window"
    ];

    "custom/dwl-tags" = {
      num-tags = 9;
      hide-vacant = true;
      expand = false;
      disable-click = true;
      format = "{index}";
      format-icons = [
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
      ];
    };

    "dwl/window" = {
      format = "{app_id} | {title}";
      max-length = 50;
      rewrite = {
        "\\| " = "";
      };
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
        margin: 0px;
        padding: 0px;
      }
      window#waybar {
        background: #${colors.base00};
        color: #${colors.base05};
        border-bottom: 2px solid #${colors.base02};
      }

      #tags, #custom-dwl-tags {
        padding: 0 6px;
      }
      #tags button, #custom-dwl-tags .tag {
        padding: 0 8px;
        margin: 0 2px;
        border-radius: 4px;
        color: #${colors.base05};
      }
      #tags button.occupied, #custom-dwl-tags .occupied {
        color: #${colors.base05};
      }
      #tags button.focused, #custom-dwl-tags .focused {
        background: #${colors.base0D};
        color: #${colors.base00};
      }
      #tags button.urgent, #custom-dwl-tags .urgent {
        color: #${colors.base08};
      }
      #window {
        padding: 0 10px;
        color: #${colors.base05};
      }
      #mpris {
        padding: 0 10px;
        color: #${colors.base0B};
      }
      #mpris.paused {
        color: #${colors.base03};
        font-style: italic;
      }
      #clock {
        padding: 0 10px;
        color: #${colors.base05};
      }
      #battery {
        padding: 0 10px;
        color: #${colors.base05};
      }
      #battery.warning {
        color: #${colors.base0A};
      }
      #battery.critical {
        color: #${colors.base08};
      }
      #pulseaudio {
        padding: 0 10px;
        color: #${colors.base05};
      }
      #pulseaudio.muted {
        color: #${colors.base03};
      }
      #tray {
        padding: 0 10px;
      }
      #custom-notification {
        padding: 0 10px;
        color: #${colors.base05};
      }
      #custom-power {
        padding: 0 10px;
        color: #${colors.base08};
      }
      #custom-power:hover {
        background: #${colors.base08};
        color: #${colors.base00};
      }
    '';

    settings.mainBar = {
      layer = "top";
      position = "top";
      exclusive = true;
      passthrough = false;
      gtk-layer-shell = true;
      ipc = false;
      height = 25;
      margin = "0";

      modules-left = selectedConfig.modules-left or [ ];
      modules-center = commonModulesCenter;
      modules-right = commonModulesRight;

      mpris = {
        format = "{player_icon} {artist} - {title}";
        "format-paused" = "{status_icon} <i>{artist} - {title}</i>";
        "player-icons".default = "";
        "status-icons".paused = "";
        max-length = 80;
        # "ignored-players" = [ "firefox" ];
      };

      clock = {
        format = "{:%H:%M %d/%m}";
      };

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        tooltip = false;
        "menu" = "on-click";
        "format-icons" = [
          "󰂎"
          "󰁻"
          "󰁽"
          "󰁿"
          "󰂁"
          "󰁹"
        ];
      };

      pulseaudio = {
        "disable-scroll" = true;
        format = "{icon} {volume}%";
        "format-muted" = "";
        "format-icons".default = [
          ""
          ""
          ""
        ];
        "on-click" = "pavucontrol";
      };

      tray = {
        "icon-size" = 21;
        spacing = 10;
      };

      # "custom/notification" = {
      #   format = "{}";
      #   tooltip = false;
      # };

      "custom/power" = {
        format = "⏻";
        tooltip = false;
        "on-click" = "wleave";
      };
    }
    // selectedConfig;
  };
}
