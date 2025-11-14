{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.mako = {
    enable = true;

    font = "JetBrainsMono Nerd Font 12";
    borderSize = 2;
    ignoreTimeout = true;
    defaultTimeout = 5000;
    margin = "8";

    extraConfig = ''
      [hidden]
      format=(and %h more)
    '';
  };
}
