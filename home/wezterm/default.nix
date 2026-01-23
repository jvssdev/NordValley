{ config, ... }:
let
  inherit (config.colorScheme) palette;
  inherit (config.theme.font) monospace;
in
{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()
      config.font = wezterm.font '${builtins.head monospace}'
      config.default_cursor_style = 'SteadyBar'
      config.font_size = 15
      config.enable_wayland = true
      config.colors = {
        foreground = '#${palette.base05}',
        background = '#${palette.base00}',
        cursor_border = '#${palette.base05}',
        cursor_bg = '#${palette.base05}',
        cursor_fg = '#${palette.base00}',
        ansi = {
          '#${palette.base00}', '#${palette.base08}', '#${palette.base0B}', '#${palette.base0A}',
          '#${palette.base0D}', '#${palette.base0E}', '#${palette.base0C}', '#${palette.base05}',
        },
        brights = {
          '#${palette.base03}', '#${palette.base09}', '#${palette.base01}', '#${palette.base02}',
          '#${palette.base04}', '#${palette.base06}', '#${palette.base0F}', '#${palette.base07}',
        },
        tab_bar = {
          background = '#${palette.base00}',
          active_tab = {
            bg_color = '#${palette.base0D}',
            fg_color = '#${palette.base00}',
          },
          inactive_tab = {
            bg_color = '#${palette.base00}',
            fg_color = '#${palette.base05}',
          },
          inactive_tab_hover = {
            bg_color = '#${palette.base01}',
            fg_color = '#${palette.base05}',
          },
          new_tab = {
            bg_color = '#${palette.base00}',
            fg_color = '#${palette.base0C}',
          },
          new_tab_hover = {
            bg_color = '#${palette.base01}',
            fg_color = '#${palette.base0C}',
          },
        },
      }
      config.keys = {
         {
           key = 'h',
           mods = 'SHIFT|CTRL',
           action = wezterm.action.DisableDefaultAssignment,
         },
         {
           key = 'l',
           mods = 'SHIFT|CTRL',
           action = wezterm.action.DisableDefaultAssignment,
         },
         { key = "t", mods = "CTRL", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
         { key = "w", mods = "CTRL", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
         { key = "l", mods = "ALT", action = wezterm.action.ActivateTabRelative(1) },
         { key = "h", mods = "ALT", action = wezterm.action.ActivateTabRelative(-1) },
         { key = "v", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
         { key = "s", mods = "ALT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
         { key = "q", mods = "ALT", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
         { key = "LeftArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
         { key = "RightArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
         { key = "UpArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
         { key = "DownArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
       }
      config.hide_tab_bar_if_only_one_tab = true
      config.window_frame = {
        active_titlebar_bg = '#${palette.base00}',
        inactive_titlebar_bg = '#${palette.base00}',
      }
      return config
    '';
  };
}
