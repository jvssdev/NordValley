{
  config,
  pkgs,
  lib,
  ...
}:

let
  p = config.colorScheme.palette;

  themeQml = pkgs.writeText "Theme.qml" (
    builtins.concatStringsSep "\n" [
      "pragma Singleton"
      "import QtQuick"
      ""
      "QtObject {"
      "    readonly property color bg         : \"#${p.base00}\""
      "    readonly property color bgAlt      : \"#${p.base01}\""
      "    readonly property color bgLighter  : \"#${p.base02}\""
      ""
      "    readonly property color fg         : \"#${p.base05}\""
      "    readonly property color fgMuted    : \"#${p.base04}\""
      "    readonly property color fgSubtle   : \"#${p.base03}\""
      ""
      "    readonly property color red        : \"#${p.base08}\""
      "    readonly property color green      : \"#${p.base0B}\""
      "    readonly property color yellow     : \"#${p.base0A}\""
      "    readonly property color blue       : \"#${p.base0D}\""
      "    readonly property color magenta    : \"#${p.base0E}\""
      "    readonly property color cyan       : \"#${p.base0C}\""
      "    readonly property color orange     : \"#${p.base09}\""
      ""
      "    readonly property int radius       : 12"
      "    readonly property int borderWidth  : 2"
      "    readonly property int padding      : 14"
      "    readonly property int spacing      : 10"
      ""
      "    readonly property font font : Qt.font({"
      "        family: \"FiraCode Nerd Font Mono\","
      "        pixelSize: 14,"
      "        weight: Font.Medium"
      "    })"
      "}"
    ]
  );

in
{
  xdg.configFile."quickshell/qmldir".text = ''
    singleton Theme               1.0 Theme.qml
    singleton NotificationService 1.0 NotificationService.qml
    singleton MprisService       1.0 MprisService.qml
  '';

  xdg.configFile."quickshell/Theme.qml".source = themeQml;

  xdg.configFile."quickshell/shell.qml".source = ./shell.qml;
  xdg.configFile."quickshell/NotificationCenter.qml".source = ./NotificationCenter.qml;
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
      echo "Process:"
      pgrep -a quickshell || echo "not running"
      echo "Status:"
      quickshell-notif-status | jq .
      echo "Sending test notification..."
      notify-send "Test" "Notification center is working correctly"
      sleep 1
      echo "Updated status:"
      quickshell-notif-status | jq .
      echo "Toggling panel..."
      quickshell-notif-toggle
      echo "Panel toggled"
    '')
  ];
}
