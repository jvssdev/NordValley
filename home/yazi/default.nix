{
  pkgs,
  config,
  ...
}:
let
  inherit (config.colorScheme) palette;
in
{
  home.packages = with pkgs; [ trash-cli ];
  programs.yazi = {
    package = pkgs.yazi;
    enable = true;
    enableZshIntegration = true;

    theme = {
      mgr = {
        size = {
          fg = "#${palette.base03}";
        };
      };

      status = {
        progress_normal = {
          fg = "#${palette.base04}";
          bg = "#${palette.base03}";
        };
      };
    };

    plugins = with pkgs.yaziPlugins; {
      inherit
        full-border
        yatline
        yatline-githead
        chmod
        git
        restore
        ;
    };

    initLua = ''
      require("full-border"):setup {
        type = ui.Border.ROUNDED,
      }
      require("git"):setup()

      require("yatline"):setup({
        show_background = true,
        display_header_line = true,

        section_separator = { open = "", close = "" },
        part_separator = { open = "", close = "" },
        inverse_separator = { open = "", close = "" },

        header_line = {
          left = {
            section_a = {
              { type = "string", custom = false, name = "hovered_path" },
            },
            section_b = {
              { type = "coloreds", custom = false, name = "githead" },
            },
            section_c = {},
          },
          right = {
            section_a = {
              { type = "string", custom = false, name = "date", params = { "%A, %d %B %Y" } },
            },
            section_b = {
              { type = "string", custom = false, name = "date", params = { "%X" } },
            },
            section_c = {}
          }
        },

        style_a = {
          fg = "#${palette.base01}",
          bg_mode = {
            normal = "#${palette.base0D}",
            select = "#${palette.base0B}",
            un_set = "#${palette.base0D}",
          }
        },

        style_b = {
          bg = "#${palette.base03}",
          fg = "#${palette.base04}",
        },

        style_c = {
          bg = "#${palette.base01}",
          fg = "#${palette.base05}",
        },

        permissions_t_fg = "#${palette.base04}",
        permissions_r_fg = "#${palette.base04}",
        permissions_w_fg = "#${palette.base04}",
        permissions_x_fg = "#${palette.base04}",
        permissions_s_fg = "#${palette.base04}",

        status_line = {
          left = {
            section_a = {
              { type = "string", custom = false, name = "tab_mode" },
            },
            section_b = {
              { type = "coloreds", custom = false, name = "permissions" },
            },
            section_c = {}
          },
          right = {
            section_a = {
              { type = "string", custom = false, name = "cursor_percentage" },
              { type = "string", custom = false, name = "cursor_position" },
            },
            section_b = {
              { type = "string", custom = false, name = "hovered_size" },
            },
            section_c = {}
          }
        }
      })

      require("yatline-githead"):setup({
        show_branch = true,
        branch_prefix = "",
        branch_symbol = "",
        branch_borders = "",
        commit_symbol = " ",
        show_behind_ahead = true,
        behind_symbol = "⇣",
        ahead_symbol = "⇡",
        show_stashes = true,
        stashes_symbol = "✘",
        show_state = true,
        show_state_prefix = true,
        state_symbol = "󱅉",
        show_staged = true,
        staged_symbol = "+",
        show_unstaged = true,
        unstaged_symbol = "!",
        show_untracked = true,
        untracked_symbol = "?",
        prefix_color = "#${palette.base04}",
        branch_color = "#${palette.base04}",
        commit_color = "#${palette.base0E}",
        stashes_color = "#${palette.base0B}",
        state_color = "#${palette.base07}",
        staged_color = "#${palette.base0B}",
        unstaged_color = "#${palette.base0A}",
        untracked_color = "#${palette.base09}",
        ahead_color = "#${palette.base0B}",
        behind_color = "#${palette.base0A}",
      })
    '';
    keymap = {
      mgr.prepend_keymap = [
        {
          on = [
            "g"
            "s"
          ];
          run = "plugin git";
          desc = "Show git status";
        }
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
        }
        {
          run = "plugin restore";
          on = "u";
          desc = "Restore last deleted files/folders";
        }
      ];
    };
    settings = {
      mgr = {
        show_hidden = true;
        show_symlink = true;
        sort_dir_first = true;
        linemode = "size";
        ratio = [
          1
          3
          4
        ];
      };

      preview = {
        max_width = 1920;
        max_height = 1080;
        image_filter = "lanczos3";
        image_quality = 90;
      };

      plugin.prepend_fetchers = [
        {
          id = "git";
          name = "*";
          run = "git";
        }
        {
          id = "git";
          name = "*/";
          run = "git";
        }
      ];
      opener = {
        play = [
          {
            run = "mpv \"$@\"";
            orphan = true;
            for = "unix";
          }
        ];
        image = [
          {
            run = "imv \"$@\"";
            orphan = true;
            for = "unix";
          }
        ];
        pdf = [
          {
            run = "zathura \"$@\"";
            orphan = true;
            for = "unix";
          }
        ];
        edit = [
          {
            run = "$EDITOR \"$@\"";
            block = true;
            for = "unix";
          }
        ];
      };

      open = {
        rules = [
          {
            mime = "image/*";
            use = "image";
          }
          {
            mime = "application/pdf";
            use = "pdf";
          }
          {
            mime = "video/*";
            use = "play";
          }
          {
            mime = "audio/*";
            use = "play";
          }
          {
            mime = "text/*";
            use = "edit";
          }
          {
            mime = "application/json";
            use = "edit";
          }
          {
            mime = "application/javascript";
            use = "edit";
          }
          {
            mime = "application/x-shellscript";
            use = "edit";
          }
          {
            mime = "*";
            use = "edit";
          }
        ];
      };
    };
  };
}
