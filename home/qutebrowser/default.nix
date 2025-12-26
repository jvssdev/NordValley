{
  config,
  pkgs,
  ...
}: let
  p = config.colorScheme.palette;
in {
  programs.qutebrowser = {
    enable = true;
    settings = {
      auto_save.session = true;
      scrolling.smooth = true;
      content = {
        autoplay = false;
        javascript.clipboard = "access-paste";
        blocking = {
          enabled = true;
          method = "adblock";
          adblock.lists = [
            "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt"
            "https://easylist.to/easylist/easylist.txt"
            "https://easylist.to/easylist/easyprivacy.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/resource-abuse.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt"
            "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt"
            "https://secure.fanboy.co.nz/fanboy-annoyance.txt"
            "https://hosts.netlify.app/Pro/adblock.txt"
            "https://raw.githubusercontent.com/pixeltris/TwitchAdSolutions/914f4ec6bd56b71e75b5da2d70646c825475c3bb/vaft/vaft-ublock-origin.js"
            "https://filters.adtidy.org/extension/ublock/filters/2.txt"
            "https://raw.githubusercontent.com/brave/adblock-lists/master/coin-miners.txt"
            "https://raw.githubusercontent.com/brave/adblock-lists/refs/heads/master/brave-lists/brave-checks.txt"
            "https://raw.githubusercontent.com/brave/adblock-lists/refs/heads/master/brave-lists/brave-twitch.txt"
            "https://raw.githubusercontent.com/brave/adblock-lists/refs/heads/master/brave-lists/yt-shorts.txt"
            "https://raw.githubusercontent.com/brave/adblock-lists/master/brave-unbreak.txt"
            "https://raw.githubusercontent.com/brave/adblock-lists/master/brave-lists/brave-social.txt"
          ];
        };
      };
      colors = {
        webpage = {preferred_color_scheme = "dark";};

        completion = {
          fg = "#${p.base05}";
          odd.bg = "#${p.base01}";
          even.bg = "#${p.base00}";
          category = {
            fg = "#${p.base0A}";
            bg = "#${p.base00}";
            border = {
              top = "#${p.base00}";
              bottom = "#${p.base00}";
            };
          };
          item.selected = {
            fg = "#${p.base05}";
            bg = "#${p.base02}";
            border = {
              top = "#${p.base02}";
              bottom = "#${p.base02}";
            };
            match.fg = "#${p.base0B}";
          };
          match.fg = "#${p.base0B}";
          scrollbar = {
            fg = "#${p.base05}";
            bg = "#${p.base00}";
          };
        };

        contextmenu = {
          disabled = {
            bg = "#${p.base01}";
            fg = "#${p.base04}";
          };
          menu = {
            bg = "#${p.base00}";
            fg = "#${p.base05}";
          };
          selected = {
            bg = "#${p.base02}";
            fg = "#${p.base05}";
          };
        };

        downloads = {
          bar.bg = "#${p.base00}";
          start = {
            fg = "#${p.base00}";
            bg = "#${p.base0D}";
          };
          stop = {
            fg = "#${p.base00}";
            bg = "#${p.base0C}";
          };
          error.fg = "#${p.base08}";
        };

        hints = {
          fg = "#${p.base00}";
          bg = "#${p.base0A}";
          match.fg = "#${p.base05}";
        };

        keyhint = {
          fg = "#${p.base05}";
          suffix.fg = "#${p.base05}";
          bg = "#${p.base00}";
        };

        messages = {
          error = {
            fg = "#${p.base00}";
            bg = "#${p.base08}";
            border = "#${p.base08}";
          };
          warning = {
            fg = "#${p.base00}";
            bg = "#${p.base0E}";
            border = "#${p.base0E}";
          };
          info = {
            fg = "#${p.base05}";
            bg = "#${p.base00}";
            border = "#${p.base00}";
          };
        };

        prompts = {
          fg = "#${p.base05}";
          border = "#${p.base00}";
          bg = "#${p.base00}";
          selected = {
            bg = "#${p.base02}";
            fg = "#${p.base05}";
          };
        };

        statusbar = {
          normal = {
            fg = "#${p.base0B}";
            bg = "#${p.base00}";
          };
          insert = {
            fg = "#${p.base00}";
            bg = "#${p.base0D}";
          };
          passthrough = {
            fg = "#${p.base00}";
            bg = "#${p.base0C}";
          };
          private = {
            fg = "#${p.base00}";
            bg = "#${p.base01}";
          };
          command = {
            fg = "#${p.base05}";
            bg = "#${p.base00}";
            private = {
              fg = "#${p.base05}";
              bg = "#${p.base00}";
            };
          };
          caret = {
            fg = "#${p.base00}";
            bg = "#${p.base0E}";
            selection = {
              fg = "#${p.base00}";
              bg = "#${p.base0D}";
            };
          };
          progress.bg = "#${p.base0D}";
          url = {
            fg = "#${p.base05}";
            error.fg = "#${p.base08}";
            hover.fg = "#${p.base05}";
            success = {
              http.fg = "#${p.base0C}";
              https.fg = "#${p.base0B}";
            };
            warn.fg = "#${p.base0E}";
          };
        };

        tabs = {
          bar.bg = "#${p.base00}";
          indicator = {
            start = "#${p.base0D}";
            stop = "#${p.base0C}";
            error = "#${p.base08}";
          };
          odd = {
            fg = "#${p.base05}";
            bg = "#${p.base01}";
          };
          even = {
            fg = "#${p.base05}";
            bg = "#${p.base00}";
          };
          pinned = {
            even = {
              bg = "#${p.base0C}";
              fg = "#${p.base07}";
            };
            odd = {
              bg = "#${p.base0B}";
              fg = "#${p.base07}";
            };
            selected = {
              even = {
                bg = "#${p.base02}";
                fg = "#${p.base05}";
              };
              odd = {
                bg = "#${p.base02}";
                fg = "#${p.base05}";
              };
            };
          };
          selected = {
            odd = {
              fg = "#${p.base05}";
              bg = "#${p.base02}";
            };
            even = {
              fg = "#${p.base05}";
              bg = "#${p.base02}";
            };
          };
        };
      };
    };
    keyBindings = {
      normal = {
        "L" = "tab-next";
        "H" = "tab-prev";

        "<Ctrl+Shift+j>" = "tab-move +";
        "<Ctrl+Shift+k>" = "tab-move -";
        "<Ctrl-t>" = "cmd-set-text --space :open -t";

        "<Ctrl-l>" = "cmd-set-text --space :open ";

        "<Ctrl-w>" = "tab-close";
        "<Alt-Left>" = "back";
        "<Alt-Right>" = "forward";
        "F12" = "devtools";
      };

      command = {
        "<Ctrl+n>" = "completion-item-focus next";
        "<Ctrl+p>" = "completion-item-focus prev";
      };
    };

    greasemonkey = [
      (
        pkgs.writeText "theme.css.js"
        # css
        ''
          // ==UserScript==
          // @name    Userstyle (theme.css)
          // @include   *
          // ==/UserScript==
          GM_addStyle(`
          :root {
            --system-theme-fg: ${p.base04};
            --system-theme-primary: ${p.base08};
            --system-theme-secondary: ${p.base09};
            --system-theme-red: ${p.base0B};
            --system-theme-orange: ${p.base0F};
            --system-theme-yellow: ${p.base0A};
            --system-theme-green: ${p.base0B};
            --system-theme-aqua: ${p.base0C};
            --system-theme-blue: ${p.base0D};
            --system-theme-purple: ${p.base0E};
            --system-theme-grey0: ${p.base03};
            --system-theme-grey1: ${p.base04};
            --system-theme-grey2: ${p.base05};
            --system-theme-statusline1: ${p.base02};
            --system-theme-statusline2: ${p.base03};
            --system-theme-statusline3: ${p.base04};
            --system-theme-bg_dim: ${p.base00};
            --system-theme-bg0: ${p.base00};
            --system-theme-bg1: ${p.base01};
            --system-theme-bg2: ${p.base02};
            --system-theme-bg3: ${p.base03};
            --system-theme-bg4: ${p.base04};
            --system-theme-bg5: ${p.base05};
            --system-theme-bg_visual: ${p.base02};
            --system-theme-bg_red: ${p.base08};
            --system-theme-bg_green: ${p.base0B};
            --system-theme-bg_blue: ${p.base0D};
            --system-theme-bg_yellow: ${p.base0A};
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
      (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/pixeltris/TwitchAdSolutions/master/vaft/vaft-ublock-origin.js";
        sha256 = "sha256-YwkfRh+PEwcjkQGCMk17uAPSzMkdOFCmkGA/OxyiMl0=";
      })
      (pkgs.writeTextFile {
        name = "ffz.js";
        text = builtins.readFile ./greasemonkey/ffz.js;
      })
    ];
  };
}
