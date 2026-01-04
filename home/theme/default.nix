{
  pkgs,
  # specialArgs,
  lib,
  ...
}:
# let
# nix-colors = specialArgs.nix-colors;
# in
{
  # colorScheme = nix-colors.colorSchemes.grayscale-dark;

  colorScheme = {
    slug = "valley";
    name = "valley";
    palette = {
      base00 = "#000000";
      base01 = "#181825";
      base02 = "#313244";
      base03 = "#45475a";
      base04 = "#585b70";
      base05 = "#cdd6f4";
      base06 = "#f5e0dc";
      base07 = "#b4befe";
      base08 = "#f38ba8";
      base09 = "#fab387";
      base0A = "#f9e2af";
      base0B = "#a6e3a1";
      base0C = "#94e2d5";
      base0D = "#89b4fa";
      base0E = "#cba6f7";
      base0F = "#f2cdcd";
    };
  };

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
    nordic
    nordzy-icon-theme
  ];

  gtk = {
    enable = true;

    theme = {
      name = "Nordic-darker";
      package = pkgs.nordic;
    };

    iconTheme = {
      name = "Nordzy-dark";
      package = pkgs.nordzy-icon-theme;
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
      icon-theme = "Nordzy-dark";
      gtk-theme = "Nordic-darker";
    };
  };

  qt = {
    enable = true;

    platformTheme = {
      name = "kde";
    };

    style = {
      name = "kvantum";
    };
  };

  xdg.configFile = {
    kvantum = {
      target = "Kvantum/kvantum.kvconfig";
      text = lib.generators.toINI {} {
        General.theme = "Nordic-darker";
      };
    };

    qt5ct = {
      target = "qt5ct/qt5ct.conf";
      text = lib.generators.toINI {} {
        Appearance = {
          icon_theme = "Nordzy-dark";
        };
      };
    };

    qt6ct = {
      target = "qt6ct/qt6ct.conf";
      text = lib.generators.toINI {} {
        Appearance = {
          icon_theme = "Nordzy-dark";
        };
      };
    };
  };
}
