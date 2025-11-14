{ lib, ... }:
{
  programs = {
    # Required so Stylix can inject its theme into fuzzel's config
    fuzzel = {
      enable = true;
      settings = {
        main = {
          font = lib.mkForce "JetBrainsMono Nerd Font:size 10";
          icon-theme = "Nordzy-dark";
          dpi-aware = "no";
        };
        border = {
          selection-radius = 10;
        };
      };
    };
  };
}
