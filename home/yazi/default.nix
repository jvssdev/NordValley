{
  pkgs,
  config,
  ...
}: let
  yamb-yazi = pkgs.fetchFromGitHub {
    owner = "h-hg";
    repo = "yamb.yazi";
    rev = "22af0033be18eead7b04c2768767d38ccfbaa05b";
    hash = "sha256-NMxZ8/7HQgs+BsZeH4nEglWsRH2ibAzq7hRSyrtFDTA=";
  };
  colors = config.colorScheme.palette;
in {
  programs.yazi = {
    package = pkgs.yazi;
    enable = true;
    enableZshIntegration = true;

    theme = {
      mgr = {
        size = {fg = "#${colors.base03}";};
      };

      status = {
        progress_normal = {
          fg = "#${colors.base03}";
          bg = "#${colors.base07}";
        };
      };
    };

    plugins = with pkgs.yaziPlugins; {
      inherit
        full-border
        toggle-pane
        yatline
        yatline-githead
        smart-enter
        jump-to-char
        chmod
        smart-paste
        smart-filter
        git
        lazygit
        rich-preview
        ouch
        diff
        mime-ext
        ;
      yamb = yamb-yazi;
    };

    initLua = ''
      require("full-border"):setup {
        type = ui.Border.ROUNDED,
      }

      require("git"):setup()

      require("yatline-githead"):setup()

      require("yatline"):setup({
        show_background = true,
        display_header_line = true,

        section_separator = { open = "", close = "" },
        part_separator = { open = "", close = "" },
        inverse_separator = { open = "", close = "" },

        style_a = {
          fg = "#${colors.base01}",
          bg_mode = {
            normal = "#${colors.base0D}",
            select = "#${colors.base0B}",
            un_set = "#${colors.base0D}",
          }
        },

        style_b = {
          bg = "#${colors.base07}",
          fg = "#${colors.base03}",
        },

        style_c = {
          bg = "#${colors.base01}",
          fg = "#${colors.base05}",
        },

        permissions_t_fg = "#${colors.base01}",
        permissions_r_fg = "#${colors.base01}",
        permissions_w_fg = "#${colors.base01}",
        permissions_x_fg = "#${colors.base01}",
        permissions_s_fg = "#${colors.base01}",

        status_line = {
          left = {
            section_a = {
              { type = "string", custom = false, name = "tab_mode" },
            },
            section_b = {
              { type = "coloreds", custom = false, name = "permissions" },
            },
            section_c = {
              { type = "coloreds", custom = false, name = "githead" },
            }
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
    '';

    settings = {
      mgr = {
        show_hidden = true;
        show_symlink = true;
        sort_dir_first = true;
        linemode = "size";
        ratio = [1 3 4];
      };

      preview = {
        max_width = 1920;
        max_height = 1080;
        image_filter = "lanczos3";
        image_quality = 90;
      };

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
