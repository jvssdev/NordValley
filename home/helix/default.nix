{ config, pkgs, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "nord_transparent";

      editor = {
        line-number = "relative";
        bufferline = "multiple";
        gutters = [
          "line-numbers"
          "spacer"
          "diff"
        ];
        scrolloff = 10;
        color-modes = true;
        true-color = true;
        undercurl = true;
        soft-wrap.enable = true;
        rulers = [ 120 ];
        clipboard-provider = "wayland";
        end-of-line-diagnostics = "hint";
        file-picker.hidden = false;
        path-completion = true;
        auto-format = true;
        trim-trailing-whitespace = false;
        trim-final-newlines = false;

        indent-guides = {
          render = true;
          trim-trailing-whitespace = true;
          character = "▏";
        };

        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        inline-diagnostics.cursor-line = "hint";

        statusline = {
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
          left = [
            "mode"
            "file-name"
            "version-control"
            "spinner"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-type"
          ];
          separator = "-";
        };

        lsp = {
          goto-reference-include-declaration = false;
          display-inlay-hints = false;
          display-progress-messages = true;
        };

        whitespace = {
          render = "all";
          characters = {
            space = "·";
            nbsp = "⍽";
            nnbsp = "␣";
            tab = "→";
            newline = " ";
            tabpad = "␣";
          };
        };

        auto-pairs = {
          "(" = ")";
          "{" = "}";
          "[" = "]";
          "\"" = "\"";
          "`" = "`";
          "<" = ">";
        };
      };

      keys.normal = {
        H = ":buffer-previous";
        L = ":buffer-next";
        G = "goto_file_end";
        V = [
          "extend_line_below"
          "select_mode"
        ];
        y = "yank_to_clipboard";
        Y = "yank";

        space = {
          q = ":quit";
          e = [
            ":sh rm -f /tmp/yazi-path"
            ":insert-output yazi %{buffer_name} --chooser-file=/tmp/yazi-path"
            ":open %sh{cat /tmp/yazi-path}"
            ":redraw"
          ];
          o = ":lsp-workspace-command open-preview";

          b.d = ":buffer-close";
        };
      };

      languages = {
        language = [
          {
            name = "bash";
            formatter.command = "shfmt";
            auto-format = true;
          }
          {
            name = "markdown";
            formatter = {
              command = "prettierd";
              args = [
                "--parser"
                "markdown"
              ];
            };
            language-servers = [
              "markdown-oxide"
              "mpls"
            ];
            auto-format = true;
          }
          {
            name = "javascript";
            indent = {
              tab-width = 4;
              unit = " ";
            };
            formatter = {
              command = "biome";
              args = [
                "--parser"
                "javascript"
              ];
            };
            language-servers = [ "typescript-language-server" ];
            auto-format = true;
          }
          {
            name = "typescript";
            indent = {
              tab-width = 4;
              unit = " ";
            };
            formatter = {
              command = "biome";
              args = [
                "--parser"
                "typescript"
              ];
            };
            language-servers = [ "typescript-language-server" ];
            auto-format = true;
          }
          {
            name = "tsx";
            indent = {
              tab-width = 4;
              unit = " ";
            };
            formatter = {
              command = "biome";
              args = [
                "--parser"
                "typescript"
              ];
            };
            language-servers = [ "typescript-language-server" ];
            auto-format = true;
          }
          {
            name = "go";
            language-servers = [ "gopls" ];
            formatter.command = "gofmt";
            auto-format = true;
          }
          {
            name = "zig";
            language-servers = [ "zls" ];
            formatter.command = "";
            auto-format = true;
          }
          {
            name = "json";
            file-types = [
              "json"
              "jsonc"
            ];
            formatter = {
              command = "prettierd";
              args = [
                "prettierd"
                "--parser"
                "json"
              ];
            };
            auto-format = true;
          }
          {
            name = "html";
            formatter = {
              command = "prettierd";
              args = [
                "--parser"
                "html"
              ];
            };
            auto-format = true;
          }
          {
            name = "css";
            formatter = {
              command = "biome";
              args = [
                "--parser"
                "css"
              ];
            };
            auto-format = true;
          }
          {
            name = "yaml";
            formatter = {
              command = "prettierd";
              args = [
                "--parser"
                "yaml"
              ];
            };
            auto-format = true;
          }
          {
            name = "nix";
            formatter.command = "nixfmt";
            language-servers = [ "nixd" ];
            auto-format = true;
          }
          # {
          #   name = "toml";
          #   formatter = { command = "taplo"; args = [ "format" "-" ]; };
          #   auto-format = true;
          # }
        ];

        language-server = {
          mpls = {
            command = "mpls";
            args = [
              "--dark-mode"
              "--enable-emoji"
            ];
          };
          # taplo.config.root_dir = [ ".git" "*.toml" ];
        };
      };
    };

    themes = {
      nord_transparent = {
        inherits = "nord";
        "ui.background" = {
          bg = "transparent";
        };
      };
    };
  };

  home.packages = with pkgs; [

    nodePackages.typescript-language-server
    gopls
    zls
    deno

    nixfmt-rfc-style
    nixpkgs-fmt
    nil
    nixd
    markdown-oxide
    shfmt
    nodePackages.prettier
    biome
    gofmt
    nixfmt

    mpls
  ];
}
