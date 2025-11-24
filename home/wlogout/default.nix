{ config, pkgs, ... }:
let
  c = config.colorScheme.palette;
in

{
  xdg.configFile."wlogout/icons".source = ./icons;
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "${pkgs.gtklock}/bin/gtklock";
        text = "Lock";
        keybind = "l";
      }
      # {
      #   label = "hibernate";
      #   action = "systemctl hibernate";
      #   text = "Hibernate";
      #   keybind = "h";
      # }
      {
        label = "logout";
        action = "loginctl kill-session $XDG_SESSION_ID";
        text = "Exit";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
    style = ''
      window {
        font-family: monospace;
        font-size: 14pt;
        color: #${c.base05}; /* text */
        background-color: rgba(30, 30, 46, 0.5);
      }

      button {
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        border: none;
        background-color: rgba(30, 30, 46, 0);
        margin: 5px;
        transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
      }

      button:hover {
        background-color: rgba(49, 50, 68, 0.1);
      }

      button:focus {
        background-color: #${c.base0F};
        color: #${c.base00};
      }
      #lock {
        background-image: image(url("icons/lock.png"));
      }
      #lock:focus {
        background-image: image(url("icons/lock-hover.png"));
      }

      #logout {
        background-image: image(url("icons/logout.png"));
      }
      #logout:focus {
        background-image: image(url("icons/logout-hover.png"));
      }

      #suspend {
        background-image: image(url("icons/sleep.png"));
      }
      #suspend:focus {
        background-image: image(url("icons/sleep-hover.png"));
      }

      #shutdown {
        background-image: image(url("icons/power.png"));
      }
      #shutdown:focus {
        background-image: image(url("icons/power-hover.png"));
      }

      #reboot {
        background-image: image(url("icons/restart.png"));
      }
      #reboot:focus {
        background-image: image(url("icons/restart-hover.png"));
      }
    '';
  };
}
