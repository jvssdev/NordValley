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
  xdg.configFile."quickshell/IdleService.qml".text = ''
    import QtQuick
    import Quickshell.Wayland
    import Quickshell.Io

    QtObject {
      id: root
      
      property int monitorTimeout: 240
      property int lockTimeout: 300
      property int suspendTimeout: 600
      property bool monitorsOff: false
      property bool locked: false

      property var monitorOffTimer: null
      property var lockTimer: null
      property var suspendTimer: null

      Component.onCompleted: {
        if (typeof(IdleMonitor) === "undefined") {
          console.warn("IdleMonitor not available - power management disabled")
          return
        }

        monitorOffTimer = Qt.createQmlObject(`
          import QtQuick
          import Quickshell.Wayland
          IdleMonitor {
            enabled: true
            respectInhibitors: true
            timeout: ${monitorTimeout}
          }
        `, root)
        
        monitorOffTimer.isIdleChanged.connect(function() {
          if (monitorOffTimer.isIdle && !root.monitorsOff) {
            root.monitorsOff = true
            Qt.createQmlObject('import Quickshell.Io; Process { command: ["wlopm", "--off", "*"]; running: true }', root)
          } else if (!monitorOffTimer.isIdle && root.monitorsOff) {
            root.monitorsOff = false
            Qt.createQmlObject('import Quickshell.Io; Process { command: ["wlopm", "--on", "*"]; running: true }', root)
          }
        })

        lockTimer = Qt.createQmlObject(`
          import QtQuick
          import Quickshell.Wayland
          IdleMonitor {
            enabled: true
            respectInhibitors: true
            timeout: ${lockTimeout}
          }
        `, root)
        
        lockTimer.isIdleChanged.connect(function() {
          if (lockTimer.isIdle && !root.locked) {
            root.locked = true
            Qt.createQmlObject('import Quickshell.Io; Process { command: ["gtklock", "-d"]; running: true }', root)
          } else if (!lockTimer.isIdle) {
            root.locked = false
          }
        })

        suspendTimer = Qt.createQmlObject(`
          import QtQuick
          import Quickshell.Wayland
          IdleMonitor {
            enabled: true
            respectInhibitors: true
            timeout: ${suspendTimeout}
          }
        `, root)
        
        suspendTimer.isIdleChanged.connect(function() {
          if (suspendTimer.isIdle) {
            Qt.createQmlObject('import Quickshell.Io; Process { command: ["systemctl", "suspend"]; running: true }', root)
          }
        })
      }
    }
  '';
}
