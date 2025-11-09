{ userName, pkgs, ... }:
{
  # Enable Mango at system level (this now works after flake import)
  programs.mango.enable = true;

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

  # Desktop entry for Mango (no exec path needed; module handles it)
  environment.etc."sddm/wayland-sessions/mango.desktop".text = ''
    [Desktop Entry]
    Name=MangoWC
    Comment=A Wayland compositor based on wlroots
    DesktopNames=mango
    Exec=mango
    Type=Application
  '';
}
