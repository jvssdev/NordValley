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

  sddmTheme = pkgs.where-is-my-sddm-theme.override {
    variants = [ "qt6" ];
    themeConfig.General = {
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

      passwordCharacter = "●";
      showUserRealNameByDefault = "true";

      font = "JetBrainsMono Nerd Font";
      fontSize = "12";
    };
  };
in
{
  environment.systemPackages = with pkgs; [
    sddmTheme
    bibata-cursors
    kdePackages.qtsvg
    kdePackages.qtdeclarative
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols2
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "where_is_my_sddm_theme_qt6";

    settings = {
      Theme = {
        Current = "where_is_my_sddm_theme_qt6";
        CursorTheme = "Bibata-Modern-Ice";
        CursorSize = 24;
        ThemeDir = "${sddmTheme}/share/sddm/themes";

        FacesDir = "${sddmTheme}/share/sddm/faces";
      };

      General = {
        InputMethod = "";

        DisplayServer = "wayland";
        GreeterEnvironment = "QT_WAYLAND_FORCE_DPI=physical,XCURSOR_THEME=Bibata-Modern-Ice,XCURSOR_SIZE=24";
      };

      Wayland = {
        SessionDir = "/run/current-system/sw/share/wayland-sessions";
        CompositorCommand = "kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1";
      };

      X11 = {
        SessionDir = "/run/current-system/sw/share/xsessions";
      };
    };
  };

  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };
}
