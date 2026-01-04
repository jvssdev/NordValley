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
      base01 = "#151621";
      base02 = "#142E39";
      base03 = "#5B6D74";
      base04 = "#8C999E";
      base05 = "#D1D6D8";
      base06 = "#D1D6D8";
      base07 = "#524F67";
      base08 = "#CAC4D4";
      base09 = "#F6C177";
      base0A = "#EBBCBA";
      # base0B = "#31748F";
      base0B = "275D72";
      base0C = "#9CCFD8";
      base0D = "#81A1C1";
      base0E = "#F6C177";
      base0F = "#4D6174";
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
