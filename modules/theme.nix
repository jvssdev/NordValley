{
  lib,
  config,
  ...
}: {
  options = {
    theme.colorScheme = lib.mkOption {
      type = lib.types.attrs;
      description = "Color scheme for the system";
      default = {
        slug = "valley";
        name = "valley";
        palette = {
          base00 = "000000";
          base01 = "151621";
          base02 = "142E39";
          base03 = "5B6D74";
          base04 = "8C999E";
          base05 = "D1D6D8";
          base06 = "D1D6D8";
          base07 = "524F67";
          base08 = "CAC4D4";
          base09 = "F6C177";
          base0A = "EBBCBA";
          base0B = "275D72";
          base0C = "9CCFD8";
          base0D = "81A1C1";
          base0E = "F6C177";
          base0F = "4D6174";
        };
      };
    };
  };

  config = {
    theme.colorScheme = {
      slug = "valley";
      name = "valley";
      palette = {
        base00 = "000000";
        base01 = "151621";
        base02 = "142E39";
        base03 = "5B6D74";
        base04 = "8C999E";
        base05 = "D1D6D8";
        base06 = "D1D6D8";
        base07 = "524F67";
        base08 = "CAC4D4";
        base09 = "F6C177";
        base0A = "EBBCBA";
        base0B = "275D72";
        base0C = "9CCFD8";
        base0D = "81A1C1";
        base0E = "F6C177";
        base0F = "4D6174";
      };
    };
  };
}
