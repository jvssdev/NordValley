{ pkgs, ... }:

let
  fuzzel-clipboard = pkgs.writeShellScriptBin "fuzzel-clipboard" ''
    #!/usr/bin/env bash

    ${pkgs.cliphist}/bin/cliphist list | tac | ${pkgs.fuzzel}/bin/fuzzel --dmenu \
      --prompt "󱉥  " \
      -l 25 -w 70 \
      --border-width=2 --border-radius=10 \
      | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy
  '';

  fuzzel-clipboard-clear = pkgs.writeShellScriptBin "fuzzel-clipboard-clear" ''
    #!/usr/bin/env bash

    ${pkgs.cliphist}/bin/cliphist wipe && \
    ${pkgs.libnotify}/bin/notify-send "󰩺 Clipboard cleaned" -t 1500
  '';
in
{
  home.packages = [
    fuzzel-clipboard
    fuzzel-clipboard-clear
    pkgs.wl-clip-persist
    pkgs.cliphist
  ];
}
