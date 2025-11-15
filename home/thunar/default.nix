{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.thunar = {
    enable = true;
    plugins = [
      pkgs.xfce.thunar-archive-plugin
      pkgs.xfce.thunar-media-tags-plugin
      pkgs.xfce.thunar-volman
    ];
  };

  home.packages = with pkgs; [
    ark
    ffmpegthumbnailer
    libgsf
    xfce.tumbler
  ];
}
