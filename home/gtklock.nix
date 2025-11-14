{ config, pkgs, ... }:

let
  c = config.stylix.colors;
in
{
  programs.gtklock = {
    enable = true;

    config = {
      main = {
        gtk-theme = "Nordic";
        idle-hide = true;
        start-hidden = true;
        modules = "userinfo-module";
      };
      userinfo = {
        round-image = true;
        horizontal-layout = false;
        under-clock = true;
      };
    };

    style = ''
      window {
        background-color: #${c.base00};
        background-image: url("${config.stylix.image}");
        background-size: cover;
        background-repeat: no-repeat;
        background-position: center;
      }

      #clock-label {
        color: #${c.base06};
      }

      #input-label {
        font-size: 0;
      }

      window#eDP-1 #input-field {
        margin-top: 32em;
      }

      #unlock-button {
        color: rgba(${c.base00_rgb_r}, ${c.base00_rgb_g}, ${c.base00_rgb_b}, 0.87);
      }
    '';
  };

  home.packages = [ pkgs.gtklock ];
}
