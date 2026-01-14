{ config, ... }:
let
  inherit (config.colorScheme) palette;
in
{
  programs.zathura = {
    enable = true;
    options = {
      default-fg = "#${palette.base05}";
      default-bg = "#${palette.base00}";
      completion-bg = "#${palette.base02}";
      completion-fg = "#${palette.base05}";
      completion-highlight-bg = "#${palette.base04}";
      completion-highlight-fg = "#${palette.base05}";
      completion-group-bg = "#${palette.base02}";
      completion-group-fg = "#${palette.base0E}";
      statusbar-fg = "#${palette.base05}";
      statusbar-bg = "#${palette.base02}";
      notification-bg = "#${palette.base02}";
      notification-fg = "#${palette.base05}";
      notification-error-bg = "#${palette.base02}";
      notification-error-fg = "#${palette.base08}";
      notification-warning-bg = "#${palette.base02}";
      notification-warning-fg = "#${palette.base09}";
      inputbar-fg = "#${palette.base05}";
      inputbar-bg = "#${palette.base02}";
      index-fg = "#${palette.base05}";
      index-bg = "#${palette.base00}";
      index-active-fg = "#${palette.base05}";
      index-active-bg = "#${palette.base02}";
      render-loading-bg = "#${palette.base00}";
      render-loading-fg = "#${palette.base05}";
      recolor-lightcolor = "#${palette.base00}";
      recolor-darkcolor = "#${palette.base05}";
      recolor = true;
    };
  };
}
