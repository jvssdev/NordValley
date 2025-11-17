{
  pkgs,
  withGUI ? true,
  ...
}:

with pkgs;

let
  basePackages = [
    # Build essentials
    efibootmgr
    gcc
    gnumake
    cargo
    rustc
    wget
    unzip
    tree-sitter
    nodejs_22

    bibata-cursors

    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    xwayland

    zig
    go

    # CLI tools
    lazygit
    fzf
    fd
    ncdu
    ripgrep
    nixos-shell
    nix-your-shell

    bat
    starship
    lsd
    ffmpeg

    # Media
    mpc
    playerctl

    # Wayland tools
    wleave
    wlopm
    wpaperd
    gammastep

    # System utilities
    p7zip
    brightnessctl
    appimage-run
    nh
    grim
    slurp
    wl-clipboard
    cliphist

    # Cloud/Sync tools
    rclone
    rclone-ui

    # GUI applications
    keepassxc
    anydesk
    lmstudio
    qbittorrent
    mpv
    imv

    # Libraries
    libgcc
    lxqt.lxqt-policykit
    libnotify

    gvfs

    # Polkit
    polkit
    mate.mate-polkit

    # Network
    networkmanagerapplet

    # Qt
    libsForQt5.qt5.qtgraphicaleffects
    qt6.qtwayland
    kdePackages.qtwayland

    # Wayland bar/menu
    mako
    pavucontrol

    base16-schemes

    nordic

    # Custom packages from inputs
    # zen-browser.packages.${pkgs.system}.default
    # helium-browser.packages.${pkgs.system}.default
    # helix.packages.${pkgs.system}.default
    # quickshell.packages.${pkgs.system}.default
  ];
in
basePackages
++ lib.optionals withGUI [
  # Additional GUI tools if needed
]
