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
    # ./idle-service.nix
  ];
}
