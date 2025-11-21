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
  c = config.colorScheme.palette;
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
        background-image: none;
        font-family: "Montserrat", sans-serif;
        font-size: 20pt;
      }

      window {
        background-color: rgba(${toString (lib.toInt "0x${c.base00}")} / 0.95);
        color: #${c.base05};
      }

      button {
        color: #${c.base05};
        background-color: #${c.base01};
        background-repeat: no-repeat;
        background-position: center;
        background-size: 50%;
        border-radius: 20px;
        border: none;
        margin: 5px;
        transition: box-shadow 0.1s ease-in-out, background-color 0.1s ease-in-out;
      }

      button:focus, button:active, button:hover {
        background-color: #${c.base02};
        outline-style: none;
      }

      button:focus {
        box-shadow: 0 0 10px #${c.base0D};
      }

      #lock {
        background-image: image(url("${pkgs.wleave}/share/wleave/icons/lock.svg"));
      }

      #logout {
        background-image: image(url("${pkgs.wleave}/share/wleave/icons/logout.svg"));
      }

      #suspend {
        background-image: image(url("${pkgs.wleave}/share/wleave/icons/suspend.svg"));
      }

      #hibernate {
        background-image: image(url("${pkgs.wleave}/share/wleave/icons/hibernate.svg"));
      }

      #shutdown {
        background-image: image(url("${pkgs.wleave}/share/wleave/icons/shutdown.svg"));
      }

      #reboot {
        background-image: image(url("${pkgs.wleave}/share/wleave/icons/reboot.svg"));
      }
    '';
  };
}
