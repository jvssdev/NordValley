{
  pkgs,
  specialArgs,
  ...
}:
let
  inherit (specialArgs)
    # helium-browser
    quickshell
    ;
in
with pkgs;
let
  basePackages = [
    neovim-unwrapped

    # Media
    mpc
    playerctl
    pamixer

    # Wayland tools
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
    wlopm

    # Cloud/Sync tools
    # rclone
    # rclone-ui

    # GUI applications
    brave
    keepassxc
    anydesk
    # llama-cpp
    # (llama-cpp.override { vulkanSupport = true; })
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
    kdePackages.qt6ct
    qt6.qtwayland
    kdePackages.qtwayland

    # Wayland bar/menu
    dunst
    pavucontrol

    # helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
in
basePackages
