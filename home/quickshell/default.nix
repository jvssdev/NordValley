{
  config,
  pkgs,
  lib,
  ...
}:

let
  p = config.colorScheme.palette;

  themeObjectQml = ''
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
      readonly property var font: ({
        family: "FiraCode Nerd Font Mono",
        pixelSize: 14,
        weight: Font.Medium
      })
    }
  '';

  idleServiceQml = ''
    QtObject {
      id: idleService
      property int monitorTimeout: 240
      property int lockTimeout: 300
      property int suspendTimeout: 600
      property bool monitorsOff: false
      property bool locked: false
      Component.onCompleted: {
        if (typeof(IdleMonitor) === "undefined") {
          console.warn("IdleMonitor not available - power management disabled")
          return
        }
        const idleQml = \`
          import QtQuick
          import Quickshell.Wayland
          IdleMonitor {
            enabled: true
            respectInhibitors: true
            timeout: 0
          }
        \`
        var monOff = Qt.createQmlObject(idleQml, idleService)
        monOff.timeout = Qt.binding(() => idleService.monitorTimeout)
        monOff.isIdleChanged.connect(function() {
          if (monOff.isIdle && !idleService.monitorsOff) {
            idleService.monitorsOff = true
            CompositorService.powerOffMonitors()
          } else if (!monOff.isIdle && idleService.monitorsOff) {
            idleService.monitorsOff = false
            CompositorService.powerOnMonitors()
          }
        })
        var lockMon = Qt.createQmlObject(idleQml, idleService)
        lockMon.timeout = Qt.binding(() => idleService.lockTimeout)
        lockMon.isIdleChanged.connect(function() {
          if (lockMon.isIdle && !idleService.locked) {
            idleService.locked = true
            const lockCmd = \`
              import Quickshell.Io
              Command {
                command: "gtklock"
                args: ["-d"]
              }
            \`
            Qt.createQmlObject(lockCmd, idleService)
          } else if (!lockMon.isIdle) {
            idleService.locked = false
          }
        })
        var suspMon = Qt.createQmlObject(idleQml, idleService)
        suspMon.timeout = Qt.binding(() => idleService.suspendTimeout)
        suspMon.isIdleChanged.connect(function() {
          if (suspMon.isIdle) {
            const suspCmd = \`
              import Quickshell.Io
              Command {
                command: "systemctl"
                args: ["suspend"]
              }
            \`
            Qt.createQmlObject(suspCmd, idleService)
          }
        })
      }
    }
  '';

  shellContent = builtins.readFile ./shell.qml;
  shellLogic = themeObjectQml + "\n" + idleServiceQml;
  newShellQml = lib.strings.replaceStrings [ "ShellRoot {" ] [ "ShellRoot {\n" + lib.strings.indent 4 shellLogic ] shellContent;
  
  newShellQml = lib.strings.replaceStrings
  [ "ShellRoot {" ]
  [ ("ShellRoot {\n    " + builtins.replaceStrings ["\n"] ["\n    "] shellLogic) ]
  shellContent;

in
{
  xdg.configFile."quickshell/qmldir".text = ''
    Bar                     1.0 bar.qml
  '';

  xdg.configFile."quickshell/shell.qml".source = newShellQmlFile;
  xdg.configFile."quickshell/bar.qml".source = ./bar.qml;
}
