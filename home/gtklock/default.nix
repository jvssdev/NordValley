{
  config,
  pkgs,
  lib,
  specialArgs,
  ...
}:
let
  inherit (specialArgs) homeDir;
  c = config.colorScheme.palette;

  gtklockConfig = pkgs.writeText "gtklock-config" ''
    [main]
    gtk-theme=${config.gtk.theme.name}
    idle-hide=false
    start-hidden=false
  '';

  gtklockStyle = pkgs.writeText "gtklock-style.css" ''
    * {
      font-family: "JetBrainsMono Nerd Font", monospace;
    }

    window {
      background-color: #${c.base00};
      background-image: url("${../../Wallpapers/a6116535-4a72-453e-83c9-ea97b8597d8c.png}");
      background-size: cover;
      background-repeat: no-repeat;
      background-position: center;
    }

    #clock-label {
      color: #${c.base06};
      font-size: 72px;
      font-weight: bold;
      text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8);
      margin-top: 0;
      margin-bottom: 20px;
      margin-left: 0;
      margin-right: 0;
    }

    #body {
      padding: 20px;
    }

    #input-label {
      color: #${c.base05};
      font-size: 18px;
      margin-top: 0;
      margin-bottom: 10px;
      margin-left: 0;
      margin-right: 0;
    }

    #input-field {
      background-color: rgba(46, 52, 64, 0.85);
      color: #${c.base05};
      border: 2px solid #${c.base0D};
      border-radius: 10px;
      padding-top: 15px;
      padding-bottom: 15px;
      padding-left: 15px;
      padding-right: 15px;
      font-size: 16px;
      min-width: 300px;
      caret-color: #${c.base05};
    }

    #input-field:focus {
      border-color: #${c.base0C};
      background-color: rgba(46, 52, 64, 0.95);
      outline: none;
    }

    #input-field.error {
      border-color: #${c.base08};
    }

    #unlock-button {
      color: #${c.base00};
      background-color: #${c.base0D};
      border: none;
      border-radius: 8px;
      padding-top: 12px;
      padding-bottom: 12px;
      padding-left: 24px;
      padding-right: 24px;
      font-size: 16px;
      font-weight: bold;
      margin-top: 10px;
      margin-bottom: 0;
      margin-left: 0;
      margin-right: 0;
      min-width: 100px;
    }

    #unlock-button:hover {
      background-color: #${c.base0C};
    }

    #unlock-button:active {
      background-color: #${c.base0B};
    }

    #message-label {
      color: #${c.base08};
      font-size: 14px;
      margin-top: 10px;
      margin-bottom: 0;
      margin-left: 0;
      margin-right: 0;
    }

    #time-label {
      color: #${c.base04};
      font-size: 24px;
      margin-top: 10px;
      margin-bottom: 0;
      margin-left: 0;
      margin-right: 0;
    }
  '';
in
{
  home.packages = with pkgs; [
    gtklock
    config.gtk.theme.package
    config.gtk.iconTheme.package
  ];

  xdg.configFile."gtklock/config.ini".source = gtklockConfig;
  xdg.configFile."gtklock/style.css".source = gtklockStyle;

  home.sessionVariables = {
    GTK_THEME = config.gtk.theme.name;
  };
}
