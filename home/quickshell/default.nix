{
  config,
  pkgs,
  lib,
  homeDir,
  isRiver,
  isMango,
  ...
}:
{
  imports = [
    ./notif-center.nix
    ./idle-service.nix
  ];
}
