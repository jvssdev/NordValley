{
  programs.nvf.settings.vim.tabline.nvimBufferline = {
    enable = true;

    mappings = {
      closeCurrent = "<leader>bd";
      cycleNext = "L";
      cyclePrevious = "H";
    };

    setupOpts.options = {
      numbers = "none";
      separator_style = "thick";
      modified_icon = "●";

      indicator = {
        style = "none"; # This removes the underline/icon indicator
      };
    };
  };
}
