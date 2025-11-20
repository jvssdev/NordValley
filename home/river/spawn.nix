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
  quickshell = "${pkgs.quickshell}/bin/quickshell";
  dbus-update = "${pkgs.dbus}/bin/dbus-update-activation-environment";
  systemctl = "${pkgs.systemd}/bin/systemctl";

  spawns = [
    "${dbus-update} --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river XCURSOR_THEME XCURSOR_SIZE"
    "${systemctl} --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XCURSOR_THEME XCURSOR_SIZE"

    "seat seat0 xcursor-theme Bibata-Modern-Ice 24"

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
