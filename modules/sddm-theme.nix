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
    };
  };
in
{
  environment.systemPackages = [ sddmTheme ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "where_is_my_sddm_theme_qt6";

    settings.Theme = {
      Current = "where_is_my_sddm_theme_qt6";
      CursorTheme = "Bibata-Modern-Ice";
      CursorSize = 24;
    };
  };
}
