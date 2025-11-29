{
  config,
  pkgs,
  lib,
  ...
}:

let
  palette = config.colorScheme.palette;

  shellQml = pkgs.substituteAll {
    src = ./shell.qml.in;
    base00 = palette.base00;
  };

  notificationCenterQml = pkgs.substituteAll {
    src = ./NotificationCenter.qml.in;
    base00 = palette.base00;
    base01 = palette.base01;
    base02 = palette.base02;
    base03 = palette.base03;
    base04 = palette.base04;
    base05 = palette.base05;
    base08 = palette.base08;
    base0D = palette.base0D;
  };

in
{
  xdg.configFile."quickshell/qmldir".text = ''
    singleton NotificationService 1.0 NotificationService.qml
    singleton MprisService       1.0 MprisService.qml
  '';

  xdg.configFile."quickshell/shell.qml".source = shellQml;
  xdg.configFile."quickshell/NotificationCenter.qml".source = notificationCenterQml;

  xdg.configFile."quickshell/NotificationService.qml".text =
    builtins.readFile ./NotificationService.qml;
  xdg.configFile."quickshell/MprisService.qml".text = builtins.readFile ./MprisService.qml;

  home.packages = with pkgs; [
    (writeShellScriptBin "qs-write-status" ''
      #!/usr/bin/env bash
      printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$1" "$2" "$3" > /tmp/quickshell-notification-status.json
    '')

    (writeShellScriptBin "quickshell-notif-toggle" ''
      #!/usr/bin/env bash
      echo "toggle-$(date +%s%N)" > /tmp/quickshell-toggle-cmd
    '')

    (writeShellScriptBin "quickshell-notif-status" ''
      #!/usr/bin/env bash
      file=/tmp/quickshell-notification-status.json
      [[ -f "$file" ]] && cat "$file" || echo '{"text":"","tooltip":"No notifications","class":"none"}'
    '')

    (writeShellScriptBin "quickshell-notif-test" ''
      #!/usr/bin/env bash
      echo "=== Quickshell Notification Center Test ==="
      pgrep -a quickshell || echo "quickshell not running"
      quickshell-notif-status | jq .
      notify-send "Test" "Quickshell is perfect" -i notification
      sleep 1
      quickshell-notif-status | jq .
      quickshell-notif-toggle && echo "Toggled!"
    '')
  ];
}
