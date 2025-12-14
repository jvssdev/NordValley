{ pkgs, lib, ... }:
let
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    dir="$HOME/Pictures/Screenshots"
    mkdir -p "$dir"
    file="$dir/$(date +'%Y-%m-%d_%H-%M-%S').png"
    ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" "$file"
    ${lib.getExe' pkgs.wl-clipboard "wl-copy"} < "$file"
    ${lib.getExe' pkgs.libnotify "notify-send"} "Screenshot saved" -i "$file" -t 3000
  '';
in
{
  home.packages = [
    screenshot
    pkgs.grim
    pkgs.slurp
  ];
}
