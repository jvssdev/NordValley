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
    import Quickshell.Wayland
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
        readonly property string fontFamily: "JetBrainsMono Nerd Font"
        readonly property int fontSize: 14
      }

      QtObject {
        id: idleService
        
        property int monitorTimeout: 240000  // 4 min
        property int lockTimeout:    300000  // 5 min
        property int suspendTimeout: 600000  // 10 min
        
        property bool monitorsOff: false
        property bool locked: false
        
        Component.onCompleted: {
          console.log("IdleService started")
          console.log("Monitor off → " + (monitorTimeout / 60000) + " min")
          console.log("Lock       → " + (lockTimeout / 60000) + " min")
          console.log("Suspend    → " + (suspendTimeout / 60000) + " min")
        }
      }

      IdleMonitor {
        id: monitorOffMonitor
        enabled: true
        respectInhibitors: true
        timeout: idleService.monitorTimeout

        onIsIdleChanged: if (isIdle && !idleService.monitorsOff) {
          console.log("Turning off monitors...")
          idleService.monitorsOff = true
          Process.execute("wlopm", ["--off", "*"])
        } else if (!isIdle && idleService.monitorsOff) {
          console.log("Turning on monitors...")
          idleService.monitorsOff = false
          Process.execute("wlopm", ["--on", "*"])
        }
      }

      IdleMonitor {
        id: lockMonitor
        enabled: true
        respectInhibitors: true
        timeout: idleService.lockTimeout

        onIsIdleChanged: if (isIdle && !idleService.locked) {
          console.log("Locking with gtklock...")
          idleService.locked = true
          Process.execute("gtklock", ["-d"])  // -d = daemon mode
        } else if (!isIdle) {
          idleService.locked = false
        }
      }

      IdleMonitor {
        id: suspendMonitor
        enabled: true
        respectInhibitors: true
        timeout: idleService.suspendTimeout

        onIsIdleChanged: if (isIdle) {
          console.log("Suspending system...")
          Process.execute("systemctl", ["suspend"])
        }
      }
    }
  '';
}
