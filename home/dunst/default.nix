{ config, pkgs, ... }:
let
  inherit (config.colorScheme) palette;
  inherit (config.theme.font) monospace;
in
{

  home.packages = [ pkgs.dunst ];
  services.dunst = {
    enable = true;

    settings = {
      global = {
        monitor = 0;
        follow = "mouse";

        width = 400;
        height = "(0, 200)";
        origin = "top-right";
        offset = "(8, 8)";

        notification_limit = 0;

        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 400;

        indicate_hidden = true;
        separator_height = 2;
        padding = 10;
        horizontal_padding = 10;
        text_icon_padding = 0;
        frame_width = 2;
        frame_color = "#${palette.base01}";
        separator_color = "frame";
        sort = true;

        font = "${builtins.head monospace} 12";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;

        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 64;

        sticky_history = true;
        history_length = 100;

        browser = "brave";

        always_run_script = true;

        title = "Dunst";
        class = "Dunst";

        corner_radius = 0;
        ignore_dbusclose = false;

        force_xwayland = false;

        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      experimental = {
        per_monitor_dpi = false;
      };

      urgency_low = {
        background = "#${palette.base00}";
        foreground = "#${palette.base04}";
        frame_color = "#${palette.base01}";
        timeout = 5;
      };

      urgency_normal = {
        background = "#${palette.base00}";
        foreground = "#${palette.base04}";
        frame_color = "#${palette.base01}";
        timeout = 5;
      };

      urgency_critical = {
        background = "#${palette.base0F}";
        foreground = "#${palette.base05}";
        frame_color = "#${palette.base08}";
        timeout = 0;
      };
    };
  };
}
