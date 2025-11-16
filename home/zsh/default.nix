{
  config,
  pkgs,
  lib,
  zsh-hlx,
  ...
}:
let
  palette = config.colorScheme.palette;
in
{
  programs.zsh = {
    enable = true;
    history = {
      size = 100000;
      save = 20000;
      path = "${config.xdg.cacheHome}/zsh/history";
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };
    enableCompletion = true;
    completionInit = ''
      autoload -Uz compinit
      zstyle ':completion:*' menu select
      zmodload zsh/complist
      _comp_options+=(globdots)
      compinit -d ${config.xdg.cacheHome}/zsh/zcompdump-$ZSH_VERSION
    '';
    profileExtra = ''
      export PATH="/usr/lib64/qt6/bin:$PATH"
      export PATH="$HOME/.cargo/bin:$PATH"
      export GOPATH=$HOME/go
      export PATH="$HOME/.local/bin:$PATH"
    '';
    shellAliases = {
      xh = "hx";
      ls = "lsd";
      cat = "bat --paging=never";
    };
    plugins = [
      {
        name = "zsh-helix-mode";
        src = zsh-hlx.packages.${pkgs.system}.default;
        file = "share/zsh/zsh-helix-mode/zsh-helix-mode.plugin.zsh";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
        file = "share/zsh-completions/zsh-completions.zsh";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
      }
    ];
    initContent = lib.mkMerge [
      (lib.mkOrder 1300 ''
        autoload -U select-word-style
        select-word-style bash
        export ZHM_STYLE_CURSOR_SELECT="fg:#${palette.base00},bg:#${palette.base08}"
        export ZHM_STYLE_CURSOR_INSERT="fg:#${palette.base00},bg:#${palette.base0B}"
        export ZHM_STYLE_OTHER_CURSOR_NORMAL="fg:#${palette.base00},bg:#${palette.base0C}"
        export ZHM_STYLE_OTHER_CURSOR_SELECT="fg:#${palette.base00},bg:#${palette.base0E}"
        export ZHM_STYLE_OTHER_CURSOR_INSERT="fg:#${palette.base00},bg:#${palette.base0D}"
        export ZHM_STYLE_SELECTION="fg:#${palette.base07},bg:#${palette.base02}"
        export ZHM_CURSOR_INSERT='\e[0m\e[6 q\e]12;#${palette.base0B}\a'
        ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
          zhm_history_prev zhm_history_next zhm_prompt_accept
          zhm_accept zhm_accept_or_insert_newline
        )
        ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(
          zhm_move_right zhm_clear_selection_move_right
        )
        ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(
          zhm_move_next_word_start zhm_move_next_word_end
        )
        eval "$(${pkgs.fzf}/bin/fzf --zsh)"
        zhm_wrap_widget fzf-completion zhm_fzf_completion
        bindkey '^I' zhm_fzf_completion
        export FZF_DEFAULT_OPTS="
          --color=bg+:#${palette.base02},bg:#${palette.base00},spinner:#${palette.base04},hl:#${palette.base0D}
          --color=fg:#${palette.base05},header:#${palette.base0D},info:#${palette.base0C},pointer:#${palette.base04}
          --color=marker:#${palette.base0B},fg+:#${palette.base07},prompt:#${palette.base0C},hl+:#${palette.base0C}"
        eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
        eval "$(${pkgs.starship}/bin/starship init zsh)"
      '')
    ];
  };
  xdg.cacheHome = "${config.home.homeDirectory}/.cache";
}
