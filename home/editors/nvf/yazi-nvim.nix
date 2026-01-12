{
  programs.nvf.settings.vim = {
    utility = {
      yazi-nvim = {
        enable = true;
        setupOpts = {
          open_for_directories = false;
          keymaps = {
            show_help = "<f1>";
          };
        };
      };
    };

    luaConfigRC.yazi-custom = ''
      vim.g.loaded_netrwPlugin = 1

      local function open_yazi_external()
        local tmp_file = '/tmp/yazi-path-' .. vim.fn.getpid()
        vim.fn.system('rm -f ' .. tmp_file)
        local current_file = vim.fn.expand('%:p')
        if current_file == "" then
          current_file = vim.fn.getcwd()
        end
        vim.cmd('silent! write')
        local cmd = string.format('ghostty --title=yazi-picker -e sh -c "yazi \'%s\' --chooser-file=%s"', current_file, tmp_file)
        vim.fn.jobstart(cmd, {
          on_exit = function()
            vim.schedule(function()
              if vim.fn.filereadable(tmp_file) == 1 then
                local chosen_file = vim.fn.readfile(tmp_file)[1]
                if chosen_file and chosen_file ~= "" then
                  vim.cmd('edit ' .. vim.fn.fnameescape(chosen_file))
                end
              end
              vim.fn.system('rm -f ' .. tmp_file)
            end)
          end,
        })
      end

      vim.keymap.set({'n', 'v'}, '<leader>e', open_yazi_external, { desc = 'Open yazi in external terminal' })
    '';
  };
}
