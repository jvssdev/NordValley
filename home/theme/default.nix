{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
let
  nix-colors = specialArgs.nix-colors;
in
{
  colorScheme = nix-colors.colorSchemes.nord;

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };

  home.file.".icons/default".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Ice";

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.meslo-lg
    montserrat
  ];

  # GTK Theme
  gtk = {
    enable = true;
    theme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-icon-theme;
    };
    iconTheme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-gtk-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Qt Theme
  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "qt5ct";
  };
}
