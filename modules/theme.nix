{ lib, ... }:
{
  options = {
    theme = {
      colorScheme = lib.mkOption {
        type = lib.types.attrs;
        description = "Color scheme for the system";
        default = {
          slug = "tsuki";
          name = "Tsuki";
          palette = {
            base00 = "000000";
            base01 = "060914";
            base02 = "0C0F1A";
            base03 = "1D202B";
            base04 = "656771";
            base05 = "A7A9B5";
            base06 = "BDBFCB";
            base07 = "C6DFEC";
            base08 = "C65E53";
            base09 = "C97E4F";
            base0A = "E1C084";
            base0B = "0EA2AB";
            base0C = "67BBB9";
            base0D = "597BC0";
            base0E = "8666B2";
            base0F = "BB5D7D";
          };
        };
      };

      font = {
        sansSerif = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Sans-serif font family";
          default = [
            "Roboto"
            "Noto Sans CJK JP"
          ];
        };

        serif = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Serif font family";
          default = [
            "Roboto"
            "Noto Serif CJK JP"
          ];
        };

        monospace = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Monospace font family";
          default = [
            "JetBrainsMono Nerd Font"
            "Noto Sans Mono CJK JP"
          ];
        };

        emoji = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Emoji font family";
          default = [ "Noto Color Emoji" ];
        };
      };

      pointerCursor = {
        name = lib.mkOption {
          type = lib.types.str;
          description = "Cursor theme name";
          default = "Bibata-Modern-Ice";
        };

        size = lib.mkOption {
          type = lib.types.int;
          description = "Cursor size";
          default = 24;
        };
      };
    };
  };

  config = {
    theme = {
      colorScheme = {
        slug = "tsuki";
        name = "Tsuki";
        palette = {
          base00 = "000000";
          base01 = "060914";
          base02 = "0C0F1A";
          base03 = "1D202B";
          base04 = "656771";
          base05 = "A7A9B5";
          base06 = "BDBFCB";
          base07 = "C6DFEC";
          base08 = "C65E53";
          base09 = "C97E4F";
          base0A = "E1C084";
          base0B = "0EA2AB";
          base0C = "67BBB9";
          base0D = "597BC0";
          base0E = "8666B2";
          base0F = "BB5D7D";
        };
      };

      font = {
        sansSerif = [
          "Roboto"
          "Noto Sans CJK JP"
        ];
        serif = [
          "Roboto"
          "Noto Serif CJK JP"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "Noto Sans Mono CJK JP"
        ];
        emoji = [ "Noto Color Emoji" ];
      };

      pointerCursor = {
        name = "Bibata-Modern-Ice";
        size = 24;
      };
    };
  };
}
