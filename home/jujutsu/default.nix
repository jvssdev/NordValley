{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jujutsu
    jjui
  ];

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "joao.victor.ss.dev@gmail.com";
        name = "jvssdev";
      };
      ui = {
        "default-command" = "status";
        pager = "delta";
        paginate = "auto";
        "diff-formatter" = ":git";
        editor = "hx";
      };
      git = {
        "auto-local-bookmark" = true;
      };
    };
  };
}
