{ pkgs, config, ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 15;
      font-family = "JetBrainsMono Nerd Font";
      theme = "Nord";
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
        "ctrl+w=close_tab:this"
        "alt+left=unbind"
        "alt+right=unbind"
        "alt+h=previous_tab"
        "alt+l=next_tab"
        "ctrl+t=new_tab"
        "shift+enter=text:\n"
      ];
    };
  };
}
