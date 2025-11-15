{
  config,
  lib,
  pkgs,
  ...
}:
let
  c = config.colorScheme.palette;
in
{
  services.mako = {
    enable = true;

    font = "JetBrainsMono Nerd Font 12";
    borderSize = 2;
    ignoreTimeout = true;
    defaultTimeout = 5000;
    margin = "8";

    settings = {
      default-timeout = "5000";
      format = "<b>%a ⏵</b> %s\\n%b";
      height = "110";
      width = "300";
      sort = "-time";
      layer = "overlay";
      margin = "5";
      padding = "0,5,10";
      border-size = "2";
      border-color = "#${c.base0D}";
      icons = "true";
      max-icon-size = "64";
      ignore-timeout = "true";
    };
  };
}
