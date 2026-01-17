{
  config,
  pkgs,
  ...
}:
let
  inherit (config.theme.pointerCursor) name size;
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
      name = "Colloid-Dark-Compact";
    };
    iconTheme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-icon-theme;
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      inherit name size;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      icon-theme = "Colloid-Dark";
      gtk-theme = "Colloid-Dark-Compact";
    };
  };
}
