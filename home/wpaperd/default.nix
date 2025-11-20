{
  pkgs,
  config,
  specialArgs,
  lib,
  ...
}:
let
  inherit (specialArgs)
    homeDir
    ;
in

{
  services.wpaperd = {
    enable = true;
    settings = {
      eDP-1 = {
        path = ../../Wallpapers;
        sorting = "random";
        duration = "10m";
      };
    };
  };
}
