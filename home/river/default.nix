{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./maps.nix
    ./rules.nix
    ./spawn.nix
  ];

  home.sessionVariables = lib.mkIf config.wayland.windowManager.river.enable {
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  home.packages = with pkgs; [
    wideriver
  ];

  # XDG Desktop Portal configuration for River
  xdg.configFile."xdg-desktop-portal/river-portals.conf".text = ''
    [preferred]
    default=gtk
    org.freedesktop.impl.portal.Screenshot=wlr
    org.freedesktop.impl.portal.ScreenCast=wlr
    org.freedesktop.impl.portal.Inhibit=none
  '';

  wayland.windowManager.river = {
    enable = true;

    settings = {
      keyboard-layout = "br";
      border-width = 2;
      hide-cursor.timeout = 5000;
      background-color = "0x2e3440";
      border-color-focused = "0x88c0d0";
      border-color-unfocused = "0x4c566a";
      set-repeat = "50 300";
      focus-follows-cursor = "always";
      set-cursor-warp = "on-output-change";
      xcursor-theme = "Bibata-Modern-Ice 24";
      default-layout = "wideriver";
    };

    extraConfig =
      let
        wideriver = "${pkgs.wideriver}/bin/wideriver";
      in
      ''
        ${wideriver} \
          --layout left \
          --stack dwindle \
          --layout-alt monocle \
          --count 1 \
          --ratio 0.50 \
          --inner-gaps 6 \
          --outer-gaps 6 \
          --border-width ${toString config.wayland.windowManager.river.settings.border-width} \
          --border-width-monocle 0 \
          --border-color-focused 0x88c0d0 \
          --border-color-focused-monocle 0x4c566a \
          --border-color-unfocused 0x4c566a \
          --log-threshold info \
          > "/tmp/wideriver.''${XDG_VTNR}.''${USER}.log" 2>&1 &

        # Set up touchpads
        for device in $(riverctl list-inputs | grep -i 'touchpad'); do
          riverctl input "$device" pointer-accel 0.35
          riverctl input "$device" scroll-factor 1.30
          riverctl input "$device" click-method clickfinger
          riverctl input "$device" accel-profile adaptive
          riverctl input "$device" tap enabled
          riverctl input "$device" tap-button-map left-right-middle
          riverctl input "$device" drag disabled
          riverctl input "$device" disable-while-typing enabled
          riverctl input "$device" natural-scroll disabled
        done

        # GTK/GNOME settings
        gsettings set "org.gnome.desktop.interface" color-scheme "prefer-dark"
        gsettings set "org.gnome.desktop.interface" gtk-theme "Nordic"
        gsettings set "org.gnome.desktop.interface" icon-theme "Nordzy-dark"
        gsettings set "org.gnome.desktop.interface" cursor-theme "Bibata-Modern-Ice"
      '';
  };

  # Disable ugly GTK header
  gtk.gtk3.extraCss = ''
    /* No (default) title bar on wayland */
    headerbar.default-decoration {
      margin-bottom: 50px;
      margin-top: -100px;
    }
    /* rm -rf window shadows */
    window.csd,
    window.csd decoration {
      box-shadow: none;
    }
    decoration {
      border-radius: 0;
      border: none;
      padding: 0;
      box-shadow: none;
    }
    decoration:backdrop {
      border-radius: 0;
      border: none;
      box-shadow: none;
    }
  '';
}
