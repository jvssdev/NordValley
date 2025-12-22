{
  config,
  pkgs,
  ...
}:
{
  programs.yazi = {
    package = pkgs.yazi;
    enable = true;
    enableZshIntegration = true;

    plugins = {
      starship = "${pkgs.yaziPlugins.starship}";
    };

    flavors = {
      nord = "${pkgs.yaziPlugins.nord}";
    };

    theme = {
      flavor = {
        use = "nord";
      };
    };

    initLua = ''
      require("starship"):setup({
        hide_flags = false,
        flags_after_prompt = true,
        config_file = "~/.config/starship.toml",
      })
    '';

    settings = {
      mgr = {
        show_hidden = true;
        ratio = [
          1
          3
          4
        ];
      };
      preview = {
        tab_size = 2;
        max_width = 1920;
        max_height = 1080;
      };
      opener = {
        play = [
          {
            run = "mpv \"$@\"";
            orphan = true;
            for = "unix";
          }
        ];
        image = [
          {
            run = "imv \"$@\"";
            orphan = true;
            for = "unix";
          }
        ];
        pdf = [
          {
            run = "zathura \"$@\"";
            orphan = true;
            for = "unix";
          }
        ];
        edit = [
          {
            run = "${config.programs.helix.package}/bin/hx \"$@\"";
            block = true;
            for = "unix";
          }
        ];
      };
      open = {
        rules = [
          {
            mime = "image/*";
            use = "image";
          }
          {
            mime = "application/pdf";
            use = "pdf";
          }
          {
            mime = "video/*";
            use = "play";
          }
          {
            mime = "audio/*";
            use = "play";
          }
          {
            mime = "text/*";
            use = "edit";
          }
          {
            mime = "application/json";
            use = "edit";
          }
          {
            mime = "application/javascript";
            use = "edit";
          }
          {
            mime = "application/x-shellscript";
            use = "edit";
          }
          {
            mime = "*";
            use = "edit";
          }
        ];
      };
    };
  };
}
