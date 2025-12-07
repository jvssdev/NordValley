{
  pkgs,
  config,
  specialArgs,
  lib,
  isRiver ? false,
  isMango ? false,
  isNiri ? false,
  ...
}:
let
  inherit (specialArgs)
    homeDir
    userName
    helix
    zen-browser
    helium-browser
    quickshell
    mango
    niri-flake
    ;
in
{
  home.username = userName;
  home.homeDirectory = homeDir;
  xdg.enable = true;
  home.stateVersion = "25.11";
  home.packages = import ./packages.nix {
    inherit pkgs specialArgs;
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
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  imports = [
    ./programs.nix
    ../home/mako-fuzzel
    ../home/fuzzel-clipboard
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
    mango.hmModules.mango
    ../home/mango/default.nix
  ]
  ++ lib.optionals isNiri [
    ../home/niri/default.nix
  ]
  ++ [
    (import ../home/wlogout {
      inherit
        pkgs
        config
        specialArgs
        lib
        isRiver
        isMango
        isNiri
        ;
    })
  ];

  systemd.user.services.playerctld = {
    Unit = {
      Description = "playerctl daemon";
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.playerctl}/bin/playerctld daemon";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
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
      "inode/directory" = [ "thunar.desktop" ];
      "image/png" = [ "imv.desktop" ];
      "image/jpeg" = [ "imv.desktop" ];
      "image/gif" = [ "imv.desktop" ];
      "image/webp" = [ "imv.desktop" ];
      "image/svg+xml" = [ "imv.desktop" ];
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "video/mp4" = [ "mpv.desktop" ];
      "video/x-matroska" = [ "mpv.desktop" ];
      "audio/mpeg" = [ "mpv.desktop" ];
      "text/plain" = [ "helix.desktop" ];
      "text/txt" = [ "helix.desktop" ];
    };
    associations.added = {
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
      "inode/directory" = [ "thunar.desktop" ];
      "image/png" = [ "imv.desktop" ];
      "image/jpeg" = [ "imv.desktop" ];
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
    };
  };
  xdg.configFile."mimeapps.list".force = true;
}
