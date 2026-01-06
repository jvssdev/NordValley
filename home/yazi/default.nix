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
      input = {
        border = {fg = "#${colors.base09}";};
        title = {};
        value = {};
        selected = {reversed = true;};
      };

      select = {
        border = {fg = "#${colors.base09}";};
        active = {fg = "#${colors.base0F}";};
        inactive = {};
      };

      tasks = {
        border = {fg = "#${colors.base09}";};
        hovered = {underline = true;};
        title = {};
      };

      which = {
        mask = {bg = "#${colors.base00}";};
        cand = {fg = "#${colors.base09}";};
        rest = {fg = "#${colors.base09}";};
        desc = {fg = "#${colors.base0F}";};
        separator = "  ";
        separator_style = {fg = "#${colors.base09}";};
      };

      help = {
        on = {fg = "#${colors.base0F}";};
        exec = {fg = "#${colors.base09}";};
        desc = {fg = "#${colors.base05}";};
        hovered = {
          bg = "#${colors.base09}";
          bold = true;
        };
        footer = {
          fg = "#${colors.base00}";
          bg = "#${colors.base09}";
        };
      };
      tabs = {
        sep_inner = {
          open = "";
          close = "";
        };
        sep_outer = {
          open = "";
          close = "";
        };
      };
      status = {
        overall = {fg = "#${colors.base01}";};
        sep_left = {
          open = "";
          close = "";
        };
        sep_right = {
          open = "";
          close = "";
        };
        separator_style = {
          fg = "#${colors.base03}";
          bg = "#${colors.base03}";
        };

        mode_normal = {
          fg = "#${colors.base00}";
          bg = "#${colors.base09}";
          bold = true;
        };

        mode_select = {
          fg = "#${colors.base00}";
          bg = "#${colors.base0B}";
          bold = true;
        };

        mode_unset = {
          fg = "#${colors.base00}";
          bg = "#${colors.base09}";
          bold = true;
        };

        progress_label = {bold = true;};
        progress_normal = {
          fg = "#${colors.base09}";
          bg = "#${colors.base00}";
        };

        progress_error = {
          fg = "red";
          bg = "#${colors.base00}";
        };

        permissions_t = {fg = "#${colors.base09}";};
        permissions_r = {fg = "#${colors.base0A}";};
        permissions_w = {fg = "#${colors.base08}";};
        permissions_x = {fg = "#${colors.base0B}";};
        permissions_s = {fg = "#${colors.base03}";};
      };
    };

    plugins = with pkgs.yaziPlugins; {
      inherit
        full-border
        toggle-pane
        yatline
        starship
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

      require("starship"):setup({
        hide_flags = false,
        flags_after_prompt = true,
        config_file = "~/.config/starship.toml",
      })
    '';

    settings = {
      mgr = {
        show_hidden = true;
        show_symlink = true;
        sort_dir_first = true;
        linemode = "size"; # or size, permissions, owner, mtime
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
