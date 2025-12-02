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
        readonly property string fontFamily: "JetBrainsMono Nerd Font"
        readonly property int fontSize: 14
      }

      QtObject {
        id: idleService
        property int monitorTimeout: 240
        property int lockTimeout: 300
        property int suspendTimeout: 600
        property bool monitorsOff: false
        property bool locked: false
      }

      IdleMonitor {
        timeout: idleService.monitorTimeout
        respectInhibitors: true
        onIsIdleChanged: {
          if (isIdle && !idleService.monitorsOff) {
            console.log("Turning off monitors")
            idleService.monitorsOff = true
            Process.execute("wlopm", ["--off", "*"])
          } else if (!isIdle && idleService.monitorsOff) {
            console.log("Turning on monitors")
            idleService.monitorsOff = false
            Process.execute("wlopm", ["--on", "*"])
          }
        }
      }

      IdleMonitor {
        timeout: idleService.lockTimeout
        respectInhibitors: true
        onIsIdleChanged: {
          if (isIdle && !idleService.locked) {
            console.log("Locking screen with gtklock")
            idleService.locked = true
            Io.command("gtklock -d")
          } else if (!isIdle) {
            idleService.locked = false
          }
        }
      }

      IdleMonitor {
        timeout: idleService.suspendTimeout
        respectInhibitors: true
        onIsIdleChanged: {
          if (isIdle) {
            console.log("Suspending system")
            Process.execute("systemctl", ["suspend"])
          }
        }
      }
    }
  '';
}
