{
  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        path = "${../../Wallpapers}";
        sorting = "random";
        duration = "10m";
      };
    };
  };
}
