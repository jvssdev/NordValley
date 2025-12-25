{
  pkgs,
  specialArgs,
  ...
}: let
  inherit
    (specialArgs)
    helium-browser
    quickshell
    ;
in
  with pkgs; let
    basePackages = [
      # Build essentials
      gcc
      gnumake
      cargo
      rustc
      wget
      unzip
      tree-sitter
      nodejs_22

      neovim-unwrapped

      bibata-cursors

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
      atuin

      bat
      starship
      lsd
      ffmpeg

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

      # zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      # helix.packages.${pkgs.stdenv.hostPlatform.system}.default
      quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  in
    basePackages
