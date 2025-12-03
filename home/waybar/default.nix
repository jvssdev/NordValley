{
  pkgs,
  config,
  isRiver ? false,
  isMango ? false,
  isNiri ? false,
  ...
}:

let
  colors = config.colorScheme.palette;

  makoDndScript = pkgs.writeShellScript "mako-dnd" ''
    #!/usr/bin/env bash
    if [[ "$1" = "show" ]]; then
      if [[ "$(makoctl mode)" = "do-not-disturb" ]]; then
        echo '{"text":"","tooltip":"Do not disturb is on"}'
      else
        echo '{"text":"","tooltip":"Do not disturb is off"}'
      fi
    elif [[ "$1" = "toggle" ]]; then
      if [[ "$(makoctl mode)" = "do-not-disturb" ]]; then
        makoctl mode -r do-not-disturb
      else
        makoctl mode -s do-not-disturb
      fi
    fi
  '';

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
      num-tags = 9;
      hide-vacant = true;
      expand = false;
      disable-click = true;
    };
    "dwl/window" = {
      format = "{app_id} | {title}";
      max-length = 50;
      rewrite." \\| " = "";
    };
  };

  niriConfig = {
    modules-left = [ "niri/workspaces" ];
    "niri/workspaces" = {
      format = "{icon}";
    };
  };

  selectedConfig =
    if isRiver then
      riverConfig
    else if isMango then
      mangoConfig
    else if isNiri then
      niriConfig
    else
      riverConfig;

in
{
  programs.waybar = {
    enable = true;

    style = ''
      * {
        font-family: JetBrainsMono Nerd Font, Montserrat;
        font-size: 13px;
        margin: 0;
        padding: 0;
        border-radius: 0;
      }

      window#waybar {
        background: #${colors.base00};
        color: #${colors.base05};
        border-bottom: 2px solid #${colors.base02};
      }

      #tags button,
      #dwl-tags .tag,
      #dwl-tags .tag button {
        padding: 0 8px;
        margin: 0 4px;
      }

      #tags button.focused,
      #dwl-tags .tag.focused {
        background: #${colors.base0D};
        color: #${colors.base00};
      }

      #dwl-tags .tag.occupied {
        background: #${colors.base01};
        color: #${colors.base05};
      }

      #dwl-tags .tag.urgent {
        background: #${colors.base08};
        color: #${colors.base00};
      }

      #window,
      #mpris,
      #clock,
      #cpu,
      #memory,
      #battery,
      #pulseaudio,
      #bluetooth,
      #network,
      #custom-notification,
      #tray,
      #custom-power {
        padding: 0 10px;
      }

      #mpris.paused {
        font-style: italic;
      }

      #battery.warning { color: #${colors.base0A}; }
      #battery.critical { color: #${colors.base08}; }

      #pulseaudio.muted { color: #${colors.base03}; }

      #bluetooth.connected { color: #${colors.base0F}; }

      #custom-power:hover {
        background: #${colors.base08};
        color: #${colors.base07};
      }
    '';

    settings.mainBar = {
      layer = "top";
      position = "top";
      exclusive = true;
      passthrough = false;
      height = 25;
      margin = "0";

      modules-left = selectedConfig.modules-left or [ ];
      modules-center = [ "clock" ];
      modules-right = [
        "cpu"
        "memory"
        "custom/notification"
        "tray"
        "battery"
        "pulseaudio"
        "bluetooth"
        "network"
        "custom/power"
      ];

      clock.format = "{:%H:%M %d/%m}";
      cpu.format = "{usage}% ";
      memory.format = "{}% ";

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        tooltip = false;
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
        "format-muted" = "muted";
        "format-icons".default = [
          ""
          ""
          ""
        ];
        "on-click" = "pavucontrol";
      };

      bluetooth = {
        format = "{icon}";
        "format-connected" = "bluetooth {num_connections}";
        format-icons = {
          connected = "bluetooth";
          on = "";
          off = "";
          disabled = "";
          default = "";
        };
        tooltip-format = "{status} {num_connections}";
        "on-click" = "blueman-manager";
        "on-click-right" = "rfkill toggle bluetooth";
      };

      network = {
        "format-wifi" = "";
        "format-ethernet" = "󰲝";
        "format-disconnected" = "";
        "tooltip-format" = "ssid: {essid}\naddr: {ipaddr}/{cidr}\ngate: {gwaddr}\ndev: {ifname}";
        "format-linked" = "󰲝";
      };

      tray = {
        "icon-size" = 21;
        spacing = 10;
      };

      "custom/notification" = {
        format = "{}";
        exec = "${makoDndScript} show";
        return-type = "json";
        interval = 30;
        signal = 8;
        on-click = "${makoDndScript} toggle && pkill -RTMIN+8 waybar";
        tooltip = true;
        escape = true;
      };

      "custom/power" = {
        format = "⏻";
        tooltip = false;
        "on-click" = "wlogout";
      };

    }
    // selectedConfig;
  };
}
