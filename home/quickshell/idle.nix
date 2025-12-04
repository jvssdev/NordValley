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
  xdg.configFile."quickshell/idle.qml".text = ''
    import QtQuick
    import Quickshell.Wayland
    import Quickshell.Io

    component IdleService: QtObject {
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

        const idleQml = `
          import QtQuick
          import Quickshell.Wayland
          IdleMonitor {
            enabled: true
            respectInhibitors: true
            timeout: 0
          }
        `

        var monOff = Qt.createQmlObject(idleQml, this)
        monOff.timeout = Qt.binding(() => monitorTimeout)
        monOff.isIdleChanged.connect(() => {
          if (monOff.isIdle && !monitorsOff) {
            monitorsOff = true
            CompositorService.powerOffMonitors()
          } else if (!monOff.isIdle && monitorsOff) {
            monitorsOff = false
            CompositorService.powerOnMonitors()
          }
        })

        var lockMon = Qt.createQmlObject(idleQml, this)
        lockMon.timeout = Qt.binding(() => lockTimeout)
        lockMon.isIdleChanged.connect(() => {
          if (lockMon.isIdle && !locked) {
            locked = true
            Qt.createQmlObject('import Quickshell.Io; Command { command: "gtklock"; args: ["-d"] }', this)
          } else if (!lockMon.isIdle) {
            locked = false
          }
        })

        var suspMon = Qt.createQmlObject(idleQml, this)
        suspMon.timeout = Qt.binding(() => suspendTimeout)
        suspMon.isIdleChanged.connect(() => {
          if (suspMon.isIdle) {
            Qt.createQmlObject('import Quickshell.Io; Command { command: "systemctl"; args: ["suspend"] }', this)
          }
        })
      }
    }
  '';
}
