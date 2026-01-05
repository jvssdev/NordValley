{lib, ...}: {
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
          base02 = "445576"; #
          base03 = "385285"; #
          base04 = "60759D"; #
          base05 = "787C99"; #
          base06 = "D1D6D8";
          base07 = "8BA3D3"; #
          base08 = "E65757"; #
          base09 = "F6C177";
          base0A = "FFCD3C"; #
          base0B = "597BC0"; #
          base0C = "8196C2"; #
          base0D = "617CB3"; #
          base0E = "F6C177";
          base0F = "6282C6";
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
        base02 = "445576"; #
        base03 = "385285"; #
        base04 = "60759D"; #
        base05 = "787C99"; #
        base06 = "D1D6D8";
        base07 = "8BA3D3"; #
        base08 = "E65757"; #
        base09 = "F6C177";
        base0A = "FFCD3C"; #
        base0B = "597BC0"; #
        base0C = "8196C2"; #
        base0D = "617CB3"; #
        base0E = "F6C177";
        base0F = "6282C6";
      };
    };
  };
}
