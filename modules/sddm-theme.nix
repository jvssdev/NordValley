{
  pkgs,
  silentSDDM,
  config,
  isRiver ? false,
  isMango ? false,
  isNiri ? false,
  ...
}:
let
  inherit (config.theme.colorScheme) palette;
  wallpaper = ../Wallpapers/nord_valley.png;

  background-derivation = pkgs.runCommand "bg.jpg" { } ''
    cp ${wallpaper} $out
  '';

  silentTheme = silentSDDM.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    extraBackgrounds = [ background-derivation ];
    theme-overrides = {
      "General" = {
        enable-animations = true;
      };
      "LoginScreen" = {
        background = "${background-derivation.name}";
        blur = 0;
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
        active-border-color = "#${palette.base0D}";
      };
      "LoginScreen.LoginArea.LoginButton" = {
        font-size = 22;
        icon-size = 30;
        content-color = "#${palette.base05}";
        active-content-color = "#${palette.base06}";
        background-color = "#${palette.base00}";
        background-opacity = 0.7;
        active-background-color = "#${palette.base0D}";
        active-background-opacity = 0.7;
        border-size = 2;
        border-color = "#${palette.base0D}";
      };
      "LoginScreen.LoginArea.PasswordInput" = {
        width = 460;
        height = 60;
        font-size = 22;
        display-icon = true;
        icon-size = 30;
        content-color = "#${palette.base05}";
        background-color = "#${palette.base00}";
        background-opacity = 0.7;
        border-size = 2;
        border-color = "#${palette.base0D}";
        margin-top = 20;
      };
      "LoginScreen.LoginArea.Spinner" = {
        text = "Logging in";
        font-size = 36;
        icon-size = 72;
        color = "#${palette.base06}";
        spacing = 1;
      };
      "LoginScreen.LoginArea.Username" = {
        font-size = 40;
        color = "#${palette.base00}";
        margin = 5;
      };
      "LoginScreen.LoginArea.WarningMessage" = {
        font-size = 22;
        normal-color = "#${palette.base06}";
        warning-color = "#${palette.base0A}";
        error-color = "#${palette.base08}";
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
        content-color = "#${palette.base05}";
        active-content-color = "#${palette.base06}";
        background-color = "#${palette.base00}";
        background-opacity = 0.7;
        border-size = 2;
        border-color = "#${palette.base0D}";
      };
      "LoginScreen.MenuArea.Popups" = {
        max-height = 600;
        item-height = 60;
        item-spacing = 1;
        padding = 2;
        font-size = 22;
        icon-size = 24;
        content-color = "#${palette.base05}";
        active-content-color = "#${palette.base06}";
        background-color = "#${palette.base00}";
        background-opacity = 0.7;
        active-option-background-color = "#${palette.base02}";
        active-option-background-opacity = 0.7;
        border-size = 2;
        border-color = "#${palette.base0D}";
        display-scrollbar = true;
      };
      "LoginScreen.MenuArea.Power" = {
        index = 0;
        popup-width = 200;
        position = "bottom-center";
        icon-size = 32;
        content-color = "#${palette.base05}";
        active-content-color = "#${palette.base06}";
        background-color = "#${palette.base00}";
        background-opacity = 0.7;
        border-size = 2;
        border-color = "#${palette.base0D}";
      };
      "LoginScreen.MenuArea.Session" = {
        index = 1;
        position = "bottom-center";
        button-width = 300;
        popup-width = 300;
        font-size = 25;
        icon-size = 32;
        content-color = "#${palette.base05}";
        active-content-color = "#${palette.base06}";
        background-color = "#${palette.base00}";
        background-opacity = 0.7;
        active-background-opacity = 0.7;
        border-size = 2;
        border-color = "#${palette.base0D}";
      };
      "LockScreen" = {
        background = "${background-derivation.name}";
        blur = 50;
      };
      "LockScreen.Clock" = {
        position = "center";
        align = "center";
        format = "hh:mm:ss";
        color = "#${palette.base01}";
        font-size = 92;
      };
      "LockScreen.Date" = {
        margin-top = 1;
        format = "dd/MM/yyyy";
        locale = "pt_BR";
        color = "#${palette.base0D}";
        font-size = 32;
      };
      "LockScreen.Message" = {
        text = "Press any key";
        font-size = 32;
        color = "#${palette.base0D}";
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
  environment = {
    systemPackages = with pkgs; [
      silentTheme
      silentTheme.test
      bibata-cursors
      kdePackages.qt6ct
      libsForQt5.qtstyleplugin-kvantum
      kdePackages.qtstyleplugin-kvantum
      kdePackages.qtwayland
      qt6.qtwayland
    ];

    etc."sddm.conf.d/cursor.conf".text = ''
      [Theme]
      CursorTheme=Bibata-Modern-Ice
      CursorSize=24
    '';

    sessionVariables = {
      XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = "24";
      QT_QPA_PLATFORMTHEME = "qt6ct";
    };
  };

  qt.enable = true;

  systemd.tmpfiles.rules = [
    "L+ /var/lib/sddm/.icons/default - - - - ${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Ice"
    "d /var/lib/sddm/.icons 0755 sddm sddm"
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;

    theme = silentTheme.pname;

    extraPackages = silentTheme.propagatedBuildInputs;

    settings = {
      General = {
        GreeterEnvironment =
          if isMango || isRiver then
            "QML2_IMPORT_PATH=${silentTheme}/share/sddm/themes/${silentTheme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard,XCURSOR_THEME=Bibata-Modern-Ice,XCURSOR_SIZE=24,XCURSOR_PATH=/usr/share/icons:${pkgs.bibata-cursors}/share/icons,WLR_NO_HARDWARE_CURSORS=1"
          else if isNiri then
            "QML2_IMPORT_PATH=${silentTheme}/share/sddm/themes/${silentTheme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard,XCURSOR_THEME=Bibata-Modern-Ice,XCURSOR_SIZE=24,XCURSOR_PATH=/usr/share/icons:${pkgs.bibata-cursors}/share/icons"
          else
            "QML2_IMPORT_PATH=${silentTheme}/share/sddm/themes/${silentTheme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard,XCURSOR_THEME=Bibata-Modern-Ice,XCURSOR_SIZE=24,XCURSOR_PATH=/usr/share/icons:${pkgs.bibata-cursors}/share/icons";

        InputMethod = "qtvirtualkeyboard";
      };
      Theme = {
        CursorTheme = "Bibata-Modern-Ice";
        CursorSize = 24;
      };
    };
  };
}
