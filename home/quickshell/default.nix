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
    ./bar.nix
  ];

  home.packages = with pkgs; [
    wlopm
    gtklock
  ];
}
