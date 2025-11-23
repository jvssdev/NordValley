{
  pkgs,
  lib,
  userName,
  fullName,
  helix,
  zen-browser,
  ...
}:
{
  environment.variables = {
    EDITOR = "hx";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };
  programs.dconf.enable = true;
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      # Critical: Use XDG base directories for better flakes support
      use-xdg-base-directories = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  programs.zsh.enable = true;
  programs.starship.enable = true;
  users.users.${userName} = {
    isNormalUser = true;
    description = fullName;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "libvirtd"
      "kvm"
      "video"
      "input"
    ];
    shell = pkgs.zsh;
  };
  environment.etc."direnv/direnv.toml".text = ''
    [global]
    hide_env_diff = true
    warn_timeout = 0
    log_filter="^$"
  '';
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 30;
      consoleMode = "auto";
    };
    efi.canTouchEfiVariables = true;
    timeout = 15;
  };

  security.pam.services.gtklock = {
    text = lib.readFile "${pkgs.gtklock}/etc/pam.d/gtklock";
  };

  powerManagement = {
    powertop.enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
  };
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      font-awesome
      roboto
      montserrat
    ];
  };
  environment.systemPackages = with pkgs; [
    dconf
    glib
    qt6.qtwayland
    kdePackages.qtwayland
    kdePackages.qt6ct
    libsForQt5.qt5.qtwayland
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols2
    where-is-my-sddm-theme
    colloid-gtk-theme
    colloid-icon-theme
    bibata-cursors
  ];
  services = {
    xserver = {
      enable = false;
      xkb = {
        layout = "br";
        variant = "";
      };
    };
    displayManager.autoLogin = {
      enable = false;
      user = userName;
    };
    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
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
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    XDG_SESSION_TYPE = "wayland";
  };
  system.stateVersion = "25.05";
}
