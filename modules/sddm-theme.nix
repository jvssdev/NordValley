{
  config,
  pkgs,
  lib,
  inputs,
  nix-colors,
  ...
}:

let

  colors = nix-colors.colorSchemes.nord.palette;

  wallpaper = ../Wallpapers/nord_valley.png;

  background-derivation = pkgs.runCommandLocal "nord_valley.png" { } ''
    cp ${wallpaper} $out
  '';

  silentTheme = inputs.silentSDDM.packages.${pkgs.system}.default.override {
    extraBackgrounds = [ background-derivation ];

    theme-overrides = {
      General = {
        background = builtins.baseNameOf background-derivation;
        backgroundMode = "fill";
        primaryColor = "#${colors.base0D}";
        accentColor = "#${colors.base0D}";
        backgroundColor = "#${colors.base00}";
        textColor = "#${colors.base06}";
        selectionColor = "#${colors.base02}";
        font = "JetBrainsMono Nerd Font";
        fontSize = "12";
        blur = "true";
        blurRadius = "30";
        enable-animations = true;
      };

      Theme.CursorTheme = "Bibata-Modern-Ice";

      LoginScreen.LoginArea.PasswordInput = {
        width = 460;
        height = 60;
        font-size = 22;
        content-color = "#${colors.base05}";
        background-color = "#${colors.base00}";
        background-opacity = 0.7;
        border-size = 2;
        border-color = "#${colors.base0D}";
      };

      LoginScreen.LoginArea.LoginButton = {
        font-size = 22;
        content-color = "#${colors.base05}";
        background-color = "#${colors.base00}";
        background-opacity = 0.7;
        active-background-color = "#${colors.base0D}";
        border-size = 2;
        border-color = "#${colors.base0D}";
      };

      LoginScreen.LoginArea.Avatar = {
        shape = "circle";
        active-size = 140;
      };

      LoginScreen.MenuArea.Layout.position = "bottom-center";

      LockScreen = {
        background = builtins.baseNameOf background-derivation;
        blur = 50;
      };

      LockScreen.Clock = {
        font-size = 92;
        color = "#${colors.base06}";
      };

      LockScreen.Date = {
        font-size = 32;
        color = "#${colors.base0A}";
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

  environment.etc."sddm.conf.d/00-silent-theme.conf".text = ''
    [Theme]
    Current=Silent
  '';
}
