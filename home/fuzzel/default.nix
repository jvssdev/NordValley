{ config, lib, ... }:
let
  c = config.colorScheme.palette;
in
{
  programs = {
    fuzzel = {
      enable = true;
      settings = {
        main = {
          font = lib.mkForce "JetBrainsMono Nerd Font:size=10";
          icon-theme = "Nordzy-dark";
          dpi-aware = "no";
        };
        colors = {
          background = "${c.base00}f0";
          text = "${c.base05}ff";
          selection = "${c.base0D}ff";
          selection-text = "${c.base00}ff";
          border = "${c.base0D}ff";
        };
        border = {
          width = 2;
          radius = 10;
        };
      };
    };
  };
}
