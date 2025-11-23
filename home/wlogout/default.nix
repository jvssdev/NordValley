{
  pkgs,
  config,
  specialArgs,
  lib,
  ...
}:
let
  inherit (specialArgs) homeDir userName;
  c = config.colorScheme.palette;
in
{
  programs.wlogout = {
    enable = true;
    layout = [
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
        action = "loginctl kill-session $XDG_SESSION_ID";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
    ];
    style = ''
      window {
          font-family: JetBrainsMono Nerd Font;
          font-size: 16pt;
          color: #${c.base05}; /* text */
          background-color: #${c.base00}33;
      }
      button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 20%;
          background-color: transparent;
          animation: gradient_f 20s ease-in infinite;
          transition: all 0.3s ease-in;
          box-shadow: 0 0 10px 2px transparent;
          border-radius: 36px;
          margin: 10px;
      }
      button:focus {
          box-shadow: none;
          background-size : 20%;
      }
      button:hover {
          background-size: 50%;
          box-shadow: 0 0 10px 3px rgba(0,0,0,.4);
          background-color: #${c.base0D};
          color: transparent;
          transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
      }
      #shutdown {
          background-image: image(url("${./icons/power.png}"));
      }
      #shutdown:hover {
        background-image: image(url("${./icons/power-hover.png}"));
      }
      #logout {
          background-image: image(url("${./icons/logout.png}"));
      }
      #logout:hover {
        background-image: image(url("${./icons/logout-hover.png}"));
      }
      #reboot {
          background-image: image(url("${./icons/restart.png}"));
      }
      #reboot:hover {
        background-image: image(url("${./icons/restart-hover.png}"));
      }
      #lock {
          background-image: image(url("${./icons/lock.png}"));
      }
      #lock:hover {
        background-image: image(url("${./icons/lock-hover.png}"));
      }
      #hibernate {
          background-image: image(url("${./icons/hibernate.png}"));
      }
      #hibernate:hover {
        background-image: image(url("${./icons/hibernate-hover.png}"));
      }
      #suspend {
          background-image: image(url("${./icons/suspend.png}"));
      }
      #suspend:hover {
        background-image: image(url("${./icons/suspend-hover.png}"));
      }
    '';
  };
}
