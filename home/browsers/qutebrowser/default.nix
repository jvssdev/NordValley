{
  config,
  pkgs,
  ...
}:
let
  inherit (config.colorScheme) palette;
in
{
  programs.qutebrowser = {
    enable = true;

    extraConfig = ''
      config.set('colors.webpage.darkmode.enabled', False, 'file://*')
      c.tabs.padding = {
        'bottom': 5,
        'left': 9,
        'right': 9,
        'top': 5
      }
    '';
    settings = {
      colors.webpage.darkmode = {
        enabled = true;
        algorithm = "lightness-cielab";
        policy.images = "never";
      };
      auto_save.session = true;
      scrolling = {
        smooth = true;
        bar = "never";
      };
      editor.command = [
        "wezterm"
        "-e"
        "nvim"
        "{file}"
      ];
      zoom.default = 75;
      tabs = {
        indicator.width = 0;
        show = "multiple";
        title.format = "{audio}{index}:{current_title}";
        width = "7%";
      };

      input = {
        insert_mode = {
          auto_enter = true;
          auto_leave = true;
          auto_load = false;
          leave_on_load = true;
        };
      };
      content = {
        autoplay = false;
        geolocation = "ask";
        javascript.clipboard = "access-paste";
        blocking = {
          enabled = true;
          method = "both";
          adblock.lists = [
            "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
            "https://easylist.to/easylist/easylist.txt"
            "https://easylist.to/easylist/easyprivacy.txt"
            "https://easylist-downloads.adblockplus.org/easylistportuguese.txt"
            #
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances-others.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/resource-abuse.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt"
            #
            # "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt"
            # "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt"
            # "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt"
            # "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt"
            # "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt"
            # "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt"
            # "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2025.txt"
            #
            # "https://raw.githubusercontent.com/brave/adblock-lists/master/brave-lists/brave-checks.txt"
            # "https://raw.githubusercontent.com/brave/adblock-lists/master/brave-lists/brave-twitch.txt"
            "https://raw.githubusercontent.com/brave/adblock-lists/master/brave-lists/yt-shorts.txt"
            # "https://raw.githubusercontent.com/brave/adblock-lists/master/brave-unbreak.txt"
            # "https://raw.githubusercontent.com/brave/adblock-lists/master/brave-lists/brave-social.txt"
            # "https://raw.githubusercontent.com/brave/adblock-lists/master/brave-lists/filters-mirror.txt"
            "https://ttvlolpro.com/filter.txt"
          ];
        };
      };
      colors = {
        webpage = {
          preferred_color_scheme = "dark";
        };

        completion = {
          fg = "#${palette.base05}";
          odd.bg = "#${palette.base01}";
          even.bg = "#${palette.base00}";
          category = {
            fg = "#${palette.base0A}";
            bg = "#${palette.base00}";
            border = {
              top = "#${palette.base00}";
              bottom = "#${palette.base00}";
            };
          };
          item.selected = {
            fg = "#${palette.base05}";
            bg = "#${palette.base02}";
            border = {
              top = "#${palette.base02}";
              bottom = "#${palette.base02}";
            };
            match.fg = "#${palette.base0B}";
          };
          match.fg = "#${palette.base0B}";
          scrollbar = {
            fg = "#${palette.base05}";
            bg = "#${palette.base00}";
          };
        };

        contextmenu = {
          disabled = {
            bg = "#${palette.base01}";
            fg = "#${palette.base04}";
          };
          menu = {
            bg = "#${palette.base00}";
            fg = "#${palette.base05}";
          };
          selected = {
            bg = "#${palette.base02}";
            fg = "#${palette.base05}";
          };
        };

        downloads = {
          bar.bg = "#${palette.base00}";
          start = {
            fg = "#${palette.base00}";
            bg = "#${palette.base0D}";
          };
          stop = {
            fg = "#${palette.base00}";
            bg = "#${palette.base0C}";
          };
          error.fg = "#${palette.base08}";
        };

        hints = {
          fg = "#${palette.base00}";
          bg = "#${palette.base0C}";
          match.fg = "#${palette.base05}";
        };

        keyhint = {
          fg = "#${palette.base05}";
          suffix.fg = "#${palette.base05}";
          bg = "#${palette.base00}";
        };

        messages = {
          error = {
            fg = "#${palette.base00}";
            bg = "#${palette.base08}";
            border = "#${palette.base08}";
          };
          warning = {
            fg = "#${palette.base00}";
            bg = "#${palette.base0E}";
            border = "#${palette.base0E}";
          };
          info = {
            fg = "#${palette.base05}";
            bg = "#${palette.base00}";
            border = "#${palette.base00}";
          };
        };

        prompts = {
          fg = "#${palette.base05}";
          border = "#${palette.base00}";
          bg = "#${palette.base00}";
          selected = {
            bg = "#${palette.base02}";
            fg = "#${palette.base0C}";
          };
        };

        statusbar = {
          normal = {
            fg = "#${palette.base0B}";
            bg = "#${palette.base00}";
          };
          insert = {
            fg = "#${palette.base00}";
            bg = "#${palette.base0D}";
          };
          passthrough = {
            fg = "#${palette.base00}";
            bg = "#${palette.base0C}";
          };
          private = {
            fg = "#${palette.base00}";
            bg = "#${palette.base01}";
          };
          command = {
            fg = "#${palette.base05}";
            bg = "#${palette.base00}";
            private = {
              fg = "#${palette.base05}";
              bg = "#${palette.base00}";
            };
          };
          caret = {
            fg = "#${palette.base00}";
            bg = "#${palette.base0E}";
            selection = {
              fg = "#${palette.base00}";
              bg = "#${palette.base0D}";
            };
          };
          progress.bg = "#${palette.base0D}";
          url = {
            fg = "#${palette.base05}";
            error.fg = "#${palette.base08}";
            hover.fg = "#${palette.base05}";
            success = {
              http.fg = "#${palette.base0C}";
              https.fg = "#${palette.base0B}";
            };
            warn.fg = "#${palette.base0E}";
          };
        };

        tabs = {
          bar.bg = "#${palette.base00}";
          indicator = {
            start = "#${palette.base0D}";
            stop = "#${palette.base0C}";
            error = "#${palette.base08}";
          };
          odd = {
            fg = "#${palette.base05}";
            bg = "#${palette.base01}";
          };
          even = {
            fg = "#${palette.base05}";
            bg = "#${palette.base00}";
          };
          pinned = {
            even = {
              bg = "#${palette.base0C}";
              fg = "#${palette.base07}";
            };
            odd = {
              bg = "#${palette.base0B}";
              fg = "#${palette.base07}";
            };
            selected = {
              even = {
                bg = "#${palette.base02}";
                fg = "#${palette.base05}";
              };
              odd = {
                bg = "#${palette.base02}";
                fg = "#${palette.base05}";
              };
            };
          };
          selected = {
            odd = {
              fg = "#${palette.base05}";
              bg = "#${palette.base02}";
            };
            even = {
              fg = "#${palette.base05}";
              bg = "#${palette.base02}";
            };
          };
        };
      };
    };
    keyBindings = {
      normal = {
        "L" = "tab-next";
        "H" = "tab-prev";

        "<Ctrl+e>" = "edit-url";

        "<Ctrl+Shift+j>" = "tab-move +";
        "<Ctrl+Shift+k>" = "tab-move -";
        "<Ctrl-t>" = "cmd-set-text --space :open -t";

        "<Ctrl-l>" = "cmd-set-text --space :open ";

        "<Ctrl-w>" = "tab-close";
        "<Alt-Left>" = "back";
        "<Alt-Right>" = "forward";
        "F12" = "devtools";

        "M" = "hint links spawn mpv {hint-url}";
        # "N" = ''hint links spawn mpv --ytdl-format="bestvideo[height<=720]+bestaudio/best[height<=720]" {hint-url}'';
      };

      command = {
        "<Ctrl+n>" = "completion-item-focus next";
        "<Ctrl+p>" = "completion-item-focus prev";
      };
    };

    greasemonkey = [
      (pkgs.writeText "theme.css.js"
        # css
        ''
          // ==UserScript==
          // @name    Userstyle (theme.css)
          // @include   *
          // ==/UserScript==
          GM_addStyle(`
          :root {
            --system-theme-fg: ${palette.base04};
            --system-theme-primary: ${palette.base08};
            --system-theme-secondary: ${palette.base09};
            --system-theme-red: ${palette.base0B};
            --system-theme-orange: ${palette.base0F};
            --system-theme-yellow: ${palette.base0A};
            --system-theme-green: ${palette.base0B};
            --system-theme-aqua: ${palette.base0C};
            --system-theme-blue: ${palette.base0D};
            --system-theme-purple: ${palette.base0E};
            --system-theme-grey0: ${palette.base03};
            --system-theme-grey1: ${palette.base04};
            --system-theme-grey2: ${palette.base05};
            --system-theme-statusline1: ${palette.base02};
            --system-theme-statusline2: ${palette.base03};
            --system-theme-statusline3: ${palette.base04};
            --system-theme-bg_dim: ${palette.base00};
            --system-theme-bg0: ${palette.base00};
            --system-theme-bg1: ${palette.base01};
            --system-theme-bg2: ${palette.base02};
            --system-theme-bg3: ${palette.base03};
            --system-theme-bg4: ${palette.base04};
            --system-theme-bg5: ${palette.base05};
            --system-theme-bg_visual: ${palette.base02};
            --system-theme-bg_red: ${palette.base08};
            --system-theme-bg_green: ${palette.base0B};
            --system-theme-bg_blue: ${palette.base0D};
            --system-theme-bg_yellow: ${palette.base0A};
          }
          `)
        ''
      )
      (pkgs.writeTextFile {
        name = "startpage.css.js";
        text = builtins.readFile ./greasemonkey/startpage.css.js;
      })
      (pkgs.writeTextFile {
        name = "youtube_sponsorblock.js";
        text = builtins.readFile ./greasemonkey/youtube_sponsorblock.js;
      })
      # (pkgs.fetchurl {
      #   url = "https://raw.githubusercontent.com/pixeltris/TwitchAdSolutions/master/vaft/vaft-ublock-origin.js";
      #   sha256 = "sha256-YwkfRh+PEwcjkQGCMk17uAPSzMkdOFCmkGA/OxyiMl0=";
      # })
      (pkgs.writeTextFile {
        name = "ffz.js";
        text = builtins.readFile ./greasemonkey/ffz.js;
      })
      # (pkgs.fetchurl {
      #   url = "https://update.greasyfork.org/scripts/459541/YouTube%E5%8E%BB%E5%B9%BF%E5%91%8A.user.js";
      #   sha256 = "sha256-l1jSu6wD8/77wf5TT9apxvy+6B+9ywVm6pmMkhM6Ex8=";
      # })
      #
      # (pkgs.fetchurl {
      #   url = "https://raw.githubusercontent.com/Vendicated/Vencord/refs/heads/main/src/plugins/youtubeAdblock.desktop/adguard.js";
      #   sha256 = "sha256-Taik+nqVJY/0fHiALwB7U3NhspyYeE7lsR8cbz/eofE=";
      # })
    ];
  };
}
