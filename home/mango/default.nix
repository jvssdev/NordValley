{ config, pkgs, ... }:

{
  wayland.windowManager.mango = {
    enable = true;

    autostart_sh = ''
      set +e

      waybar >/dev/null 2>&1 &
      wpaperd >/dev/null 2>&1 &
      mako >/dev/null 2>&1 &
      nm-applet >/dev/null 2>&1 &
      easyeffects --gapplication-service >/dev/null 2>&1 &

      wl-clip-persist --clipboard regular --reconnect-tries 0 &
      wl-paste --type text --watch cliphist store &
      wl-paste --type image --watch cliphist store &

      /usr/lib/mate-polkit/mate-polkit &

      quickshell >/dev/null 2>&1 &

      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots

      /usr/lib/xdg-desktop-portal-wlr &
    '';

    settings = ''
      xkb_rules_layout = "br"

      monitorrule=Virtual-1,0.55,1,tile,0,1,0,0,1920,1080,60
      monitorrule=eDP-1,0.55,1,tile,0,1,0,0,1920,1080,60

      bind=SUPER,t,spawn,ghostty
      bind=SUPER,a,spawn,fuzzel
      bind=SUPER,e,spawn,thunar
      bind=SUPER,P,spawn,grim -g "$(slurp)" - | wl-copy
      bind=SUPER,l,spawn,gtklock
      bind=CTRL+ALT,p,spawn,wleave
      bind=SUPER,m,quit

      bind=SUPER,1,comboview,1
      bind=SUPER,2,comboview,2
      bind=SUPER,3,comboview,3
      bind=SUPER,4,comboview,4
      bind=SUPER,5,comboview,5
      bind=SUPER,6,comboview,6
      bind=SUPER,7,comboview,7
      bind=SUPER,8,comboview,8
      bind=SUPER,9,comboview,9

      bind=SUPER,i,incnmaster,+1
      bind=SUPER,p,incnmaster,-1
      bind=SUPER,q,killclient
      bind=SUPER+SHIFT,r,reload_config

      bind=SUPER,t,setlayout,tile
      bind=SUPER,v,setlayout,vertical_grid
      bind=SUPER,c,setlayout,spiral
      bind=SUPER,x,setlayout,scroller
      bind=SUPER,n,switch_layout
      bind=SUPER,g,togglegaps
      bind=SUPER,s,toggleoverview

      bind=SUPER+SHIFT,f,togglefloating
      bind=SUPER,f,togglefullscreen

      bind=SUPER,Down,focusstack,next
      bind=SUPER,Up,focusstack,prev
      bind=SUPER,Left,focusdir,left
      bind=SUPER,Right,focusdir,right

      bind=SUPER+SHIFT,Up,exchange_client,up
      bind=SUPER+SHIFT,Down,exchange_client,down
      bind=SUPER+SHIFT,Left,exchange_client,left
      bind=SUPER+SHIFT,Right,exchange_client,right

      bind=SUPER+CTRL,Left,tag,prev
      bind=SUPER+CTRL,Right,tag,next
      bind=SUPER+SHIFT,1,tag,1
      bind=SUPER+SHIFT,2,tag,2
      bind=SUPER+SHIFT,3,tag,3
      bind=SUPER+SHIFT,4,tag,4
      bind=SUPER+SHIFT,5,tag,5
      bind=SUPER+SHIFT,6,tag,6
      bind=SUPER+SHIFT,7,tag,7
      bind=SUPER+SHIFT,8,tag,8
      bind=SUPER+SHIFT,9,tag,9

      gesturebind=none,left,3,focusdir,left
      gesturebind=none,right,3,focusdir,right
      gesturebind=none,up,3,focusdir,up
      gesturebind=none,down,3,focusdir,down

      bind=NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bind=NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind=NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind=NONE,XF86AudioMicMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bind=NONE,XF86MonBrightnessUp,spawn,brightnessctl s 10%+
      bind=NONE,XF86MonBrightnessDown,spawn,brightnessctl s 10%-
      bind=NONE,XF86AudioNext,spawn,playerctl next
      bind=NONE,XF86AudioPrev,spawn,playerctl previous
      bind=NONE,XF86AudioPlay,spawn,playerctl play-pause
      bind=NONE,XF86AudioPause,spawn,playerctl play-pause

      animations=1
      gappih=5 gappiv=5 gappoh=5 gappov=5
      borderpx=2
      border_radius=7
      no_border_when_single=0
      focuscolor=0x88c0d0
      mousebind=SUPER,btn_left,moveresize,curmove
      mousebind=SUPER,btn_right,moveresize,curresize

      blur=0
      blur_layer=1
      blur_optimized=1
      blur_params_num_passes=2
      blur_params_radius=5
      blur_params_noise=0.02
      blur_params_brightness=0.9
      blur_params_contrast=0.9
      blur_params_saturation=1.2

      shadows=1
      layer_shadows=1
      shadow_only_floating=1
      shadows_size=12
      shadows_blur=15
      shadowscolor=0x000000ff

      scroller_structs=20
      scroller_default_proportion=0.8
      scroller_focus_center=0
      scroller_prefer_center=1
      scroller_default_proportion_single=1.0

      windowrule=title:Authentication required,isfloating:1
      windowrule=title:Keybindings,isfloating:1
      windowrule=title:Rename*,isfloating:1
      windowrule=title:Compressing*,isfloating:1
      windowrule=title:File Already Exists*,isfloating:1
      windowrule=title:Extracting Files*,isfloating:1
      windowrule=title:File Operation Progress*,isfloating:1
      windowrule=title:Confirm to replace files*,isfloating:1
      windowrule=appid:clipse,isfloating:1,width:600,height:800
      windowrule=title:Mission Center,isfloating:1,width:1400,height:800

      env=QT_QPA_PLATFORMTHEME,qt5ct
      env=QT_AUTO_SCREEN_SCALE_FACTOR,1
      env=QT_QPA_PLATFORM,wayland
      env=QT_WAYLAND_FORCE_DPI,100
      env=XDG_SESSION_TYPE,wayland
      env=GDK_BACKEND,wayland
      env=CLUTTER_BACKEND,wayland
      env=MOZ_ENABLE_WAYLAND,1
      env=ELECTRON_OZONE_PLATFORM_HINT,auto
      env=XCURSOR_SIZE,24
    '';
  };
}
