{
  config,
  pkgs,
  ...
}:
let
  inherit (config.colorScheme) palette;
  inherit (config.theme.font) monospace;
  inherit (config.gtk.iconTheme) name;
in
{
  programs = {
    fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "${builtins.head monospace}:size=13";
          icon-theme = name;
          dpi-aware = "no";
          lines = 15;
          width = 40;
          prompt = ''"󰍉  "'';
          terminal = "${pkgs.ghostty}/bin/ghostty";
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
