{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) concatStringsSep escapeShellArg;

  wpaperd = "${pkgs.wpaperd}/bin/wpaperd";
  waybar = "${pkgs.waybar}/bin/waybar";
  mako = "${pkgs.mako}/bin/mako";
  nm-applet = "${pkgs.networkmanagerapplet}/bin/nm-applet";
  blueman-applet = "${pkgs.blueman}/bin/blueman-applet";
  wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
  quickshell = "${pkgs.quickshell}/bin/quickshell";

  spawns = [
    "${wpaperd}"
    "${waybar} -d"
    "${mako}"
    "${nm-applet} --indicator"
    "${blueman-applet}"
    "${quickshell}"
  ];
in
{
  wayland.windowManager.river.settings.spawn = map escapeShellArg spawns;
}
