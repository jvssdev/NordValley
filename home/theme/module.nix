{ lib, ... }:
{
  options = {
    colorScheme = lib.mkOption {
      type = lib.types.attrs;
      description = "Color scheme configuration";
      default = { };
    };
  };
}
