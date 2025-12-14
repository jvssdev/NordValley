{
  pkgs,
  ...
}:
let
  spawns = [
    "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river NIXOS_OZONE_WL"
    "${pkgs.systemd}/bin/systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1 &"
    "${pkgs.wpaperd}/bin/wpaperd &"
    "${pkgs.waybar}/bin/waybar &"
    "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &"
    "${pkgs.blueman}/bin/blueman-applet &"
    "${pkgs.dunst}/bin/dunst &"
    "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store &"
    "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store &"
    "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular --reconnect-tries 0 &"
  ];
in
{
  wayland.windowManager.river.settings.spawn = spawns;
}
