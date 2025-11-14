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
    BROWSER = "${zen-browser}/bin/zen";
    DEFAULT_BROWSER = "${zen-browser}/bin/zen";
    XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
    LC_ALL = "en_US.UTF-8";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    NIXOS_OZONE_WL = "1";
    SHELL = "${pkgs.zsh}/bin/zsh";
  };
  imports = [
    ./programs.nix
    ../home/btop.nix
    ../home/fastfetch.nix
    ../home/fuzzel.nix
    ../home/ghostty.nix
    ../home/gtklock.nix
    ../home/helix.nix
    ../home/mako.nix
    ../home/mpd.nix
    ../home/quickshell/quickshell.nix
    ../home/rmpc.nix
    ../home/waybar.nix
    ../home/wpaperd.nix
    ../home/yazi.nix
    ../home/zathura.nix
    ../home/zed.nix
    ../home/zen.nix
    ../home/starship.nix
    ../home/zoxide.nix
    ../home/stylix.nix
  ]
  ++ lib.optionals isRiver [
    ../home/river
  ]
  ++ lib.optionals isMango [
    ../home/mango.nix
    mango.hmModules.mango
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

  gtk = {
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
    iconTheme = {
      name = "Nordzy-dark";
      package = pkgs.nordzy-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "qt6ct";
  };
}
