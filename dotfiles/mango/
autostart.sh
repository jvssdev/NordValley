waybar >/dev/null 2>&1 &
#wpaperd -i $HOME/Wallpapers/ >/dev/null 2>&1 &
mako >/dev/null 2>&1 &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
nm-applet >/dev/null 2>&1 &
easyeffects --gapplication-service >/dev/null 2>&1 &
wl-clip-persist --clipboard regular --reconnect-tries 0 &

wl-paste --type text --watch cliphist store & 
wl-paste --type image --watch cliphist store & 
/usr/lib/mate-polkit/mate-polkit &
