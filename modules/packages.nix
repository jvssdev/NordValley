{
  pkgs,
  withGUI,
  helix,
  zen-browser,
}:

with pkgs;

let
  basePackages = [

    efibootmgr
    gcc
    gnumake
    cargo
    rustc
    wget
    unzip
    tree-sitter
    nodejs_22

    nerd-fonts.jetbrains-mono
    bibata-cursors

    font-awesome
    roboto
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

    yazi
    mpc
    mpd
    mpd-mpris
    playerctl
    rmpc
    hypridle
    wleave
    p7zip

    gtklock
    btop
    keepassxc
    anydesk
    lmstudio
    qbittorrent
    mpv
    gammastep
    wpaperd
    imv

    libgcc
    lxqt.lxqt-policykit
    libnotify
    ripgrep
    bat
    brightnessctl

    appimage-run
    playerctl
    nh

    grim
    slurp
    waybar
    fuzzel
    mako
    wl-clipboard
    pavucontrol
    libvirt
    qemu
    virt-viewer
    virt-manager
    spice
    spice-gtk
    spice-protocol
    OVMF
    zed-editor
    cliphist
    zed-editor
    fastfetch
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    archiver
    polkit
    mate.mate-polkit
    gvfs
    networkmanagerapplet

    libsForQt5.qt5.qtgraphicaleffectsr

    zen-browser.packages.${pkgs.system}.default
    helix.packages.${pkgs.system}.default
  ];
in
basePackages
++ pkgs.lib.optionals withGUI [
  # GUI tools
]
