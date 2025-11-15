{ config, ... }:
let
  c = config.colorScheme.palette;
in
{
  programs.zathura = {
    enable = true;
    options = {
      default-fg = "#${c.base05}";
      default-bg = "#${c.base00}";
      completion-bg = "#${c.base02}";
      completion-fg = "#${c.base05}";
      completion-highlight-bg = "#${c.base04}";
      completion-highlight-fg = "#${c.base05}";
      completion-group-bg = "#${c.base02}";
      completion-group-fg = "#${c.base0E}";
      statusbar-fg = "#${c.base05}";
      statusbar-bg = "#${c.base02}";
      notification-bg = "#${c.base02}";
      notification-fg = "#${c.base05}";
      notification-error-bg = "#${c.base02}";
      notification-error-fg = "#${c.base08}";
      notification-warning-bg = "#${c.base02}";
      notification-warning-fg = "#${c.base09}";
      inputbar-fg = "#${c.base05}";
      inputbar-bg = "#${c.base02}";
      index-fg = "#${c.base05}";
      index-bg = "#${c.base00}";
      index-active-fg = "#${c.base05}";
      index-active-bg = "#${c.base02}";
      render-loading-bg = "#${c.base00}";
      render-loading-fg = "#${c.base05}";
      recolor-lightcolor = "#${c.base00}";
      recolor-darkcolor = "#${c.base05}";
      recolor = true;
    };
  };
}
