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
      [[ "$(makoctl mode)" = "do-not-disturb" ]] && makoctl mode -r do-not-disturb || makoctl mode -s do-not-disturb
    fi
  '';
  commonModulesCenter = [
    "clock"
  ];
  commonModulesRight = [
    "cpu"
    "memory"
    "custom/notification"
    "battery"
    "pulseaudio"
    "bluetooth"
    "network"
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
    ];
    "dwl/tags" = {
      # "num-tags" = 9;
      # "hide-vacant" = true;
      # expand = false;
      # "disable-click" = true;
    };
  };
  niriConfig = {
    modules-left = [ "niri/workspaces" ];
    "niri/workspaces" = {
      "format" = "{icon}";
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
        border: none;
        border-radius: 0;
      }
      window#waybar {
        background: #${colors.base00};
        color: #${colors.base05};
        border-bottom: 2px solid #${colors.base02};
      }

      #tags button {
        padding: 0 8px;
        margin: 0 4px;
        border-radius: 0px;
        color: #${colors.base05};
        font-weight: normal;
      }

      #tags button:not(.occupied):not(.focused):not(.urgent) {
        font-size: 0;
        min-width: 0;
        padding: 0;
        margin: -50px;
        color: transparent;
        background-color: transparent;
        box-shadow: none;
        outline: none;
        transition: none;
      }

      #tags button.occupied {
        background-color: #${colors.base02};
        color: #${colors.base05};
      }

      #tags button.focused {
        background-color: #${colors.base0D};
        color: #${colors.base00};
        font-weight: bold;
      }

      #tags button.urgent {
        background-color: #${colors.base08};
        color: #${colors.base00};
      }

      #tags button:hover {
        background-color: #${colors.base03};
      }

      #tags button.occupied,
      #tags button.focused,
      #tags button.urgent {
        transition: all 0.2s ease-in-out;
      }

      #dwl-tags button,
      #dwl-tags > * {
        padding: 0 8px;
        margin: 0 4px;
        border-radius: 0px;
        color: #${colors.base05};
        font-weight: normal;
      }

      #dwl-tags button:not(.occupied):not(.focused):not(.urgent),
      #dwl-tags > *:not(.occupied):not(.focused):not(.urgent) {
        font-size: 0;
        min-width: 0;
        padding: 0;
        margin: -50px;
        color: transparent;
        background-color: transparent;
        box-shadow: none;
        outline: none;
        transition: none;
      }

      #dwl-tags button.occupied,
      #dwl-tags > *.occupied {
        background-color: #${colors.base02};
        color: #${colors.base05};
      }

      #dwl-tags button.focused,
      #dwl-tags > *.focused {
        background-color: #${colors.base0D};
        color: #${colors.base00};
        font-weight: bold;
      }

      #dwl-tags button.urgent,
      #dwl-tags > *.urgent {
        background-color: #${colors.base08};
        color: #${colors.base00};
      }

      #dwl-tags button:hover,
      #dwl-tags > *:hover {
        background-color: #${colors.base03};
      }

      #dwl-tags button.occupied,
      #dwl-tags button.focused,
      #dwl-tags button.urgent,
      #dwl-tags > *.occupied,
      #dwl-tags > *.focused,
      #dwl-tags > *.urgent {
        transition: all 0.2s ease-in-out;
      }

      #window, #mpris, #clock, #cpu, #memory, #battery, #pulseaudio,
      #bluetooth, #network, #custom-quickshell-notification, #tray, #custom-power {
        padding: 0 10px;
      }
      #mpris.paused { color: #${colors.base03}; font-style: italic; }
      #battery.warning { color: #${colors.base0A}; }
      #battery.critical { color: #${colors.base08}; }
      #pulseaudio.muted { color: #${colors.base03}; }
      #bluetooth.connected { color: #${colors.base0F}; }
      #custom-quickshell-notification {
        color: #${colors.base05};
      }     
      #custom-notification.dnd-on {
        color: #${colors.base08};
        font-weight: bold;
      }
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
      "gtk-layer-shell" = true;
      ipc = false;
      height = 25;
      margin = "0";
      modules-left = selectedConfig.modules-left or [ ];
      modules-center = commonModulesCenter;
      modules-right = commonModulesRight;
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
        "tooltip-format" = "ssid : {essid}\naddr : {ipaddr}/{cidr}\ngate : {gwaddr}\ndev : {ifname}";
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
