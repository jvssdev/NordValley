{ config, ... }:
{

  programs.zed-editor = {
    enable = true;

    extensions = [
      "biome"
      "nix"
      "nord"
    ];

    userSettings = {
      theme = {
        mode = "system";
        light = "Nord";
        dark = "Nord";
      };

      autosave = "on_focus_change";

      formatter = {
        language_server.name = "biome";
      };

      code_actions_on_format = {
        "source.fixAll.biome" = true;
        "source.organizeImports.biome" = true;
      };

      inlay_hints.enabled = true;

      indent_guides.coloring = "indent_aware";

      buffer_font_family = "JetBrains Mono";
      ui_font_family = "JetBrains Mono";

      telemetry = {
        diagnostics = false;
        metrics = false;
      };
    };
  };
}
