{
  config,
  pkgs,
  lib,
  ...
}:
let
  palette = config.colorScheme.palette;
in
{
  services.mako = {
    enable = true;
    settings = {
      background-color = "#${palette.base00}";
      border-color = "#${palette.base01}";
      text-color = "#${palette.base04}";
      progress-color = "over ${palette.base02}";

      font = "JetBrainsMono Nerd Font 12";
      border-size = 2;
      border-radius = 8;
      padding = "10";
      margin = "8";
      default-timeout = 5000;
      ignore-timeout = 1;

      "[hidden]" = {
        format = "(and %h more)";
        text-color = "#${palette.base0D}";
        border-color = "#${palette.base0D}";
      };

      "[urgency=high]" = {
        background-color = "#${palette.base0F}";
        border-color = "#${palette.base08}";
        text-color = "#${palette.base05}";
      };

      "[urgency=critical]" = {
        border-size = 4;
        border-color = "#${palette.base08}";
        default-timeout = 0;
      };
    };
  };
}
