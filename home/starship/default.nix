{ config, ... }:
let
  inherit (config.colorScheme) palette;
in
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;

      format = ''
        [░▒▓](#${palette.base03})[ ](bg:#${palette.base03} fg:#${palette.base06})[](bg:#${palette.base0D} fg:#${palette.base03})$directory[](fg:#${palette.base0D} bg:#${palette.base01})$git_branch$git_status[](fg:#${palette.base01} bg:#${palette.base02})$nodejs$rust$golang$php[](fg:#${palette.base02} bg:#${palette.base03})$time[](fg:#${palette.base03})
        $character
      '';

      directory = {
        style = "fg:#${palette.base03} bg:#${palette.base0D}";
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
        style = "bg:#${palette.base01}";
        format = "[[ $symbol $branch ](fg:#${palette.base04} bg:#${palette.base01})]($style)";
      };

      git_status = {
        style = "bg:#${palette.base01}";
        format = "[[($all_status$ahead_behind )](fg:#${palette.base04} bg:#${palette.base01})]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#${palette.base02}";
        format = "[[ $symbol ($version) ](fg:#${palette.base0B} bg:#${palette.base02})]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#${palette.base02}";
        format = "[[ $symbol ($version) ](fg:#${palette.base09} bg:#${palette.base02})]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:#${palette.base02}";
        format = "[[ $symbol ($version) ](fg:#${palette.base0C} bg:#${palette.base02})]($style)";
      };

      php = {
        symbol = "";
        style = "bg:#${palette.base02}";
        format = "[[ $symbol ($version) ](fg:#${palette.base0E} bg:#${palette.base02})]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#${palette.base03}";
        format = "[[  $time ](fg:#${palette.base04} bg:#${palette.base03})]($style)";
      };
    };
  };
}
