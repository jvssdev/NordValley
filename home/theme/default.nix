{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  colorScheme = osConfig.theme.colorScheme;
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.meslo-lg
    montserrat
    # nordic
    # nordzy-icon-theme
    colloid-gtk-theme
    colloid-icon-theme
  ];

  gtk = {
    enable = true;

    theme = {
      package = pkgs.colloid-gtk-theme.override {
        colorVariants = ["dark"];
        themeVariants = ["default"];
        sizeVariants = ["compact"];
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
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      icon-theme = "Colloid-Dark";
      gtk-theme = "Colloid-Dark-Compact";
    };
  };

  qt = {
    enable = true;

    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    kvantum = {
      target = "Kvantum/kvantum.kvconfig";
      text = lib.generators.toINI {} {
        General.theme = "Colloid-Dark-Compact";
      };
    };

    qt5ct = {
      target = "qt5ct/qt5ct.conf";
      text = lib.generators.toINI {} {
        Appearance = {
          icon_theme = "Colloid-Dark-Compact";
        };
      };
    };

    qt6ct = {
      target = "qt6ct/qt6ct.conf";
      text = lib.generators.toINI {} {
        Appearance = {
          icon_theme = "Colloid-Dark-Compact";
        };
      };
    };
  };
}
