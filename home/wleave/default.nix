{
  pkgs,
  config,
  specialArgs,
  lib,
  isRiver ? false,
  isMango ? false,
  ...
}:
let
  inherit (specialArgs) homeDir;
  inherit (config.lib.stylix) colors;

  logoutAction =
    if isRiver then
      "riverctl exit"
    else if isMango then
      "mango quit"
    else
      "loginctl terminate-user $USER";
in
{
  xdg.configFile = {
    "wleave/layout".text = builtins.toJSON {
      buttons = [
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
        {
          label = "lock";
          action = "gtklock";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend";
          keybind = "u";
        }
        {
          label = "logout";
          action = logoutAction;
          text = "Logout";
          keybind = "e";
        }
      ];
    };

    "wleave/style.css".text = ''
      * {
        font-family: ${config.stylix.fonts.sansSerif.name};
        font-size: 20pt;
      }

      window {
        color: #${colors.base05};
        background-color: #${colors.base00};
      }

      button {
        border-radius: ${toString config.stylix.rounding.radius}px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 50%;
        border: none;
        background-color: transparent;
        margin: 5px;
        transition: box-shadow 0.1s ease-in-out, background-color 0.1s ease-in-out;
      }

      button:hover {
        background-color: #${colors.base01};
      }

      button:focus {
        background-color: #${colors.base0D};
        color: #${colors.base00};
        box-shadow: 0 0 10px #${colors.base0D};
      }

      #lock {
        background-image: url("${homeDir}/.config/wleave/icons/lock.png");
      }

      #logout {
        background-image: url("${homeDir}/.config/wleave/icons/logout.png");
      }

      #suspend {
        background-image: url("${homeDir}/.config/wleave/icons/suspend.png");
      }

      #shutdown {
        background-image: url("${homeDir}/.config/wleave/icons/shutdown.png");
      }

      #reboot {
        background-image: url("${homeDir}/.config/wleave/icons/reboot.png");
      }
    '';
  };

  home.file = {
    ".config/wleave/icons/lock.png".source = ./icons/lock.png;
    ".config/wleave/icons/logout.png".source = ./icons/logout.png;
    ".config/wleave/icons/suspend.png".source = ./icons/suspend.png;
    ".config/wleave/icons/shutdown.png".source = ./icons/shutdown.png;
    ".config/wleave/icons/reboot.png".source = ./icons/reboot.png;
    ".config/wleave/icons/hibernate.png".source = ./icons/hibernate.png;
  };
}
