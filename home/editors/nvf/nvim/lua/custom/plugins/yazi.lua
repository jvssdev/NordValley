return {
  'mikavilpas/yazi.nvim',
  version = '*',
  event = 'VeryLazy',
  dependencies = {
    { 'nvim-lua/plenary.nvim', lazy = true },
  },
  keys = {
    {
      '<leader>e',
      mode = { 'n', 'v' },
      function()
        local tmp_file = '/tmp/yazi-path-' .. vim.fn.getpid()

        vim.fn.system('rm -f ' .. tmp_file)

        local current_file = vim.fn.expand '%:p'
        if current_file == '' then
          current_file = vim.fn.getcwd()
        end

        vim.cmd 'silent! write'

        local cmd = string.format('ghostty --title=yazi-picker -e sh -c "yazi \'%s\' --chooser-file=%s"', current_file, tmp_file)

        vim.fn.jobstart(cmd, {
          on_exit = function()
            vim.schedule(function()
              if vim.fn.filereadable(tmp_file) == 1 then
                local chosen_file = vim.fn.readfile(tmp_file)[1]
                if chosen_file and chosen_file ~= '' then
                  vim.cmd('edit ' .. vim.fn.fnameescape(chosen_file))
                end
              end
              vim.fn.system('rm -f ' .. tmp_file)
            end)
          end,
        })
      end,
      desc = 'Open yazi in external terminal',
    },
  },
  opts = {
    open_for_directories = false,
    keymaps = {
      show_help = '<f1>',
    },
  },
  init = function()
    vim.g.loaded_netrwPlugin = 1
  end,
}
