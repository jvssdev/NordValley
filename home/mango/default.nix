{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.colorScheme) palette;
  hexToMango = hex: "0x${hex}ff";
in
{
  wayland.windowManager.mango = {
    enable = true;
    systemd.enable = false;
    settings = ''
      exec-once=${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
      exec-once=systemctl --user reset-failed
      exec-once=systemctl --user start mango-session.target
      exec-once=${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent
      exec-once=${lib.getExe pkgs.xwayland-satellite} :11
      exec-once=sh -c "sleep 1; echo 'Xft.dpi: 140' | ${pkgs.xorg.xrdb}/bin/xrdb -merge"
      exec-once=${pkgs.dunst}/bin/dunst
      exec-once=${pkgs.networkmanagerapplet}/bin/nm-applet --indicator
      exec-once=${pkgs.blueman}/bin/blueman-applet
      exec-once=${pkgs.quickshell}/bin/quickshell
      exec-once=wl-paste --type text --watch cliphist store
      exec-once=wl-paste --type image --watch cliphist store
      exec-once=wl-clip-persist --clipboard regular --reconnect-tries 0
      exec-once=${pkgs.wpaperd}/bin/wpaperd
      exec-once=fcitx5 -d

      env=WLR_NO_HARDWARE_CURSORS,1
      env=QT_AUTO_SCREEN_SCALE_FACTOR,1
      env=QT_QPA_PLATFORM,wayland;xcb
      env=QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env=XDG_SESSION_TYPE,wayland
      env=GDK_BACKEND,wayland,x11
      env=CLUTTER_BACKEND,wayland
      env=MOZ_ENABLE_WAYLAND,1
      env=ELECTRON_OZONE_PLATFORM_HINT,auto
      env=XCURSOR_THEME,Bibata-Modern-Ice
      env=XCURSOR_SIZE,24
      env=DISPLAY,:11
      env=QT_IM_MODULE,fcitx
      env=SDL_IM_MODULE,fcitx
      env=XMODIFIERS,@im=fcitx
      env=GLFW_IM_MODULE,ibus
      env=QT_QPA_PLATFORMTHEME,qt5ct
      env=QT_WAYLAND_FORCE_DPI,140
      env=GDK_DPI_SCALE,1.45

      monitorrule=eDP-1,0.60,1,tile,0,1,0,0,1920,1080,60
      xkb_rules_layout=br
      cursor_size=24
      cursor_theme=Bibata-Modern-Ice
      gappih=5
      gappiv=5
      gappoh=5
      gappov=5
      borderpx=2
      border_radius=10
      no_border_when_single=1
      rootcolor=${hexToMango palette.base00}
      bordercolor=${hexToMango palette.base03}
      focuscolor=${hexToMango palette.base0D}
      urgentcolor=${hexToMango palette.base08}
      repeat_rate=50
      repeat_delay=300
      warpcursor=1
      new_is_master=0
      smartgaps=1
      cursor_hide_timeout=5000
      trackpad_natural_scrolling=0
      animation_duration_move=500
      animation_duration_open=350
      animation_duration_tag=0
      animation_duration_close=550
      animation_duration_focus=400
      animation_curve_open=0.22,1.0,0.36,1
      animation_curve_move=0.46,1.0,0.29,1
      animation_curve_tag=0.65,0,0.35,1
      animation_curve_close=0.08,0.92,0,1
      animation_curve_focus=0.46,1.0,0.29,1

      animation_fade_in=1
      animation_fade_out=1
      tag_animation_direction=0
      animations=1
      layer_animations=1
      animation_type_open=zoom
      animation_type_close=slide
      layer_animation_type_open=zoom
      layer_animation_type_close=slide
      zoom_initial_ratio=0.3
      zoom_end_ratio=0.7
      fadein_begin_opacity=0.5
      fadeout_begin_opacity=0.8
      blur=1
      blur_layer=1
      blur_optimized=1
      blur_params_num_passes = 2
      blur_params_radius = 3
      blur_params_noise = 0.02
      blur_params_brightness = 1
      blur_params_contrast = 0.9
      blur_params_saturation = 1.5
      shadows=1
      layer_shadows = 0
      shadow_only_floating=1
      shadows_size=10
      shadows_blur=15
      shadows_position_x = 0
      shadows_position_y = 0
      shadowscolor=${hexToMango palette.base00}
      scroller_structs=0
      scroller_default_proportion=1.0
      scroller_focus_center=0
      scroller_prefer_center=1
      scroller_default_proportion_single=1.0

      default_mfact=0.5
      default_nmaster=1

      tagrule=id:1,layout_name:tile
      tagrule=id:2,layout_name:tile
      tagrule=id:3,layout_name:tile
      tagrule=id:4,layout_name:tile
      tagrule=id:5,layout_name:tile
      tagrule=id:6,layout_name:tile
      tagrule=id:7,layout_name:tile
      tagrule=id:8,layout_name:tile
      tagrule=id:9,layout_name:tile

      bind=SUPER,r,reload_config
      bind=SUPER,t,spawn,wezterm
      bind=SUPER,a,spawn,fuzzel
      bind=SUPER,n,spawn,dunst-fuzzel
      bind=SUPER,b,spawn,zen-beta
      bind=SUPER,e,spawn,thunar
      bind=SUPER,x,spawn_shell,qs ipc call powerMenu toggle
      bind=SUPER,p,spawn,screenshot
      bind=SUPER,v,spawn,fuzzel-clipboard
      bind=SUPER+SHIFT,v,spawn,fuzzel-clipboard-clear

      bind=SUPER,q,killclient
      bind=SUPER,space,togglefloating
      bind=SUPER,f,togglefullscreen
      bind=SUPER+SHIFT,f,togglefakefullscreen
      bind=SUPER,j,focusstack,next
      bind=SUPER,k,focusstack,prev
      bind=SUPER,h,focusdir,left
      bind=SUPER,l,focusdir,right
      bind=SUPER,u,focuslast
      bind=SUPER+SHIFT,Up,exchange_client,up
      bind=SUPER+SHIFT,Down,exchange_client,down
      bind=SUPER+SHIFT,Left,exchange_client,left
      bind=SUPER+SHIFT,Right,exchange_client,right
      bind=SUPER,i,incnmaster,+1
      bind=SUPER,d,incnmaster,-1
      bind=SUPER,Return,zoom
      bind=SUPER+ALT,h,resizewin,-50,0
      bind=SUPER+ALT,l,resizewin,+50,0
      bind=SUPER+ALT,k,resizewin,0,-50
      bind=SUPER+ALT,j,resizewin,0,+50
      bind=SUPER,c,setlayout,tile
      bind=SUPER,m,setlayout,monocle
      bind=SUPER,s,setlayout,scroller
      bind=SUPER,y,switch_layout
      bind=SUPER,g,togglegaps
      bind=SUPER,o,toggleoverview

      bind=SUPER,1,comboview,1
      bind=SUPER,2,comboview,2
      bind=SUPER,3,comboview,3
      bind=SUPER,4,comboview,4
      bind=SUPER,5,comboview,5
      bind=SUPER,6,comboview,6
      bind=SUPER,7,comboview,7
      bind=SUPER,8,comboview,8
      bind=SUPER,9,comboview,9

      bind=SUPER+SHIFT,1,tag,1
      bind=SUPER+SHIFT,2,tag,2
      bind=SUPER+SHIFT,3,tag,3
      bind=SUPER+SHIFT,4,tag,4
      bind=SUPER+SHIFT,5,tag,5
      bind=SUPER+SHIFT,6,tag,6
      bind=SUPER+SHIFT,7,tag,7
      bind=SUPER+SHIFT,8,tag,8
      bind=SUPER+SHIFT,9,tag,9

      bind=NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bind=NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind=NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind=NONE,XF86AudioMicMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bind=NONE,XF86MonBrightnessUp,spawn,brightnessctl s 5%+
      bind=NONE,XF86MonBrightnessDown,spawn,brightnessctl s 5%-
      bind=NONE,XF86AudioNext,spawn,playerctl next
      bind=NONE,XF86AudioPrev,spawn,playerctl previous
      bind=NONE,XF86AudioPlay,spawn,playerctl play-pause
      bind=NONE,XF86AudioPause,spawn,playerctl play-pause

      mousebind=SUPER,btn_left,moveresize,curmove
      mousebind=SUPER,btn_right,moveresize,curresize

      windowrule=title:Authentication required,isfloating:1
      windowrule=title:Keybindings,isfloating:1
      windowrule=title:Rename*,isfloating:1
      windowrule=title:Compressing*,isfloating:1
      windowrule=title:File Already Exists*,isfloating:1
      windowrule=title:Extracting Files*,isfloating:1
      windowrule=title:File Operation Progress*,isfloating:1
      windowrule=title:Confirm to replace files*,isfloating:1
      windowrule=appid:pavucontrol,isfloating:1
      windowrule=appid:blueman-manager,isfloating:1
      windowrule=appid:nm-connection-editor,isfloating:1
      windowrule=appid:^[Tt]hunar$,isfloating:1
      windowrule=appid:wezterm
      windowrule=appid:fuzzel

      # scratchpad
      enable_hotarea = 0

      windowrule=isnamedscratchpad:1,width:1900,height:1600,appid:wezterm-yazi-nvim
    '';
  };
  systemd.user.targets.mango-session = {
    Unit = {
      Description = "mango compositor session";
      Documentation = [ "man:systemd.special(7)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [
        "graphical-session-pre.target"
      ];
      After = [ "graphical-session-pre.target" ];
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = [ "gtk" ];
    config.mango = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      "org.freedesktop.impl.portal.Inhibit" = [ ];
    };
  };
  services.gnome-keyring.enable = true;
  home.packages = [
    pkgs.glib
    pkgs.xdg-utils
    pkgs.wf-recorder
    pkgs.xwayland-satellite
    pkgs.fcitx5
    pkgs.xorg.xrdb
    pkgs.hyprpolkitagent
  ];
}
