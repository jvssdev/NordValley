{
  pkgs,
  ...
}:
{
  imports = [
    ./idle.nix
    ./bar.nix
  ];

  home.packages = with pkgs; [
    wlopm
    gtklock
  ];
}
