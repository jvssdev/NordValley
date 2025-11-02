{
  pkgs,
  config,
  specialArgs,
  lib,
  ...
}:

let
  inherit (specialArgs)
    withGUI
    homeDir
    userName
    helix
    zen-browser
    isRiver
    isMango
    ;
in
{
  imports = [ ./programs.nix ];

  home.username = userName;
  home.homeDirectory = homeDir;
  xdg.enable = true;
  home.stateVersion = "25.05";

  home.packages = pkgs.callPackage ./packages.nix { inherit withGUI helix; };

  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "/nix/var/nix/profiles/default/bin"
  ];

  home.sessionVariables = {
    EDITOR = "hx";
    TERMINAL = "ghostty";
    BROWSER = "${zen-browser}/bin/zen";
    DEFAULT_BROWSER = "${zen-browser}/bin/zen";
    XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
    LC_ALL = "en_US.UTF-8";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    NIXOS_OZONE_WL = "1";
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  home.file = {
    # For nix-shell
    ".config/nixpkgs/config.nix".text = ''
      {
        allowUnfree = true;
      }
    '';

    ".config/btop".source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/btop";

    ".config/lazygit".source =
      config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/lazygit";

    ".config/fastfetch".source =
      config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/fastfetch";

    ".config/wleave".source =
      config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/wleave";

    ".config/helix".source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/helix";

    ".config/fuzzel".source =
      config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/fuzzel";

    ".config/hypridle".source =
      config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/hypridle";

    ".config/waybar".source =
      config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/waybar";

    ".config/gtklock".source =
      config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/gtklock";

    ".config/mako".source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/mako";

    ".config/mpd".source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/mpd";

    ".config/wpaperd".source =
      config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/wpaperd";

    ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/yazi";

    ".config/zathura".source =
      config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/zathura";

    ".config/zed".source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/zed";

    ".config/ghostty".source =
      config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/ghostty";

    ".zen".source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/zen";
  }

  // lib.optionalAttrs (isRiver) {
    ".config/river".source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/river";
  }

  // lib.optionalAttrs (isMango) {
    ".config/mango".source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/NordValley/dotfiles/mango";
  };

  gtk = {
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
    iconTheme = {
      name = "Nordzy-dark";
      package = pkgs.nordzy-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "qt6ct";
  };

  fonts.fontconfig.enable = true;
}
