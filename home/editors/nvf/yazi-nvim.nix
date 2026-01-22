{
  programs.nvf.settings.vim = {
    luaConfigRC.yazi-custom = ''
      vim.g.loaded_netrwPlugin = 1

      local tmp_file = '/tmp/yazi-nvim-' .. vim.fn.getpid()

      local function open_yazi_external()
        local current_file = vim.fn.expand('%:p')
        if current_file == "" then
          current_file = vim.fn.getcwd()
        end
        
        if vim.bo.modified then
          vim.cmd('silent! write')
        end
        
        vim.uv.spawn('ghostty', {
          args = {
            '--title=yazi-picker',
            '-e', 'sh', '-c',
            string.format("yazi '%s' --chooser-file='%s'", current_file, tmp_file)
          },
          detached = true,
        }, function()
          vim.schedule(function()
            local file = io.open(tmp_file, 'r')
            if file then
              local chosen_file = file:read('*l')
              file:close()
              os.remove(tmp_file)
              
              if chosen_file and chosen_file ~= "" and chosen_file ~= current_file then
                vim.cmd('edit ' .. vim.fn.fnameescape(chosen_file))
              end
            end
          end)
        end)
      end

      vim.keymap.set({'n', 'v'}, '<leader>e', open_yazi_external, { desc = 'Open yazi in external terminal' })
    '';
  };
}
