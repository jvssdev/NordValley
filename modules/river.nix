{ userName, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    xwayland
    (pkgs.runCommand "nord-sddm-theme" { } ''
      mkdir -p $out/share/sddm/themes/nord-sddm
      cp -r ${../dotfiles/sddm-theme}/* $out/share/sddm/themes/nord-sddm/
    '')
  ];
  services = {
    xserver = {
      enable = false;
      xkb = {
        layout = "br";
        variant = "";
      };
    };
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "nord-sddm";
    };
    libinput.enable = true;
    upower.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    flatpak.enable = false;
    printing = {
      enable = false;
      drivers = [ pkgs.hplipWithPlugin ];
    };
    power-profiles-daemon.enable = false;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
    syncthing = {
      enable = true;
      user = userName;
      dataDir = "/home/${userName}";
    };
  };
  services.displayManager.autoLogin = {
    enable = false;
    user = userName;
  };
  wayland.windowManagers.river.enable = true;
  environment.etc."sddm/wayland-sessions/river.desktop".text = ''
    [Desktop Entry]
    Name=River
    Comment= a dynamic tiling Wayland compositor with flexible runtime config
    DesktopNames=river
    Exec=/usr/bin/startriver
    Type=Application
  '';
}
