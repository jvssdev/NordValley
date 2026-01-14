{
  config,
  lib,
  ...
}:
let
  inherit (config.colorScheme) palette;
in
{
  programs = {
    fuzzel = {
      enable = true;
      settings = {
        main = {
          font = lib.mkForce "JetBrainsMono Nerd Font:size=14";
          icon-theme = "Colloid-Dark";
          dpi-aware = "no";
          lines = 15;
          width = 40;
          prompt = ''"󰍉  "'';
        };
        dmenu = {
          lines = 25;
          width = 70;
        };
        colors = {
          background = "${palette.base00}f0";
          text = "${palette.base05}ff";
          selection = "${palette.base0D}ff";
          selection-text = "${palette.base00}ff";
          border = "${palette.base0D}ff";
        };
        border = {
          width = 2;
          radius = 10;
        };
      };
    };
  };
}
