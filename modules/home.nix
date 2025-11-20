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
  inherit (specialArgs)
    withGUI
    homeDir
    userName
    helix
    zen-browser
    helium-browser
    quickshell
    mango
    ;
in
{
  home.username = userName;
  home.homeDirectory = homeDir;
  xdg.enable = true;
  home.stateVersion = "25.05";
  home.packages = pkgs.callPackage ./packages.nix {
    inherit
      withGUI
      helix
      zen-browser
      helium-browser
      quickshell
      ;
  };
  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "/nix/var/nix/profiles/default/bin"
  ];
  home.sessionVariables = {
    EDITOR = "hx";
    TERMINAL = "ghostty";
    BROWSER = "${helium-browser.packages.${pkgs.system}.default}/bin/helium";
    DEFAULT_BROWSER = "${helium-browser.packages.${pkgs.system}.default}/bin/helium";
    XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    SHELL = "${pkgs.zsh}/bin/zsh";
  };
  imports = [
    ./programs.nix
    ../home/btop/default.nix
    ../home/fastfetch/default.nix
    ../home/fuzzel/default.nix
    ../home/ghostty/default.nix
    ../home/gtklock/default.nix
    ../home/helix/default.nix
    ../home/mako/default.nix
    ../home/mpd/default.nix
    ../home/mpv/default.nix
    ../home/quickshell/default.nix
    ../home/starship/default.nix
    ../home/theme/default.nix
    ../home/waybar/default.nix
    ../home/wpaperd/default.nix
    ../home/yazi/default.nix
    ../home/zathura/default.nix
    ../home/zed/default.nix
    ../home/zen/default.nix
    ../home/zoxide/default.nix
    ../home/zsh/default.nix
  ]
  ++ lib.optionals isRiver [
    ../home/river
  ]
  ++ lib.optionals isMango [
    ../home/mango/default.nix
    # mango.hmModules.mango
  ]
  ++ [
    (import ../home/wleave {
      inherit
        pkgs
        config
        specialArgs
        lib
        isRiver
        isMango
        ;
    })
  ];

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      # Web browser
      "x-scheme-handler/http" = [ "Helium.desktop" ];
      "x-scheme-handler/https" = [ "Helium.desktop" ];
      "x-scheme-handler/chrome" = [ "Helium.desktop" ];
      "text/html" = [ "Helium.desktop" ];
      "application/x-extension-htm" = [ "Helium.desktop" ];
      "application/x-extension-html" = [ "Helium.desktop" ];
      "application/x-extension-shtml" = [ "Helium.desktop" ];
      "application/xhtml+xml" = [ "Helium.desktop" ];
      "application/x-extension-xhtml" = [ "Helium.desktop" ];
      "application/x-extension-xht" = [ "Helium.desktop" ];

      # File manager
      "inode/directory" = [ "thunar.desktop" ];

      # Images
      "image/png" = [ "imv.desktop" ];
      "image/jpeg" = [ "imv.desktop" ];
      "image/gif" = [ "imv.desktop" ];
      "image/webp" = [ "imv.desktop" ];
      "image/svg+xml" = [ "imv.desktop" ];

      # PDF
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];

      # Video
      "video/mp4" = [ "mpv.desktop" ];
      "video/x-matroska" = [ "mpv.desktop" ];

      # Audio
      "audio/mpeg" = [ "mpv.desktop" ];

      # Text files
      "text/plain" = [ "helix.desktop" ];
      "text/txt" = [ "helix.desktop" ];
    };

    associations.added = {
      # Web browser
      "x-scheme-handler/http" = [ "Helium.desktop" ];
      "x-scheme-handler/https" = [ "Helium.desktop" ];
      "x-scheme-handler/chrome" = [ "Helium.desktop" ];
      "text/html" = [ "Helium.desktop" ];
      "application/x-extension-htm" = [ "Helium.desktop" ];
      "application/x-extension-html" = [ "Helium.desktop" ];
      "application/x-extension-shtml" = [ "Helium.desktop" ];
      "application/xhtml+xml" = [ "Helium.desktop" ];
      "application/x-extension-xhtml" = [ "Helium.desktop" ];
      "application/x-extension-xht" = [ "Helium.desktop" ];

      # File manager
      "inode/directory" = [ "thunar.desktop" ];

      # Images
      "image/png" = [ "imv.desktop" ];
      "image/jpeg" = [ "imv.desktop" ];

      # PDF
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
    };
  };

  xdg.configFile."mimeapps.list".force = true;
}
