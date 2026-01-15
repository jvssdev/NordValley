{ pkgs, ... }:
{
  home.packages = [
    pkgs.gammastep
    pkgs.wpaperd
    pkgs.brightnessctl
  ];
  services = {
    gammastep = {
      enable = true;
      package = pkgs.gammastep;
      temperature = {
        day = 5500;
        night = 3500;
      };
      provider = "manual";
      latitude = null;
      longitude = null;
      dawnTime = "6:00-7:45";
      duskTime = "18:35-20:45";
      tray = true;
      enableVerboseLogging = false;
    };
    wpaperd = {
      enable = true;
      settings = {
        any = {
          path = "${../../Wallpapers}";
          sorting = "random";
          duration = "10m";
        };
      };
    };
  };
}
