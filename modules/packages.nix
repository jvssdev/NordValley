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
    fastfetch
    nixos-shell
    nix-your-shell
    yazi
    yaziPlugins.nord
    yaziPlugins.starship
    bat
    starship
    lsd
    ffmpeg

    # Media
    mpc
    playerctl

    # Wayland tools
    wleave
    gtklock
    wlopm
    wpaperd
    gammastep

    # System utilities
    p7zip
    btop
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

    # File manager
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    gvfs

    # Polkit
    polkit
    mate.mate-polkit

    # Network
    networkmanagerapplet

    # Qt
    libsForQt5.qt5.qtgraphicaleffects

    # Wayland bar/menu
    waybar
    fuzzel
    mako
    pavucontrol

    base16-schemes

    nordic.sddm

    # Editor
    zed-editor

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
