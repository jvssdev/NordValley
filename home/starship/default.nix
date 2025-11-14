{ config, pkgs, ... }:

let
  c = config.stylix.colors;
in
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    settings = {
      add_newline = true;

      format = ''
        [░▒▓](#${c.base03})\
        [ ](bg:#${c.base03} fg:#${c.base07})\
        [powerline right](bg:#${c.base0B} fg:#${c.base03})\
        $directory\
        [powerline right](fg:#${c.base0B} bg:#${c.base01})\
        $git_branch\
        $git_status\
        [powerline right](fg:#${c.base01} bg:#${c.base02})\
        $nodejs\
        $rust\
        $golang\
        $php\
        [powerline right](fg:#${c.base02} bg:#${c.base03})\
        $time\
        [powerline right](fg:#${c.base03})\
        \n$character
      '';

      directory = {
        style = "fg:#${c.base03} bg:#${c.base0B}";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          Documents = "Documents ";
          Downloads = "Downloads ";
          Music = "Music ";
          Pictures = "Pictures ";
        };
      };

      git_branch = {
        symbol = "branch";
        style = "bg:#${c.base01}";
        format = "[[ $symbol $branch ](fg:#${c.base04} bg:#${c.base01})]($style)";
      };

      git_status = {
        style = "bg:#${c.base01}";
        format = "[[($all_status$ahead_behind )](fg:#${c.base04} bg:#${c.base01})]($style)";
      };

      nodejs = {
        symbol = "node";
        style = "bg:#${c.base02}";
        format = "[[ $symbol ($version) ](fg:#${c.base0B} bg:#${c.base02})]($style)";
      };

      rust = {
        symbol = "rust";
        style = "bg:#${c.base02}";
        format = "[[ $symbol ($version) ](fg:#${c.base09} bg:#${c.base02})]($style)";
      };

      golang = {
        symbol = "go";
        style = "bg:#${c.base02}";
        format = "[[ $symbol ($version) ](fg:#${c.base0C} bg:#${c.base02})]($style)";
      };

      php = {
        symbol = "php";
        style = "bg:#${c.base02}";
        format = "[[ $symbol ($version) ](fg:#${c.base0E} bg:#${c.base02})]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#${c.base03}";
        format = "[[ time $time ](fg:#${c.base04} bg:#${c.base03})]($style)";
      };
    };
  };
}
