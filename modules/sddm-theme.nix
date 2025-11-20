{
  config,
  pkgs,
  lib,
  silentSDDM,
  nix-colors,
  ...
}:
let
  colors = nix-colors.colorSchemes.nord.palette;
  wallpaper = ../Wallpapers/nord_valley.png;
  background-derivation = pkgs.runCommand "nord_valley.png" { } ''
    cp ${wallpaper} $out
  '';
  silentTheme = silentSDDM.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    extraBackgrounds = [ background-derivation ];
    theme-overrides = {
      "General" = {
        enable-animations = true;
      };
      "LoginScreen" = {
        background = "nord_valley.png";
        blur = 30;
      };
      "LoginScreen.LoginArea" = {
        position = "center";
        margin = -1;
      };
      "LoginScreen.LoginArea.Avatar" = {
        shape = "circle";
        active-size = 140;
        border-radius = 1;
        active-border-size = 2;
        active-border-color = "#${colors.base0D}";
      };
      "LoginScreen.LoginArea.LoginButton" = {
        font-size = 22;
        icon-size = 30;
        content-color = "#${colors.base05}";
        active-content-color = "#${colors.base06}";
        background-color = "#${colors.base00}";
        background-opacity = 0.7;
        active-background-color = "#${colors.base0D}";
        active-background-opacity = 0.7;
        border-size = 2;
        border-color = "#${colors.base0D}";
      };
      "LoginScreen.LoginArea.PasswordInput" = {
        width = 460;
        height = 60;
        font-size = 22;
        display-icon = true;
        icon-size = 30;
        content-color = "#${colors.base05}";
        background-color = "#${colors.base00}";
        background-opacity = 0.7;
        border-size = 2;
        border-color = "#${colors.base0D}";
        margin-top = 20;
      };
      "LoginScreen.LoginArea.Spinner" = {
        text = "Logging in";
        font-size = 36;
        icon-size = 72;
        color = "#${colors.base06}";
        spacing = 1;
      };
      "LoginScreen.LoginArea.Username" = {
        font-size = 40;
        color = "#${colors.base06}";
        margin = 5;
      };
      "LoginScreen.LoginArea.WarningMessage" = {
        font-size = 22;
        normal-color = "#${colors.base06}";
        warning-color = "#${colors.base0A}";
        error-color = "#${colors.base08}";
      };
      "LoginScreen.MenuArea.Buttons" = {
        size = 60;
      };
      "LoginScreen.MenuArea.Keyboard" = {
        display = false;
      };
      "LoginScreen.MenuArea.Layout" = {
        index = 2;
        position = "bottom-center";
        font-size = 20;
        icon-size = 32;
        content-color = "#${colors.base05}";
        active-content-color = "#${colors.base06}";
        background-color = "#${colors.base00}";
        background-opacity = 0.7;
        border-size = 2;
        border-color = "#${colors.base0D}";
      };
      "LoginScreen.MenuArea.Popups" = {
        max-height = 600;
        item-height = 60;
        item-spacing = 1;
        padding = 2;
        font-size = 22;
        icon-size = 24;
        content-color = "#${colors.base05}";
        active-content-color = "#${colors.base06}";
        background-color = "#${colors.base00}";
        background-opacity = 0.7;
        active-option-background-color = "#${colors.base02}";
        active-option-background-opacity = 0.7;
        border-size = 2;
        border-color = "#${colors.base0D}";
        display-scrollbar = true;
      };
      "LoginScreen.MenuArea.Power" = {
        index = 0;
        popup-width = 200;
        position = "bottom-center";
        icon-size = 32;
        content-color = "#${colors.base05}";
        active-content-color = "#${colors.base06}";
        background-color = "#${colors.base00}";
        background-opacity = 0.7;
        border-size = 2;
        border-color = "#${colors.base0D}";
      };
      "LoginScreen.MenuArea.Session" = {
        index = 1;
        position = "bottom-center";
        button-width = 300;
        popup-width = 300;
        font-size = 25;
        icon-size = 32;
        content-color = "#${colors.base05}";
        active-content-color = "#${colors.base06}";
        background-color = "#${colors.base00}";
        background-opacity = 0.7;
        active-background-opacity = 0.7;
        border-size = 2;
        border-color = "#${colors.base0D}";
      };
      "LockScreen" = {
        background = "nord_valley.png";
        blur = 50;
      };
      "LockScreen.Clock" = {
        position = "center";
        align = "center";
        format = "hh:mm:ss";
        color = "#${colors.base06}";
        font-size = 92;
      };
      "LockScreen.Date" = {
        margin-top = 1;
        format = "dd/MM/yyyy";
        locale = "pt_BR";
        color = "#${colors.base0A}";
        font-size = 32;
      };
      "LockScreen.Message" = {
        text = "Pressione qualquer tecla";
        font-size = 32;
        color = "#${colors.base0A}";
        icon-size = 44;
        paint-icon = true;
      };
      "Tooltips" = {
        enable = false;
      };
    };
  };
in
{
  environment.systemPackages = with pkgs; [
    silentTheme
    bibata-cursors
    kdePackages.qt6ct
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    kdePackages.qtwayland
    qt6.qtwayland
  ];
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "Silent";
  };
  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };
}
