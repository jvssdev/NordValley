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
      window {
        color: #${c.base05};
        background-color: #${c.base00};
        font-family: "Montserrat", sans-serif;
        font-size: 16pt;
      }
      button {
        border-radius: 10px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 20%;
        border-radius: 36px; 
        background-color: #${c.base01};
        margin: 10px;
        box-shadow: 0 0 10px 2px transparent;
        transition: all 0.3s ease-in;
        animation: gradient_f 20s ease-in infinite;
      }
      button:hover {
        background-color: #${c.base02};
        box-shadow: 0 0 10px 3px rgba(136, 192, 208, 0.4);
        background-size: 50%;
        color: #${c.base0D};
        transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
      }
      button:focus {
        box-shadow: none;
        background-size : 20%;
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
