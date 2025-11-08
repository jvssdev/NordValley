{
  pkgs,
  withGUI ? true,
  helix,
  zen-browser,
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

    # Fonts
    nerd-fonts.jetbrains-mono
    bibata-cursors
    font-awesome
    roboto

    # LSP servers
    markdown-oxide
    mpls
    deno
    zig
    zls
    go
    gopls
    nixd
    nil
    nixfmt-rfc-style
    nixpkgs-fmt

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
    ffmpeg

    # Media
    mpc-cli
    mpd
    mpd-mpris
    playerctl
    rmpc

    # Wayland tools
    hypridle
    wleave
    gtklock
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

    # Editors
    zed-editor

    # Custom packages from inputs
    zen-browser.packages.${pkgs.system}.default
    helix.packages.${pkgs.system}.default
  ];
in
basePackages
++ lib.optionals withGUI [
  # Additional GUI tools if needed
]
