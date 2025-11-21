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
    "custom/notification"
    "tray"
    "custom/power"
  ];

  riverConfig = {
    modules-left = [ "river/tags" ];
    "river/tags" = {
      "hide-vacant" = true;
    };
  };

  mangoConfig = {
    modules-left = [
      "dwl/tags"
      "dwl/window"
    ];
    "dwl/tags" = {
      "num-tags" = 9;
      "hide-vacant" = true;
      expand = false;
      "disable-click" = true;
      "tag-labels" = [
      ];
    };
    "dwl/window" = {
      format = "{app_id} | {title}";
      "max-length" = 50;
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
        margin: 0;
        padding: 0;
      }

      window#waybar {
        background: #${colors.base00};
        color: #${colors.base05};
        border-bottom: 2px solid #${colors.base02};
      }

      #tags button,
      #dwl-tags .tag {
        color: #${colors.base05};
      }

      #tags button.occupied,
      #dwl-tags .occupied { color: #${colors.base05}; }

      #tags button.focused,
      #dwl-tags .focused {
        background: #${colors.base0D};
        color: #${colors.base00};
      }

      #tags button.urgent,
      #dwl-tags .urgent { color: #${colors.base08}; }

      #window,
      #mpris,
      #clock,
      #battery,
      #pulseaudio,
      #custom-notification,
      #tray,
      #custom-power {
        padding: 0 10px;
      }

      #mpris.paused {
        color: #${colors.base03};
        font-style: italic;
      }

      #battery.warning { color: #${colors.base0A}; }
      #battery.critical { color: #${colors.base08}; }
      #pulseaudio.muted { color: #${colors.base03}; }

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
      "gtk-layer-shell" = true;
      ipc = false;
      height = 25;
      margin = "0";

      modules-left = selectedConfig.modules-left or [ ];
      modules-center = commonModulesCenter;
      modules-right = commonModulesRight;

      mpris = {
        format = "{player_icon} {artist} - {title}";
        "format-paused" = "{status_icon} <i>{artist} - {title}</i>";
        "player-icons".default = "music_note";
        "status-icons".paused = "pause";
        "max-length" = 80;
      };

      clock.format = "{:%H:%M %d/%m}";

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        tooltip = false;
        "format-icons" = [
          "battery_full"
          "battery_good"
          "battery_half"
          "battery_low"
          "battery_caution"
          "battery_empty"
        ];
      };

      pulseaudio = {
        "disable-scroll" = true;
        format = "{icon} {volume}%";
        "format-muted" = "muted";
        "format-icons".default = [
          "volume_off"
          "volume_low"
          "volume_high"
        ];
        "on-click" = "pavucontrol";
      };

      tray = {
        "icon-size" = 21;
        spacing = 10;
      };

      "custom/notification" = {
        format = "{}";
        tooltip = false;
      };

      "custom/power" = {
        format = "power";
        tooltip = false;
        "on-click" = "wleave";
      };
    }
    // selectedConfig;
  };
}
