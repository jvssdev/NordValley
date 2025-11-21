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
        action = logoutAction;
        text = "Logout";
        keybind = "e";
      }
    ];
    style = ''
      * {
        font-family: "Montserrat", sans-serif;
        font-size: 20pt;
      }
      window {
        color: #${c.base05};
        background-color: #${c.base00};
      }
      button {
        border-radius: 10px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 50%;
        border: none;
        background-color: transparent;
        margin: 5px;
        transition: box-shadow 0.1s ease-in-out, background-color 0.1s ease-in-out;
      }
      button:hover {
        background-color: #${c.base01};
      }
      button:focus {
        background-color: #${c.base0D};
        color: #${c.base00};
        box-shadow: 0 0 10px #${c.base0D};
      }
      #lock {
        background-image: image(url("${./icons/lock.png}"));
      }
      #logout {
        background-image: image(url("${./icons/logout.png}"));
      }
      #suspend {
        background-image: image(url("${./icons/suspend.png}"));
      }
      #shutdown {
        background-image: image(url("${./icons/shutdown.png}"));
      }
      #reboot {
        background-image: image(url("${./icons/reboot.png}"));
      }
    '';
  };
}
