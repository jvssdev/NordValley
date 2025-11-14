{
  inputs,
  config,
  pkgs,
  ...
}:
{
  programs.yazi = {
    package = pkgs.yazi;
    enable = true;
    enableZshIntegration = true;
    plugins = with pkgs.yaziPlugins; {
      inherit nord starship;
    };
    flavors = { inherit (pkgs.yaziPlugins) nord; };
    theme.flavor = {
      light = "nord";
      dark = "nord";
    };
    initLua = /* lua */ ''
      require("starship"):setup({
        hide_flags = false, -- Default: false
        flags_after_prompt = true, -- Default: true
        config_file = "~/.config/starship.toml", -- Default: nil
      })
    '';
    settings = {
      mgr = {
        show_hidden = true;
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
