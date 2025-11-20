{ config, pkgs, ... }:

let
  c = config.colorScheme.palette;
in
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    settings = {
      add_newline = true;

      format = ''
        [░▒▓](#${c.base03})[ ](bg:#${c.base03} fg:#${c.base06})[](bg:#${c.base07} fg:#${c.base03})$directory[](fg:#${c.base07} bg:#${c.base01})$git_branch$git_status[](fg:#${c.base01} bg:#${c.base02})$nodejs$rust$golang$php[](fg:#${c.base02} bg:#${c.base03})$time[](fg:#${c.base03})
        $character
      '';

      directory = {
        style = "fg:#${c.base03} bg:#${c.base07}";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          Documents = "󰈙 ";
          Downloads = " ";
          Music = " ";
          Pictures = " ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:#${c.base01}";
        format = "[[ $symbol $branch ](fg:#${c.base04} bg:#${c.base01})]($style)";
      };

      git_status = {
        style = "bg:#${c.base01}";
        format = "[[($all_status$ahead_behind )](fg:#${c.base04} bg:#${c.base01})]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#${c.base02}";
        format = "[[ $symbol ($version) ](fg:#${c.base0B} bg:#${c.base02})]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#${c.base02}";
        format = "[[ $symbol ($version) ](fg:#${c.base09} bg:#${c.base02})]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:#${c.base02}";
        format = "[[ $symbol ($version) ](fg:#${c.base0C} bg:#${c.base02})]($style)";
      };

      php = {
        symbol = "";
        style = "bg:#${c.base02}";
        format = "[[ $symbol ($version) ](fg:#${c.base0E} bg:#${c.base02})]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#${c.base03}";
        format = "[[  $time ](fg:#${c.base04} bg:#${c.base03})]($style)";
      };
    };
  };
}
