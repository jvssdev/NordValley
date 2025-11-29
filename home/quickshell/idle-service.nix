{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Add IdleService to qmldir
  xdg.configFile."quickshell/qmldir".text = lib.mkAfter ''
    singleton IdleService 1.0 IdleService.qml
  '';

  # Idle Service implementation
  xdg.configFile."quickshell/IdleService.qml".source = ./IdleService.qml;

  # Ensure required packages are available in PATH
  home.packages = with pkgs; [
    wlopm
    gtklock
  ];
}
