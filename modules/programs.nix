{
  pkgs,
  config,
  lib,
  ...
}:

{
  programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  xdg.configFile."direnv/direnv.toml".text = ''
    [global]
    hide_env_diff = true
    warn_timeout = 0
    log_filter="^$"
  '';
}
