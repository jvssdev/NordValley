{
  config,
  pkgs,
  lib,
  mango,
  ...
}:
let
  palette = config.colorScheme.palette;
  hexToMango = hex: "0x${hex}ff";
in
{
  wayland.windowManager.mango = {
    enable = true;
    package = mango.packages.${pkgs.system}.default;

    systemd = {
      enable = true;
      variables = [
        "DISPLAY"
        "WAYLAND_DISPLAY"
        "XDG_CURRENT_DESKTOP"
        "XDG_SESSION_TYPE"
        "NIXOS_OZONE_WL"
        "XCURSOR_THEME"
        "XCURSOR_SIZE"
        "QT_QPA_PLATFORM"
        "MOZ_ENABLE_WAYLAND"
      ];
      extraCommands = [
        "systemctl --user reset-failed"
        "systemctl --user start mango-session.target"
      ];
      xdgAutostart = false;
    };

    autostart_sh = ''
      ${pkgs.gsettings-desktop-schemas}/bin/gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"
      ${pkgs.gsettings-desktop-schemas}/bin/gsettings set org.gnome.desktop.interface cursor-size 24

      ${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1 &

      ${pkgs.wpaperd}/bin/wpaperd &

      ${pkgs.mako}/bin/mako &

      ${pkgs.waybar}/bin/waybar &
      ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator &
      ${pkgs.blueman}/bin/blueman-applet &

      ${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store &
      ${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store &
      ${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard both &
    '';

    settings = ''
      monitorrule=eDP-1,0.55,1,tile,0,1,0,0,1920,1080,60
      xkb_rules_layout=br

      gappih=6
      gappiv=6
      gappoh=6
      gappov=6
      borderpx=2
      border_radius=0
      no_border_when_single=0

      rootcolor=${hexToMango palette.base00}
      bordercolor=${hexToMango palette.base03}
      focuscolor=${hexToMango palette.base0D}
      urgentcolor=${hexToMango palette.base08}

      bind=SUPER,r,reload_config

      focus_on_activate=0
      focus_cross_monitor=1
      new_is_master=0
      default_mfact=0.55
      repeat_rate=50
      repeat_delay=300
      focus_follows_cursor=1
      warpcursor=1
      cursor_hide_timeout=5000
      trackpad_natural_scrolling=0

      animations=0
      animation_type_open=zoom
      animation_type_close=zoom
      blur=0
      shadows=1
      shadow_only_floating=1
      shadows_size=12
      shadows_blur=15
      shadowscolor=${hexToMango palette.base00}

      scroller_structs=20
      scroller_default_proportion=0.6
      scroller_focus_center=0
      scroller_prefer_center=1
      scroller_default_proportion_single=1.0

      tagrule=id:1,layout_name:tile
      tagrule=id:2,layout_name:tile
      tagrule=id:3,layout_name:tile
      tagrule=id:4,layout_name:tile
      tagrule=id:5,layout_name:tile
      tagrule=id:6,layout_name:tile
      tagrule=id:7,layout_name:tile
      tagrule=id:8,layout_name:tile
      tagrule=id:9,layout_name:tile

      bind=SUPER,t,spawn,ghostty
      bind=SUPER,a,spawn,fuzzel
      bind=SUPER,n,spawn,mako-fuzzel
      bind=SUPER,b,spawn,helium
      bind=SUPER,e,spawn,thunar
      bind=SUPER,x,spawn,wlogout
      bind=SUPER,p,spawn,grim -g "$(slurp)" - | wl-copy

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
      bind=SUPER+SHIFT,j,exchange_client,down
      bind=SUPER+SHIFT,k,exchange_client,up
      bind=SUPER+SHIFT,h,exchange_client,left
      bind=SUPER+SHIFT,l,exchange_client,right
      bind=SUPER,i,incnmaster,+1
      bind=SUPER,d,incnmaster,-1
      bind=SUPER,Return,zoom
      bind=SUPER+ALT,h,resizewin,-50,0
      bind=SUPER+ALT,l,resizewin,+50,0
      bind=SUPER+ALT,k,resizewin,0,-50
      bind=SUPER+ALT,j,resizewin,0,+50

      bind=SUPER,m,setlayout,tile
      bind=SUPER,c,setlayout,spiral
      bind=SUPER,s,setlayout,scroller
      bind=SUPER,y,switch_layout
      bind=SUPER,g,togglegaps
      bind=SUPER,Tab,toggleoverview

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

      bind=SUPER,period,focusmon,next
      bind=SUPER,comma,focusmon,prev
      bind=SUPER+SHIFT,period,tagmon,next
      bind=SUPER+SHIFT,comma,tagmon,prev

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
      mousebind=SUPER,btn_middle,togglefloating

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
      windowrule=appid:thunar,isfloating:1
      windowrule=appid:Thunar,isfloating:1

      env=QT_QPA_PLATFORMTHEME,qt5ct
      env=QT_AUTO_SCREEN_SCALE_FACTOR,1
      env=QT_QPA_PLATFORM,wayland
      env=QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env=XDG_SESSION_TYPE,wayland
      env=GDK_BACKEND,wayland
      env=CLUTTER_BACKEND,wayland
      env=MOZ_ENABLE_WAYLAND,1
      env=ELECTRON_OZONE_PLATFORM_HINT,auto
      env=XCURSOR_SIZE,24
      env=XCURSOR_THEME,Bibata-Modern-Ice
      env=NIXOS_OZONE_WL,1
    '';
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config = {
      common.default = "*";
      mango = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      };
    };
  };
}
