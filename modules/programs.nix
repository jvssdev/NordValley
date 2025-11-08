{ pkgs, specialArgs, ... }:

let
  inherit (specialArgs)
    userName
    fullName
    userEmail
    withGUI
    ;
in
{
  # imports = [ ./zsh.nix ];
  programs = {
    home-manager.enable = true;
    git = {
      settings = {
        user = {
          name = fullName;
          email = userEmail;
        };
      };
      enable = true;
      ignores = [
        ".envrc"
        ".direnv/"
      ];
    };

    starship = {
      enable = true;
      settings = pkgs.lib.importTOML ../dotfiles/starship.toml;
    };

    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    atuin = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
