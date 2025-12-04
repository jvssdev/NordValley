{
  pkgs,
  ...
}:
{
  imports = [
    ./bar.nix
  ];

  home.packages = with pkgs; [
    wlopm
    gtklock
  ];
}
