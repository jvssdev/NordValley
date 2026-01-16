{ lib, ... }:
{
  options = {
    theme.colorScheme = lib.mkOption {
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
  };
  config = {
    theme.colorScheme = {
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
}
