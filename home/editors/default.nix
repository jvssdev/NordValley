{pkgs, ...}: {
  imports = [
    ./nvf
    ./zed
    # ./helix
  ];

  home.packages = with pkgs; [
    ripgrep
    fd
    tree-sitter
    bash-language-server
    nil
    pylyzer
    pyright
    ruff
    clang-tools
    lua-language-server
    yaml-language-server
    taplo
    marksman
    nodePackages_latest.typescript-language-server
    nodePackages_latest.vscode-langservers-extracted
    qt6.qtdeclarative
    qt6.qttools
    just-lsp
    gopls
    sqls
    cmake-language-server
    docker-compose-language-service
    dockerfile-language-server
    zls
    delve
    lldb
    stylua
    shfmt
    prettierd
    alejandra
    cmake-format
    gotools
    black
    rustfmt
    biome
  ];
}
