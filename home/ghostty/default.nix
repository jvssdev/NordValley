{
  config,
  ...
}:
let
  palette = config.colorScheme.palette;
in
{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 15;
      font-family = "JetBrainsMono Nerd Font";

      background = palette.base00;
      foreground = palette.base05;

      cursor-color = palette.base05;

      palette = [
        "0=#${palette.base00}" # black
        "1=#${palette.base08}" # red
        "2=#${palette.base0B}" # green
        "3=#${palette.base0A}" # yellow
        "4=#${palette.base0D}" # blue
        "5=#${palette.base0E}" # magenta
        "6=#${palette.base0C}" # cyan
        "7=#${palette.base05}" # white
        "8=#${palette.base03}" # bright black
        "9=#${palette.base08}" # bright red
        "10=#${palette.base0B}" # bright green
        "11=#${palette.base0A}" # bright yellow
        "12=#${palette.base0D}" # bright blue
        "13=#${palette.base0E}" # bright magenta
        "14=#${palette.base0C}" # bright cyan
        "15=#${palette.base07}" # bright white
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
      ];
    };
  };
}
