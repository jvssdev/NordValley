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
    import Quickshell.Services.Notifications
    import Quickshell.Services.Mpris

    ShellRoot {
      QtObject {
        id: Theme
        readonly property string bg: "#${p.base00}"
        readonly property string bgAlt: "#${p.base01}"
        readonly property string bgLighter: "#${p.base02}"
        readonly property string fg: "#${p.base05}"
        readonly property string fgMuted: "#${p.base04}"
        readonly property string fgSubtle: "#${p.base03}"
        readonly property string red: "#${p.base08}"
        readonly property string green: "#${p.base0B}"
        readonly property string yellow: "#${p.base0A}"
        readonly property string blue: "#${p.base0D}"
        readonly property string magenta: "#${p.base0E}"
        readonly property string cyan: "#${p.base0C}"
        readonly property string orange: "#${p.base09}"
        readonly property int radius: 12
        readonly property int borderWidth: 2
        readonly property int padding: 14
        readonly property int spacing: 10
        readonly property string fontFamily: "JetBrains Nerd Font Mono"
        readonly property int fontSize: 14
      }

      NotificationService {}
      MprisService {}

      PanelWindow {
        anchors {
          top: true
          right: true
          margins: 10
        }
        width: 420
        height: 650
        color: Theme.bg

        NotificationCenter {
          anchors.fill: parent
        }
      }

      Component.onCompleted: NotificationService.updateStatusFile()
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
  ];
}
