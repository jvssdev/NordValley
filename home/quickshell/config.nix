{
  config,
  pkgs,
  lib,
  ...
}:

let
  p = config.colorScheme.palette;
in
{
  xdg.configFile."quickshell/shell.qml".text = ''
    import Quickshell
    import QtQuick

    Scope {
        // Propriedades de tema
        readonly property string themeBg: "#${p.base00}"
        readonly property string themeBgAlt: "#${p.base01}"
        readonly property string themeBgLighter: "#${p.base02}"
        readonly property string themeFg: "#${p.base05}"
        readonly property string themeFgMuted: "#${p.base04}"
        readonly property string themeFgSubtle: "#${p.base03}"
        readonly property string themeRed: "#${p.base08}"
        readonly property string themeGreen: "#${p.base0B}"
        readonly property string themeYellow: "#${p.base0A}"
        readonly property string themeBlue: "#${p.base0D}"
        readonly property string themeMagenta: "#${p.base0E}"
        readonly property string themeCyan: "#${p.base0C}"
        readonly property string themeOrange: "#${p.base09}"
        readonly property int themeRadius: 12
        readonly property int themeBorderWidth: 2
        readonly property int themePadding: 14
        readonly property int themeSpacing: 10
        readonly property string themeFontFamily: "JetBrains Nerd Font Mono"
        readonly property int themeFontSize: 14

        PanelWindow {
            anchors {
                top: true
                right: true
            }
            topMargin: 10
            rightMargin: 10
            width: 420
            height: 650

            Rectangle {
                anchors.fill: parent
                color: themeBg
                radius: themeRadius
                
                border.width: themeBorderWidth
                border.color: themeBlue

                Text {
                    anchors.centerIn: parent
                    text: "Quickshell Notification Center"
                    color: themeFg
                    font.family: themeFontFamily
                    font.pixelSize: 18
                }
            }
        }
    }
  '';

  home.packages = with pkgs; [
    (writeShellScriptBin "qs-write-status" ''
      #!/usr/bin/env bash
      printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$1" "$2" "$3" > /tmp/quickshell-notification-status.json
    '')

    (writeShellScriptBin "quickshell-notif-status" ''
      #!/usr/bin/env bash
      file=/tmp/quickshell-notification-status.json
      [[ -f "$file" ]] && cat "$file" || echo '{"text":"","tooltip":"No notifications","class":"none"}'
    '')

    (writeShellScriptBin "quickshell-notif-toggle" ''
      #!/usr/bin/env bash
      notify-send "Quickshell" "Notification panel"
    '')
  ];
}
