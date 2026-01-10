{
  pkgs,
  specialArgs,
  lib,
  isRiver ? false,
  isMango ? false,
  isNiri ? false,
  ...
}: let
  inherit
    (specialArgs)
    homeDir
    userName
    ;
in {
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
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  imports =
    [
      ./programs.nix
      ../home/dunst/default.nix
      ../home/dunst-fuzzel
      ../home/fuzzel-clipboard
      ../home/screenshot
      ../home/btop/default.nix
      ../home/fastfetch/default.nix
      ../home/fuzzel/default.nix
      ../home/ghostty/default.nix
      # ../home/helix/default.nix
      ../home/mpd/default.nix
      ../home/mpv/default.nix
      ../home/quickshell/default.nix
      ../home/starship/default.nix
      ../home/theme/default.nix
      ../home/wpaperd/default.nix
      ../home/yazi/default.nix
      ../home/zathura/default.nix
      ../home/zed/default.nix
      ../home/zen/default.nix
      ../home/shell/default.nix
      ../home/jujutsu/default.nix
      ../home/services/default.nix
      ../home/nvf/default.nix
      ../home/qutebrowser/default.nix
    ]
    ++ lib.optionals isRiver [
      ../home/river
    ]
    ++ lib.optionals isMango [
      ../home/mango/default.nix
    ]
    ++ lib.optionals isNiri [
      ../home/niri/default.nix
    ];

  systemd.user.services.playerctld = {
    Unit = {
      Description = "playerctl daemon";
      After = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.playerctl}/bin/playerctld daemon";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = ["zen-browser.desktop"];
      "x-scheme-handler/https" = ["zen-browser.desktop"];
      "x-scheme-handler/chrome" = ["zen-browser.desktop"];
      "text/html" = ["zen-browser.desktop"];
      "application/x-extension-htm" = ["zen-browser.desktop"];
      "application/x-extension-html" = ["zen-browser.desktop"];
      "application/x-extension-shtml" = ["zen-browser.desktop"];
      "application/xhtml+xml" = ["zen-browser.desktop"];
      "application/x-extension-xhtml" = ["zen-browser.desktop"];
      "application/x-extension-xht" = ["zen-browser.desktop"];
      "inode/directory" = ["thunar.desktop"];
      "image/png" = ["imv.desktop"];
      "image/jpeg" = ["imv.desktop"];
      "image/gif" = ["imv.desktop"];
      "image/webp" = ["imv.desktop"];
      "image/svg+xml" = ["imv.desktop"];
      "application/pdf" = ["org.pwmt.zathura.desktop"];
      "video/mp4" = ["mpv.desktop"];
      "video/x-matroska" = ["mpv.desktop"];
      "audio/mpeg" = ["mpv.desktop"];
      "text/plain" = ["nvim.desktop"];
      "text/txt" = ["nvim.desktop"];
    };
    associations.added = {
      "x-scheme-handler/http" = ["zen-browser.desktop"];
      "x-scheme-handler/https" = ["zen-browser.desktop"];
      "x-scheme-handler/chrome" = ["zen-browser.desktop"];
      "text/html" = ["zen-browser.desktop"];
      "application/x-extension-htm" = ["zen-browser.desktop"];
      "application/x-extension-html" = ["zen-browser.desktop"];
      "application/x-extension-shtml" = ["zen-browser.desktop"];
      "application/xhtml+xml" = ["zen-browser.desktop"];
      "application/x-extension-xhtml" = ["zen-browser.desktop"];
      "application/x-extension-xht" = ["zen-browser.desktop"];
      "inode/directory" = ["thunar.desktop"];
      "image/png" = ["imv.desktop"];
      "image/jpeg" = ["imv.desktop"];
      "application/pdf" = ["org.pwmt.zathura.desktop"];
    };
  };
  xdg.configFile."mimeapps.list".force = true;
}
