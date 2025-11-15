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

  environment.systemPackages = [
    pkgs.ark
    pkgs.ffmpegthumbnailer
    pkgs.libgsf
    pkgs.xfce.tumbler
  ];
}
