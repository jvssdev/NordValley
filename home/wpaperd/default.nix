{
  services.wpaperd = {
    enable = true;
    settings = {
      any = {
        path = "${../../Wallpapers}";
        sorting = "random";
        duration = "10m";
      };
    };
  };
}
