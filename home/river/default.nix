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
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
    NIXOS_OZONE_WL = "1";
  };

  home.packages = [
    pkgs.wideriver
    pkgs.xwayland
    pkgs.hyprpolkitagent
  ];
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      };
    };
  };
  wayland.windowManager.river = {
    enable = true;
    settings = {
      keyboard-layout = "br";
      border-width = 2;
      hide-cursor.timeout = 5000;
      background-color = "0x${config.colorScheme.palette.base00}";
      border-color-focused = "0x${config.colorScheme.palette.base0D}";
      border-color-unfocused = "0x${config.colorScheme.palette.base03}";
      border-color-urgent = "0x${config.colorScheme.palette.base08}";
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
          --ratio 0.55 \
          --inner-gaps 6 \
          --outer-gaps 6 \
          --border-width 2 \
          --border-width-monocle 0 \
          --border-color-focused   0x${config.colorScheme.palette.base0D} \
          --border-color-unfocused 0x${config.colorScheme.palette.base03} \
          --log-threshold info &
        for device in $(riverctl list-inputs | grep -i touchpad); do
          riverctl input "$device" tap enabled
          riverctl input "$device" natural-scroll disabled
          riverctl input "$device" accel-profile adaptive
          riverctl input "$device" pointer-accel 0.35
        done
        gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Ice
        gsettings set org.gnome.desktop.interface cursor-size 24
      '';
  };
  gtk.gtk3.extraCss = ''
    headerbar.default-decoration { padding: 0; margin: 0; min-height: 0; }
    window decoration { box-shadow: none; border-radius: 0; }
  '';
}
