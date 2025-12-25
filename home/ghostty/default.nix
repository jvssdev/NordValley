{
  pkgs,
  config,
  ghostty,
  ...
}: let
  palette = config.colorScheme.palette;
in {
  programs.ghostty = {
    enable = true;
    package = ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
        "8=#${palette.base03}"
        "9=#${palette.base08}"
        "10=#${palette.base0B}"
        "11=#${palette.base0A}"
        "12=#${palette.base0D}"
        "13=#${palette.base0E}"
        "14=#${palette.base0C}"
        "15=#${palette.base07}"
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
