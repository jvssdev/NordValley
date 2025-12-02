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

  xdg.configFile."quickshell/qmldir".text = ''
    singleton IdleService 1.0 IdleService.qml
  '';

  xdg.configFile."quickshell/IdleService.qml".source = ./IdleService.qml;

  home.packages = with pkgs; [
    wlopm
    gtklock
  ];
}
