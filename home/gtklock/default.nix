{
  config,
  pkgs,
  lib,
  ...
}:
let
  c = config.stylix.colors;

  gtklockConfig = pkgs.writeText "gtklock-config" ''
    [main]
    gtk-theme=Nordic
    idle-hide=true
    start-hidden=true
    modules=userinfo-module

    [userinfo]
    round-image=true
    horizontal-layout=false
    under-clock=true
  '';

  gtklockStyle = pkgs.writeText "gtklock-style.css" ''
    window {
      background-color: #${c.base00};
      background-image: url("${config.stylix.image}");
      background-size: cover;
      background-repeat: no-repeat;
      background-position: center;
    }
    #clock-label {
      color: #${c.base06};
    }
    #input-label {
      font-size: 0;
    }
    window#eDP-1 #input-field {
      margin-top: 32em;
    }
    #unlock-button {
      color: rgba(${c.base00-rgb-r}, ${c.base00-rgb-g}, ${c.base00-rgb-b}, 0.87);
    }
  '';
in
{
  home.packages = [ pkgs.gtklock ];

  xdg.configFile."gtklock/config.ini".source = gtklockConfig;
  xdg.configFile."gtklock/style.css".source = gtklockStyle;
}
