{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      settings.user.name = "João Víctor Santos Silva";
      settings.user.email = "joao.victor.ss.dev@gmail.com";
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    mpv = {
      enable = true;
    };
  };
  systemd.user.services.playerctld = {
    Unit = {
      Description = "playerctl daemon";
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.playerctl}/bin/playerctld daemon";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  xdg.configFile."direnv/direnv.toml".text = ''
    [global]
    hide_env_diff = true
    warn_timeout = 0
    log_filter="^$"
  '';
}
