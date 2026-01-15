{ pkgs, ... }:

{
  programs.thunar = {
    enable = true;
    plugins = [
      pkgs.xfce.thunar-archive-plugin
      pkgs.xfce.thunar-media-tags-plugin
      pkgs.xfce.thunar-volman
    ];
  };

  programs.xfconf.enable = true;
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
  };

  environment.systemPackages = [
    pkgs.kdePackages.ark
    pkgs.ffmpegthumbnailer
    pkgs.libgsf
    pkgs.xfce.tumbler
  ];
}
