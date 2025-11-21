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

  wallpaperPath = "${homeDir}/Wallpapers/a6116535-4a72-453e-83c9-ea97b8597d8c.png";

  gtklockConfig = pkgs.writeText "gtklock-config" ''
    [main]
    gtk-theme=Adwaita-dark
    idle-hide=false
    start-hidden=false
  '';

  gtklockStyle = pkgs.writeText "gtklock-style.css" ''
    window {
      background-color: #${c.base00};
      background-image: url("file://${wallpaperPath}");
      background-size: cover;
      background-repeat: no-repeat;
      background-position: center;
    }

    #clock-label {
      color: #${c.base06};
      font-size: 72px;
      font-weight: bold;
      text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8);
      margin-bottom: 20px;
    }

    #body {
      padding: 20px;
      margin: 0 auto;
    }

    #input-label {
      color: #${c.base05};
      font-size: 18px;
      margin-bottom: 10px;
    }

    #input-field {
      background-color: rgba(46, 52, 64, 0.85);
      color: #${c.base05};
      border: 2px solid #${c.base0D};
      border-radius: 10px;
      padding: 15px;
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
      animation: shake 0.3s;
    }

    @keyframes shake {
      0%, 100% { transform: translateX(0); }
      25% { transform: translateX(-10px); }
      75% { transform: translateX(10px); }
    }

    #unlock-button {
      color: #${c.base00};
      background-color: #${c.base0D};
      border: none;
      border-radius: 8px;
      padding: 12px 24px;
      font-size: 16px;
      font-weight: bold;
      margin-top: 10px;
      min-width: 100px;
    }

    #unlock-button:hover {
      background-color: #${c.base0C};
      cursor: pointer;
    }

    #unlock-button:active {
      background-color: #${c.base0B};
    }

    #message-label {
      color: #${c.base08};
      font-size: 14px;
      margin-top: 10px;
    }

    #time-label {
      color: #${c.base04};
      font-size: 24px;
      margin-top: 10px;
    }
  '';
in
{
  home.packages = with pkgs; [
    gtklock
  ];

  xdg.configFile."gtklock/config.ini".source = gtklockConfig;
  xdg.configFile."gtklock/style.css".source = gtklockStyle;

  home.activation.checkGtklockWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "${wallpaperPath}" ]; then
      $DRY_RUN_CMD echo "Warning: GTKLock wallpaper not found at ${wallpaperPath}"
    else
      $DRY_RUN_CMD echo "GTKLock wallpaper found: ${wallpaperPath}"
    fi
  '';
}
