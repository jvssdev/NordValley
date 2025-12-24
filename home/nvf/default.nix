{
  pkgs,
  config,
  ...
}:
let
  nvimConfigDir = "${config.home.homeDirectory}/.config/nvf-custom";
in
{
  home.file."${nvimConfigDir}".source = ./nvim;

  programs.nvf = {
    enable = true;
    defaultEditor = true;
    settings = {
      vim = {
        package = pkgs.neovim-unwrapped;
        viAlias = true;
        vimAlias = true;
        lazy.enable = false;
        startPlugins = [
          pkgs.vimPlugins.lazy-nvim
          (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
            p.bash
            p.cmake
            p.css
            p.diff
            p.dockerfile
            p.gitignore
            p.go
            p.gomod
            p.gosum
            p.html
            p.http
            p.ini
            p.javascript
            p.json
            p.just
            p.lua
            p.make
            p.markdown
            p.markdown_inline
            p.meson
            p.ninja
            p.nix
            p.php
            p.python
            p.query
            p.regex
            p.sql
            p.toml
            p.yaml
          ]))
        ];
        optPlugins = [ ];
        extraPlugins = { };
        pluginOverrides = { };
        theme = {
          enable = true;
          name = "nord";
        };
        extraPackages = [
          pkgs.ripgrep
          pkgs.fd
          pkgs.tree-sitter
          pkgs.bash-language-server
          pkgs.nil
          pkgs.pylyzer
          pkgs.pyright
          pkgs.ruff
          pkgs.clang-tools
          pkgs.lua-language-server
          pkgs.yaml-language-server
          pkgs.taplo
          pkgs.marksman
          pkgs.nodePackages_latest.typescript-language-server
          pkgs.nodePackages_latest.vscode-langservers-extracted
          pkgs.qt6.qtdeclarative
          pkgs.qt6.qttools
          pkgs.just-lsp
          pkgs.gopls
          pkgs.sqls
          pkgs.cmake-language-server
          pkgs.docker-compose-language-service
          pkgs.dockerfile-language-server
          pkgs.zls
          pkgs.delve
          pkgs.lldb
          pkgs.stylua
          pkgs.shfmt
          pkgs.prettierd
          pkgs.alejandra
          pkgs.cmake-format
          pkgs.gotools
          pkgs.black
          pkgs.rustfmt
        ];
        globals = {
          netrw_dirhistmax = 0;
        };
        options = {
          number = false;
          relativenumber = false;
        };
        keymaps = [ ];
        pluginRC = { };
        luaConfigPre = "";
        luaConfigRC = {
          userInit = ''
            local custom_config = "${nvimConfigDir}/init.lua"
            if vim.fn.filereadable(custom_config) == 1 then
              dofile(custom_config)
            end
          '';
        };
        luaConfigPost = "";
        additionalRuntimePaths = [
          nvimConfigDir
        ];
        extraLuaFiles = [ ];
        withRuby = false;
        withNodeJs = false;
        luaPackages = [ ];
        withPython3 = true;
        python3Packages = [ ];
      };
    };
  };

  home.sessionVariables.NVIM_APPNAME = "nvf";
}
