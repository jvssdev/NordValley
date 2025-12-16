let
  accentColor = "34";
in
{
  programs.fastfetch = {
    enable = true;

    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

      logo = {
        padding = { };
      };

      display = {
        separator = " ";
      };

      modules = [
        "break"
        {
          type = "os";
          key = " ";
          keyColor = accentColor;
        }
        {
          type = "kernel";
          key = " ";
          keyColor = accentColor;
        }
        {
          type = "initsystem";
          key = "󱤶 ";
          keyColor = accentColor;
        }
        {
          type = "packages";
          key = " ";
          keyColor = accentColor;
        }
        {
          type = "shell";
          key = " ";
          keyColor = accentColor;
        }
        {
          type = "terminal";
          key = " ";
          keyColor = accentColor;
        }
        {
          type = "wm";
          key = " ";
          keyColor = accentColor;
        }
        {
          type = "cursor";
          key = "󰇀 ";
          keyColor = accentColor;
        }
        {
          type = "terminalfont";
          key = " ";
          keyColor = accentColor;
        }
        {
          type = "uptime";
          key = " ";
          keyColor = accentColor;
        }
        {
          type = "datetime";
          format = "{1}-{3}-{11}";
          key = " ";
          keyColor = accentColor;
        }
        {
          type = "memory";
          key = "󰍛 ";
          keyColor = accentColor;
        }
        {
          type = "monitor";
          key = " ";
          keyColor = accentColor;
        }
      ];
    };
  };
}
