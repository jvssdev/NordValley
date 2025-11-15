{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
let
  stylix = specialArgs.stylix;
in
{
  imports = [
    stylix.homeManagerModules.stylix
  ];

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    polarity = "dark";
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
    };
    targets = {
      qt.enable = true;
      gtk.enable = true;
      btop.enable = true;
      bat.enable = true;
      mako.enable = true;
      mpv.enable = true;
      grub.enable = true;
      helix.enable = false;
      fuzzel.enable = true;
      ghostty.enable = true;
      chromium.enable = true;
      lazygit.enable = true;
      wpaperd.enable = false;
      waybar.enable = false;
      zed.enable = false;
    };
  };
}
