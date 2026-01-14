{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./treesitter.nix
    ./languages.nix
    ./telescope.nix
    ./snacks-nvim.nix
    ./yazi-nvim.nix
    ./conform.nix
    ./flash.nix
    ./ui.nix
  ];

  programs.nvf = {
    enable = true;
    defaultEditor = true;

    settings = {
      vim = {
        package = pkgs.neovim-unwrapped;
        viAlias = true;
        vimAlias = true;
        lazy.enable = false;
        syntaxHighlighting = true;

        options = {
          number = true;
          relativenumber = true;
          swapfile = false;
          wrap = false;
          scrolloff = 10;
          updatetime = 250;
          smartindent = true;
          breakindent = true;
          tabstop = 4;
          shiftwidth = 2;
          softtabstop = 4;
          clipboard = "unnamedplus";
          expandtab = true;
          termguicolors = true;
          fileencoding = "utf-8";
          signcolumn = "yes";
          mouse = "";
          ignorecase = true;
          copyindent = true;
        };

        lsp = {
          enable = true;
          formatOnSave = true;
          trouble.enable = true;
        };

        globals = {
          netrw_dirhistmax = 0;
          have_nerd_font = true;
          mapleader = " ";
          maplocalleader = " ";
        };

        autocomplete = {
          blink-cmp = {
            enable = true;
            friendly-snippets.enable = true;
            setupOpts = {
              keymap.preset = "default";
              signature.enabled = true;
            };
          };
        };

        diagnostics = {
          enable = true;
          config = {
            signs = {
              text = {
                "vim.diagnostic.severity.Error" = " ";
                "vim.diagnostic.severity.Warn" = " ";
                "vim.diagnostic.severity.Hint" = " ";
                "vim.diagnostic.severity.Info" = " ";
              };
            };
            underline = true;
            update_in_insert = true;
            virtual_text = {
              format = lib.generators.mkLuaInline ''
                function(diagnostic)
                  return string.format("%s", diagnostic.message)
                end
              '';
            };
          };
        };

        notify = {
          nvim-notify = {
            enable = true;
            setupOpts = {
              stages = "fade";
              timeout = 3000;
            };
          };
        };

        notes = {
          todo-comments = {
            enable = true;
            mappings.telescope = "<leader>fd";
            setupOpts.signs = false;
          };
        };

        mini = {
          comment.enable = true;
          tabline = {
            enable = true;
            setupOpts = {
              show_icons = true;
              tabpage_section = "left";
              format = lib.generators.mkLuaInline ''
                function(buf_id, label)
                  local default_label = MiniTabline.default_format(buf_id, label)

                  local modification = vim.bo[buf_id].modified and " ●" or ""

                  return default_label .. modification
                end
              '';
            };
          };
          # move.enable = true;
        };

        binds = {
          whichKey = {
            enable = true;
          };
        };

        keymaps = [
          {
            key = "<leader>sk";
            mode = "n";
            action = "<cmd>lua require('telescope.builtin').keymaps()<CR>";
            desc = "[S]earch [K]eymaps";
          }
          {
            key = "<C-c>";
            action = "<Cmd>lua require('mini.comment').toggle_lines(vim.fn.line('.'), vim.fn.line('.'))<CR>";
            mode = "n";
            desc = "Toggle comment line";
          }
          {
            key = "L";
            action = "<Cmd>bnext<CR>";
            mode = "n";
            desc = "Go to next buffer";
          }
          {
            key = "H";
            action = "<Cmd>bprev<CR>";
            mode = "n";
            desc = "Go to previous buffer";
          }
        ];
      };
    };
  };
  home.sessionVariables.NVIM_APPNAME = "nvf";
}
