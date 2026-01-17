{
  pkgs,
  userName,
  fullName,
  ...
}:
{
  environment = {
    variables = {
      EDITOR = "nvim";
      XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = "24";
    };
    etc."direnv/direnv.toml".text = ''
      [global]
      hide_env_diff = true
      warn_timeout = 0
      log_filter="^$"
    '';
    systemPackages = with pkgs; [
      mpc
      playerctl
      pamixer
      pavucontrol
      networkmanagerapplet
      keepassxc
      anydesk
      ghostty
      dconf
      glib
      p7zip
      appimage-run
      nh
      mpv
      imv
      qbittorrent
      libgcc
      lxqt.lxqt-policykit
      libnotify
      gvfs
    ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      XDG_SESSION_TYPE = "wayland";
    };
  };
  programs = {
    dconf.enable = true;
    zsh.enable = true;
    xwayland.enable = true;
  };
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      use-xdg-base-directories = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
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
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 30;
        consoleMode = "auto";
      };
      efi.canTouchEfiVariables = true;
      timeout = 15;
    };

    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "rd.systemd.show_status=auto"
      "rd.udev.log_level=3"
      "acpi_osi=Linux"
      "pci=noaer"
      "fbcon=nodefer"
      "randomize_kstack_offset=on"
      "vsyscall=none"
      "slab_nomerge"
      "module.sig_enforce=1"
      "page_poison=1"
      "page_alloc.shuffle=1"
      "sysrq_always_enabled=0"
      "rootflags=noatime"
      "lsm=landlock,lockdown,yama,integrity,apparmor,bpf,tomoyo,selinux"
      "i915.enable_fbc=0"
      "i915.disable_power_well=0"
    ];

    consoleLogLevel = 0;
    initrd.verbose = false;

    kernel.sysctl = {
      "kernel.sysrq" = 0;
      "kernel.kptr_restrict" = 2;
      "net.core.bpf_jit_enable" = false;
      "kernel.ftrace_enabled" = false;
      "kernel.dmesg_restrict" = 1;
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;
      "fs.suid_dumpable" = 0;
      "kernel.perf_event_paranoid" = 3;
      "kernel.unprivileged_bpf_disabled" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
    };

    blacklistedKernelModules = [
      "af_802154"
      "appletalk"
      "atm"
      "ax25"
      "can"
      "dccp"
      "decnet"
      "econet"
      "ipx"
      "n-hdlc"
      "netrom"
      "p8022"
      "p8023"
      "psnap"
      "rds"
      "rose"
      "sctp"
      "tipc"
      "x25"
      "adfs"
      "affs"
      "befs"
      "bfs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "gfs2"
      "hfs"
      "hfsplus"
      "hpfs"
      "jffs2"
      "jfs"
      "ksmbd"
      "minix"
      "nilfs2"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "udf"
      "vivid"
      "firewire-core"
      "thunderbolt"
    ];
  };

  powerManagement = {
    powertop.enable = true;
  };

  security.polkit.enable = true;
  services = {
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
  system.stateVersion = "25.11";
}
