{
  config,
  pkgs,
  lib,
  nix-colors,
  inputs,
  ...
}:

let
  colors = nix-colors.colorSchemes.nord.palette;
  silentTheme = inputs.silentSDDM.packages.${pkgs.system}.default;
in
{
  environment.systemPackages = with pkgs; [
    silentTheme
    bibata-cursors
    kdePackages.qt6ct
    kdePackages.kvantum
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "Silent";

    settings = {
      General = {
        DisplayServer = "wayland";
        GreeterEnvironment = "QT_WAYLAND_FORCE_DPI=physical,XCURSOR_THEME=Bibata-Modern-Ice,XCURSOR_SIZE=24,QT_QPA_PLATFORMTHEME=qt6ct";

        background = "${../Wallpapers/nord_valley.png}";
        backgroundMode = "fill";
        primaryColor = "#${colors.base0D}";
        accentColor = "#${colors.base0D}";
        backgroundColor = "#${colors.base00}";
        textColor = "#${colors.base06}";
        selectionColor = "#${colors.base02}";
        font = "JetBrainsMono Nerd Font";
        fontSize = "12";
        blur = "true";
        blurRadius = "20";
        showUserAvatar = "true";
        showRealName = "true";
        clock24h = "false";
      };

      Theme = {
        Current = "Silent";
        CursorTheme = "Bibata-Modern-Ice";
        CursorSize = "24";
      };
    };
  };

  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };
}
