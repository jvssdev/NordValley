{
  config,
  pkgs,
  lib,
  ...
}:
let
  palette = config.colorScheme.palette;
in
{
  services.mako = {
    backgroundColor = palette.base00;
    borderColor = palette.base01;
    textColor = palette.base04;
    progressColor = "over ${palette.base02}";
    font = "JetBrainsMono Nerd Font  12";
    extraConfig = ''

      border-size=2

      ignore-timeout=1
      default-timeout=5000
      margin=8

      [hidden]
      format=(and %h more)
      text-color=${palette.base0D}
      border-color=${palette.base0D}

      [urgency=high]
      background-color=${palette.base0F}
      border-color=${palette.base08}
    '';
  };
}
