{
  pkgs,
  config,
  # ghostty,
  ...
}:
let
  inherit (config.colorScheme) palette;
in
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    # package = ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      font-size = 15;
      font-family = "JetBrainsMono Nerd Font";
      background = palette.base00;
      foreground = palette.base05;
      cursor-color = palette.base05;
      palette = [
        "0=#${palette.base00}"
        "1=#${palette.base08}"
        "2=#${palette.base0B}"
        "3=#${palette.base0A}"
        "4=#${palette.base0D}"
        "5=#${palette.base0E}"
        "6=#${palette.base0C}"
        "7=#${palette.base05}"
        "8=#${palette.base04}"
        "9=#${palette.base08}"
        "10=#${palette.base0B}"
        "11=#${palette.base0A}"
        "12=#${palette.base0D}"
        "13=#${palette.base0E}"
        "14=#${palette.base0C}"
        "15=#${palette.base06}"
      ];
      window-decoration = false;
      cursor-style = "bar";
      cursor-style-blink = false;
      mouse-hide-while-typing = true;
      copy-on-select = false;
      confirm-close-surface = false;
      shell-integration = "zsh";
      shell-integration-features = "sudo,title,no-cursor";
      keybind = [
        "ctrl+plus=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+zero=reset_font_size"
        "ctrl+w=close_tab"
        "alt+left=unbind"
        "alt+right=unbind"
        "alt+h=previous_tab"
        "alt+l=next_tab"
        "ctrl+t=new_tab"
        "shift+enter=text:\n"
        # "alt+v=activate_key_table:vim"

        # Key table definition
        # "vim/"

        # Line movement
        # "vim/j=scroll_page_lines:1"
        # "vim/k=scroll_page_lines:-1"

        # Page movement
        # "vim/ctrl+d=scroll_page_down"
        # "vim/ctrl+u=scroll_page_up"
        # "vim/ctrl+f=scroll_page_down"
        # "vim/ctrl+b=scroll_page_up"
        # "vim/shift+j=scroll_page_down"
        # "vim/shift+k=scroll_page_up"

        # Jump to top/bottom
        # "vim/g>g=scroll_to_top"
        # "vim/shift+g=scroll_to_bottom"

        # Search (if you want vim-style search entry)
        # "vim/slash=start_search"
        # "vim/n=navigate_search:next"

        # Copy mode / selection
        # Note we're missing a lot of actions here to make this more full featured.
        # "vim/v=copy_to_clipboard"
        # "vim/y=copy_to_clipboard"

        # Command Palette
        # "vim/shift+semicolon=toggle_command_palette"

        # Exit
        # "vim/escape=deactivate_key_table"
        # "vim/q=deactivate_key_table"
        # "vim/i=deactivate_key_table"

        # Catch unbound keys
        # "vim/catch_all=ignore"
      ];
    };
  };
}
