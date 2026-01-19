{
  osConfig,
  pkgs,
  ...
}:
let
  inherit (osConfig.theme) gtkTheme iconTheme;
  inherit (osConfig.theme.pointerCursor) name size;
in
{
  gtk = {
    enable = true;

    theme = {
      package = pkgs.colloid-gtk-theme.override {
        colorVariants = [ "dark" ];
        themeVariants = [ "default" ];
        sizeVariants = [ "compact" ];
        tweaks = [
          "rimless"
          "black"
        ];
      };
      name = gtkTheme;
    };

    iconTheme = {
      name = iconTheme;
      package = pkgs.fairywren;
    };

    cursorTheme = {
      package = pkgs.bibata-cursors;
      inherit name size;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = gtkTheme;
      icon-theme = iconTheme;
    };
  };
}
