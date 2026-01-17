{
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  inherit (osConfig.theme) colorScheme pointerCursor font;
  inherit (font)
    sansSerif
    serif
    monospace
    emoji
    ;
  inherit (pointerCursor) name size;
in
{
  imports = [
    ./qt.nix
    ./gtk.nix
  ];

  options = {
    theme = {
      colorScheme = lib.mkOption {
        type = lib.types.attrs;
        description = "Color scheme for the system";
      };
      font = lib.mkOption {
        type = lib.types.attrs;
        description = "Font configuration";
      };
      pointerCursor = lib.mkOption {
        type = lib.types.attrs;
        description = "Pointer cursor configuration";
      };
    };

    colorScheme = lib.mkOption {
      type = lib.types.attrs;
      description = "Color scheme (legacy)";
    };
  };

  config = {
    theme = {
      inherit colorScheme font pointerCursor;
    };

    inherit colorScheme;

    home = {
      packages = with pkgs; [
        bibata-cursors
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code
        nerd-fonts.hack
        nerd-fonts.meslo-lg
        montserrat
        colloid-gtk-theme
        colloid-icon-theme
        font-awesome
        roboto
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
      ];

      pointerCursor = {
        package = pkgs.bibata-cursors;
        inherit name size;
        gtk.enable = true;
        x11.enable = true;
      };
    };

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        inherit
          sansSerif
          serif
          monospace
          emoji
          ;
      };
    };
  };
}
