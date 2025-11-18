{
  config,
  pkgs,
  lib,
  nix-colors,
  ...
}:

let

  colors = nix-colors.colorSchemes.nord.palette;

  wallpaper = ../Wallpapers/nord_valley.png;

  sddmTheme = pkgs.where-is-my-sddm-theme.overrideAttrs (old: {
    variant = "qt6";

    themeConfig = old.themeConfig // {
      General = {
        background = "${wallpaper}";
        backgroundMode = "aspect";

        backgroundColor = "#${colors.base00}";
        backgroundFill = "#${colors.base00}";
        foregroundColor = "#${colors.base06}";
        accentColor = "#${colors.base0D}";
        selectionColor = "#${colors.base0D}";
        selectionBackgroundColor = "#${colors.base02}";

        passwordInputBackground = "#${colors.base01}";
        passwordTextColor = "#${colors.base06}";
        passwordCursorColor = "#${colors.base0D}";

        usersColor = "#${colors.base06}";
        sessionsColor = "#${colors.base04}";
        clockColor = "#${colors.base06}";
        messageColor = "#${colors.base0A}";
        avatarFrameColor = "#${colors.base0D}";

        passwordInputWidth = "0.4";
        loginFormWidth = "0.35";
        passwordInputRadius = "12";
        clockFontSize = "32";
        usersFontSize = "28";
        sessionsFontSize = "20";
      };
    };
  });
in
{
  environment.systemPackages = with pkgs; [
    kdePackages.sddm
    libsForQt5.qtgraphicaleffects
    libsForQt5.qtquickcontrols2
    qt6Packages.qtgraphicaleffects
    qt6Packages.qtsvg
    bibata-cursors
  ];

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
    wayland.compositor = "kwin";

    theme = "${sddmTheme.pname}";

    extraThemes = [ sddmTheme ];

    settings = {
      Theme.CursorTheme = "Bibata-Modern-Ice";

      Wayland = {

        SessionDir = "/usr/share/wayland-sessions";
      };
    };
  };
}
