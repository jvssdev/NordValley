{
  environment = {
    variables = {
      EDITOR = "nvim";
      XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = "24";
    };

    sessionVariables = {
      TERMINAL = "ghostty";
      BROWSER = "brave";
      DEFAULT_BROWSER = "brave";

      XDG_SCREENSHOTS_DIR = "$HOME/Pictures/Screenshots";
      XDG_SESSION_TYPE = "wayland";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";

      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";

      QT_QPA_PLATFORMTHEME = "qt6ct";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";

      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";

      GDK_BACKEND = "wayland";
      CLUTTER_BACKEND = "wayland";

      ELECTRON_OZONE_PLATFORM_HINT = "auto";

      XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = "24";
    };

    pathsToLink = [
      "/share/zsh"
      "/share/bash"
    ];
  };
}
