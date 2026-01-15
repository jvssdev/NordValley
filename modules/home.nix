{
  pkgs,
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
    ;
in
{
  home = {
    username = userName;
    homeDirectory = homeDir;
    stateVersion = "25.11";
    sessionPath = [
      "$HOME/.nix-profile/bin"
      "/nix/var/nix/profiles/default/bin"
    ];
    sessionVariables = {
      SHELL = "${pkgs.zsh}/bin/zsh";
    };
  };

  imports = [
    ./programs.nix
    ../home/dunst/default.nix
    ../home/dunst-fuzzel
    ../home/fuzzel-clipboard
    ../home/btop/default.nix
    ../home/fastfetch/default.nix
    ../home/fuzzel/default.nix
    ../home/ghostty/default.nix
    ../home/mpd/default.nix
    ../home/quickshell/default.nix
    ../home/starship/default.nix
    ../home/theme/default.nix
    ../home/yazi/default.nix
    ../home/zathura/default.nix
    ../home/shell/default.nix
    ../home/jujutsu/default.nix
    ../home/services/default.nix
    ../home/editors/default.nix
    ../home/browsers/default.nix
  ]
  ++ lib.optionals isRiver [
    ../home/river
    ../home/screenshot
  ]
  ++ lib.optionals isMango [
    ../home/mango/default.nix
    ../home/screenshot
  ]
  ++ lib.optionals isNiri [
    ../home/niri/default.nix
  ];

  xdg = {
    enable = true;

    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = [ "zen-browser.desktop" ];
        "x-scheme-handler/https" = [ "zen-browser.desktop" ];
        "x-scheme-handler/chrome" = [ "zen-browser.desktop" ];
        "text/html" = [ "zen-browser.desktop" ];
        "application/x-extension-htm" = [ "zen-browser.desktop" ];
        "application/x-extension-html" = [ "zen-browser.desktop" ];
        "application/x-extension-shtml" = [ "zen-browser.desktop" ];
        "application/xhtml+xml" = [ "zen-browser.desktop" ];
        "application/x-extension-xhtml" = [ "zen-browser.desktop" ];
        "application/x-extension-xht" = [ "zen-browser.desktop" ];
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
        "text/plain" = [ "nvim.desktop" ];
        "text/txt" = [ "nvim.desktop" ];
      };
      associations.added = {
        "x-scheme-handler/http" = [ "zen-browser.desktop" ];
        "x-scheme-handler/https" = [ "zen-browser.desktop" ];
        "x-scheme-handler/chrome" = [ "zen-browser.desktop" ];
        "text/html" = [ "zen-browser.desktop" ];
        "application/x-extension-htm" = [ "zen-browser.desktop" ];
        "application/x-extension-html" = [ "zen-browser.desktop" ];
        "application/x-extension-shtml" = [ "zen-browser.desktop" ];
        "application/xhtml+xml" = [ "zen-browser.desktop" ];
        "application/x-extension-xhtml" = [ "zen-browser.desktop" ];
        "application/x-extension-xht" = [ "zen-browser.desktop" ];
        "inode/directory" = [ "thunar.desktop" ];
        "image/png" = [ "imv.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      };
    };
    configFile."mimeapps.list".force = true;
  };
}
