{
  config,
  pkgs,
  lib,
  specialArgs,
  ...
}:
let
  inherit (specialArgs)
    homeDir
    ;
  c = config.colorScheme.palette;

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
      background-image: url("${homeDir}/Wallpapers/a6116535-4a72-453e-83c9-ea97b8597d8c.png");
      background-size: cover;
      background-repeat: no-repeat;
      background-position: center;
    }

    #clock-label {
      color: #${c.base06};
      font-size: 4em;
      font-weight: bold;
    }

    #input-label {
      font-size: 0;
    }

    window#eDP-1 #input-field {
      margin-top: 32em;
    }

    #unlock-button {
      color: #${c.base05};
      background-color: #${c.base02};
      border-radius: 8px;
      padding: 8px 16px;
      opacity: 0.9;
    }

    #unlock-button:hover {
      background-color: #${c.base03};
    }
  '';
in
{
  home.packages = [ pkgs.gtklock ];

  xdg.configFile."gtklock/config.ini".source = gtklockConfig;
  xdg.configFile."gtklock/style.css".source = gtklockStyle;
}
