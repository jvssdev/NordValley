{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "biome"
      "nix"
      "nord"
    ];

    userKeymaps = [
      # {
      #    "context": "Editor && vim_mode == insert && !menu",
      #    "bindings": {
      #       "j k": "vim::SwitchToNormalMode"
      #    }
      # },
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
      theme = {
        mode = "system";
        light = "Nord Dark";
        dark = "Nord Dark";
      };
      cursor_blink = false;
      autosave = "on_focus_change";
      use_autoclose = true;
      use_auto_surround = true;
      formatter = {
        language_server.name = "biome";
      };
      features = {
        copilot = false;
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
      buffer_font_family = "JetBrains Mono Nerd Font";
      ui_font_family = "JetBrains Mono Nerd Font";
      ui_font_size = 15;
      ui_font_weight = 400;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
    };
  };
}
