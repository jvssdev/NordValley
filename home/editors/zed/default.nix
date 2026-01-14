{ config, ... }:
let
  inherit (config.colorScheme) palette;
in
{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "biome"
      "nix"
      "symbols"
    ];
    userKeymaps = [
      {
        "context" = "Workspace";
        "bindings" = {
          "space e" = "workspace::ToggleLeftDock";
          "alt-h" = "workspace::ToggleBottomDock";
          "space b d" = [
            "pane::CloseActiveItem"
            {
              "close_pinned" = false;
            }
          ];
          "space s f" = "file_finder::Toggle";
          "space s g" = "pane::DeploySearch";
        };
      }
      {
        "context" = "ProjectSearchBar";
        "bindings" = {
          "space s g" = "search::FocusSearch";
        };
      }
      {
        "context" = "ProjectSearchBar";
        "bindings" = {
          "space s g" = "search::FocusSearch";
        };
      }
      {
        "context" = "Pane";
        "bindings" = {
          "space s g" = "project_search::ToggleFocus";
        };
      }
      {
        "context" = "Editor";
        "bindings" = {
          "gc" = [
            "editor::ToggleComments"
            {
              "advance_downwards" = false;
            }
          ];
        };
      }
    ];
    userSettings = {
      vim_mode = true;
      theme = "Base16";

      icon_theme = "Symbols Icon Theme";
      diagnostics.inline.enabled = true;

      vim = {
        toggle_relative_line_numbers = true;
        use_system_clipboard = "always";
      };

      cursor_blink = false;
      autosave = "on_focus_change";
      use_autoclose = true;
      use_auto_surround = true;
      formatter = {
        language_server.name = "biome";
      };
      features = {
        edit_prediction_provider = "none";
      };
      terminal = {
        alternate_scroll = "off";
        blinking = "terminal_controlled";
        copy_on_select = false;
        dock = "bottom";
        default_width = 640;
        default_height = 320;
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
            activate_script = "default";
          };
        };
        env = {
          TERM = "ghostty";
        };
        line_height = "comfortable";
        button = true;
        shell = {
          program = "zsh";
        };
        toolbar = {
          breadcrumbs = false;
          title = true;
        };
        working_directory = "current_project_directory";
        scrollbar = {
          show = null;
        };
      };
      hide_mouse = "on_typing_and_movement";
      code_actions_on_format = {
        "source.fixAll.biome" = true;
        "source.organizeImports.biome" = true;
      };

      inlay_hints.enabled = true;

      indent_guides.coloring = "fixed";
      buffer_font_weight = 300;
      buffer_line_height = "comfortable";
      current_line_highlight = "all";
      selection_highlight = true;
      buffer_font_family = "JetBrainsMono Nerd Font";
      ui_font_family = "JetBrainsMono Nerd Font";
      ui_font_size = 15;
      ui_font_weight = 400;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
    };
  };

  xdg.configFile."zed/themes/base16.json".text = builtins.toJSON {
    name = "Base16";
    author = "João";
    themes = [
      {
        name = "Base16";
        appearance = "dark";
        style = {
          border = "#${palette.base03}ff";
          "border.variant" = "#${palette.base01}ff";
          "border.focused" = null;
          "border.selected" = null;
          "border.transparent" = null;
          "border.disabled" = null;
          "elevated_surface.background" = "#${palette.base01}";
          "surface.background" = "#${palette.base00}";
          background = "#${palette.base00}";
          "element.background" = "#${palette.base00}";
          "element.hover" = "#${palette.base01}ff";
          "element.active" = "#${palette.base02}ff";
          "element.selected" = "#${palette.base02}ff";
          "element.disabled" = "#${palette.base03}d3";
          "ghost_element.background" = "#${palette.base00}";
          "ghost_element.hover" = "#${palette.base01}ff";
          "ghost_element.active" = "#${palette.base02}ff";
          "ghost_element.selected" = "#${palette.base02}ff";
          "ghost_element.disabled" = "#${palette.base03}d3";
          "drop_target.background" = "#${palette.base03}d3";
          text = "#${palette.base05}";
          "text.muted" = "#${palette.base04}";
          "text.placeholder" = "#${palette.base03}";
          "text.disabled" = "#${palette.base03}";
          "text.accent" = "#${palette.base0D}";
          icon = "#${palette.base05}";
          "icon.muted" = "#${palette.base03}";
          "icon.disabled" = "#${palette.base03}";
          "icon.placeholder" = "#${palette.base03}";
          "icon.accent" = "#${palette.base0D}";
          "status_bar.background" = "#${palette.base00}";
          "title_bar.background" = "#${palette.base00}";
          "title_bar.inactive_background" = "#${palette.base00}";
          "toolbar.background" = "#${palette.base00}";
          "tab_bar.background" = "#${palette.base00}";
          "tab.inactive_background" = "#${palette.base00}";
          "tab.active_background" = "#${palette.base01}";
          "search.match_background" = "#${palette.base02}";
          "panel.background" = "#${palette.base00}";
          "panel.focused_border" = null;
          "pane.focused_border" = "#${palette.base00}";
          "scrollbar.thumb.background" = "#${palette.base01}d3";
          "scrollbar.thumb.hover_background" = "#${palette.base02}";
          "scrollbar.thumb.border" = "#00000000";
          "scrollbar.track.background" = "#00000000";
          "scrollbar.track.border" = "#00000000";
          "editor.foreground" = "#${palette.base05}";
          "editor.background" = "#${palette.base00}";
          "editor.gutter.background" = "#${palette.base00}";
          "editor.subheader.background" = "#${palette.base00}";
          "editor.active_line.background" = "#${palette.base01}";
          "editor.highlighted_line.background" = "#${palette.base02}";
          "editor.line_number" = "#${palette.base03}";
          "editor.active_line_number" = "#${palette.base05}";
          "editor.invisible" = "#${palette.base03}";
          "editor.wrap_guide" = "#${palette.base03}";
          "editor.active_wrap_guide" = "#${palette.base03}d3";
          "editor.document_highlight.read_background" = "#${palette.base02}d3";
          "editor.document_highlight.write_background" = "#${palette.base03}d3";
          "link_text.hover" = "#${palette.base0D}";

          conflict = "#${palette.base0B}";
          "conflict.background" = "#${palette.base0B}d3";
          "conflict.border" = "#${palette.base03}";

          created = "#${palette.base0B}";
          "created.background" = "#${palette.base0B}d3";
          "created.border" = "#${palette.base03}";

          deleted = "#${palette.base08}";
          "deleted.background" = "#${palette.base08}d3";
          "deleted.border" = "#${palette.base03}";

          error = "#${palette.base08}";
          "error.background" = "#${palette.base08}d3";
          "error.border" = "#${palette.base03}";

          hidden = "#${palette.base03}";
          "hidden.background" = "#${palette.base00}";
          "hidden.border" = "#${palette.base03}";

          hint = "#${palette.base0D}";
          "hint.background" = "#${palette.base0D}d3";
          "hint.border" = "#${palette.base03}";

          ignored = "#${palette.base03}";
          "ignored.background" = "#${palette.base00}";
          "ignored.border" = "#${palette.base03}";

          info = "#${palette.base0D}";
          "info.background" = "#${palette.base0D}d3";
          "info.border" = "#${palette.base03}";

          modified = "#${palette.base0A}";
          "modified.background" = "#${palette.base0A}d3";
          "modified.border" = "#${palette.base03}";

          predictive = "#${palette.base0E}";
          "predictive.background" = "#${palette.base0E}d3";
          "predictive.border" = "#${palette.base03}";

          renamed = "#${palette.base0D}";
          "renamed.background" = "#${palette.base0D}d3";
          "renamed.border" = "#${palette.base03}";

          success = "#${palette.base0B}";
          "success.background" = "#${palette.base0B}d3";
          "success.border" = "#${palette.base03}";

          unreachable = "#${palette.base03}";
          "unreachable.background" = "#${palette.base00}";
          "unreachable.border" = "#${palette.base03}";

          warning = "#${palette.base0A}";
          "warning.background" = "#${palette.base0A}d3";
          "warning.border" = "#${palette.base03}";

          players = [
            {
              cursor = "#${palette.base0D}";
              background = "#${palette.base0D}20";
              selection = "#${palette.base0D}30";
            }
            {
              cursor = "#${palette.base0E}";
              background = "#${palette.base0E}20";
              selection = "#${palette.base0E}30";
            }
            {
              cursor = "#${palette.base0E}";
              background = "#${palette.base0E}20";
              selection = "#${palette.base0E}30";
            }
            {
              cursor = "#${palette.base09}";
              background = "#${palette.base09}20";
              selection = "#${palette.base09}30";
            }
            {
              cursor = "#${palette.base0B}";
              background = "#${palette.base0B}20";
              selection = "#${palette.base0B}30";
            }
            {
              cursor = "#${palette.base08}";
              background = "#${palette.base08}20";
              selection = "#${palette.base08}30";
            }
            {
              cursor = "#${palette.base0A}";
              background = "#${palette.base0A}20";
              selection = "#${palette.base0A}30";
            }
            {
              cursor = "#${palette.base0B}";
              background = "#${palette.base0B}20";
              selection = "#${palette.base0B}30";
            }
          ];

          syntax = {
            attribute = {
              color = "#${palette.base0D}";
              font_style = null;
              font_weight = null;
            };

            boolean = {
              color = "#${palette.base0E}";
              font_style = null;
              font_weight = null;
            };

            comment = {
              color = "#${palette.base03}";
              font_style = "italic";
              font_weight = null;
            };
            "comment.doc" = {
              color = "#${palette.base03}";
              font_style = "italic";
              font_weight = 700;
            };

            constant = {
              color = "#${palette.base0E}";
              font_style = null;
              font_weight = null;
            };

            constructor = {
              color = "#${palette.base0B}";
              font_style = null;
              font_weight = null;
            };

            directive = {
              color = "#${palette.base0E}";
              font_style = null;
              font_weight = null;
            };

            escape = {
              color = "#${palette.base0D}";
              font_style = "italic";
              font_weight = null;
            };

            function = {
              color = "#${palette.base0D}";
              font_style = "italic";
              font_weight = null;
            };
            "function.decorator" = {
              color = "#${palette.base0D}";
              font_style = "italic";
              font_weight = null;
            };
            "function.magic" = {
              color = "#${palette.base0D}";
              font_style = "italic";
              font_weight = null;
            };

            keyword = {
              color = "#${palette.base0E}";
              font_style = "italic";
              font_weight = null;
            };

            label = {
              color = "#${palette.base05}";
              font_style = null;
              font_weight = null;
            };

            local = {
              color = "#${palette.base08}";
              font_style = null;
              font_weight = null;
            };

            markup = {
              color = "#${palette.base09}";
              font_style = null;
              font_weight = null;
            };

            meta = {
              color = "#${palette.base05}";
              font_style = null;
              font_weight = null;
            };

            modifier = {
              color = "#${palette.base05}";
              font_style = null;
              font_weight = null;
            };

            namespace = {
              color = "#${palette.base08}";
              font_style = null;
              font_weight = null;
            };

            number = {
              color = "#${palette.base0A}";
              font_style = null;
              font_weight = null;
            };

            operator = {
              color = "#${palette.base0E}";
              font_style = null;
              font_weight = null;
            };

            parameter = {
              color = "#${palette.base05}";
              font_style = null;
              font_weight = null;
            };

            punctuation = {
              color = "#${palette.base05}";
              font_style = null;
              font_weight = null;
            };

            regexp = {
              color = "#${palette.base0C}";
              font_style = null;
              font_weight = null;
            };

            self = {
              color = "#${palette.base05}";
              font_style = null;
              font_weight = 700;
            };

            string = {
              color = "#${palette.base0B}";
              font_style = null;
              font_weight = null;
            };

            strong = {
              color = "#${palette.base0D}";
              font_style = null;
              font_weight = 700;
            };

            support = {
              color = "#${palette.base0E}";
              font_style = null;
              font_weight = null;
            };

            symbol = {
              color = "#${palette.base0A}";
              font_style = null;
              font_weight = null;
            };

            tag = {
              color = "#${palette.base0D}";
              font_style = null;
              font_weight = null;
            };

            text = {
              color = "#${palette.base05}";
              font_style = null;
              font_weight = null;
            };

            type = {
              color = "#${palette.base0B}";
              font_style = null;
              font_weight = null;
            };

            variable = {
              color = "#${palette.base05}";
              font_style = null;
              font_weight = null;
            };
          };

          "terminal.background" = "#${palette.base00}ff";
          "terminal.foreground" = "#${palette.base05}ff";
          "terminal.ansi.black" = "#${palette.base00}ff";
          "terminal.ansi.red" = "#${palette.base08}ff";
          "terminal.ansi.green" = "#${palette.base0B}ff";
          "terminal.ansi.yellow" = "#${palette.base0A}ff";
          "terminal.ansi.blue" = "#${palette.base0D}ff";
          "terminal.ansi.magenta" = "#${palette.base0E}ff";
          "terminal.ansi.cyan" = "#${palette.base0C}ff";
          "terminal.ansi.white" = "#${palette.base05}ff";
          "terminal.ansi.bright_black" = "#${palette.base03}ff";
          "terminal.ansi.bright_red" = "#${palette.base08}ff";
          "terminal.ansi.bright_green" = "#${palette.base0B}ff";
          "terminal.ansi.bright_yellow" = "#${palette.base0A}ff";
          "terminal.ansi.bright_blue" = "#${palette.base0D}ff";
          "terminal.ansi.bright_magenta" = "#${palette.base0E}ff";
          "terminal.ansi.bright_cyan" = "#${palette.base0C}ff";
          "terminal.ansi.bright_white" = "#${palette.base05}ff";
        };
      }
    ];
  };
}
