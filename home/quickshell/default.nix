{
  config,
  pkgs,
  lib,
  homeDir,
  isRiver,
  isMango,
  isNiri,
  ...
}:
{
  imports = [
    ./config.nix
  ];

  xdg.configFile."quickshell/IdleService.qml".source = ./IdleService.qml;

  home.packages = with pkgs; [
    wlopm
    gtklock
  ];
}
