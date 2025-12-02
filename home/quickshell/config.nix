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
    import Quickshell.Io
    import QtQuick

    ShellRoot {
      QtObject {
        id: theme
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
      IdleService {}

      PanelWindow {
        id: panel
        visible: false
        anchors.top: true
        anchors.right: true
        anchors.topMargin: 35
        anchors.rightMargin: 10
        width: 420
        height: 650
        color: theme.bg
        radius: theme.radius
        border.width: theme.borderWidth
        border.color: theme.blue

        NotificationCenter {
          anchors.fill: parent
          theme: theme
          panel: panel
        }
      }

      Watcher {
        path: "/tmp/quickshell-toggle-cmd"
        triggers: Watcher.Created | Watcher.Modified
        onTriggered: panel.visible = !panel.visible
      }    
    }
  '';
}
