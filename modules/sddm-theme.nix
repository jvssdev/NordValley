{ config, pkgs, ... }:

let
  colors = config.colorScheme.palette;

  wallpaper = ./../../Wallpapers/nord_valley.png;

  sddmTheme = pkgs.where-is-my-sddm-theme.override {
    variants = [ "qt6" ];
    themeConfig = {
      General = {
        passwordCharacter = "●";
        passwordInputWidth = "0.4";
        passwordInputBackground = "#${colors.base01}";
        passwordInputRadius = "12";
        passwordFontSize = "32";
        passwordCursorColor = "#${colors.base0A}";
        passwordTextColor = "#${colors.base06}";
        background = "${wallpaper}";
        backgroundMode = "aspect";
        backgroundFill = "#${colors.base00}";
        usersFontSize = "28";
        usersColor = "#${colors.base06}";
        sessionsFontSize = "20";
        sessionsColor = "#${colors.base04}";
        clockFontSize = "32";
        clockColor = "#${colors.base06}";
        accentColor = "#${colors.base0A}";
        backgroundColor = "#${colors.base00}";
        foregroundColor = "#${colors.base06}";
        loginFormWidth = "0.35";
        avatarFrameColor = "#${colors.base0A}";
        messageColor = "#${colors.base0D}";
        selectionColor = "#${colors.base0A}";
        selectionBackgroundColor = "#${colors.base02}";
      };
    };
  };
in
{
  environment.systemPackages = [ sddmTheme ];
  services.displayManager.sddm.settings.Theme.Current = "where_is_my_sddm_theme_qt6";
}
