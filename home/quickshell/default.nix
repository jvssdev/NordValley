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
    ./config.nix
    # ./idle-service.nix
  ];
}
