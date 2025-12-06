{
  config,
  pkgs,
  lib,
  ...
}:
let
  p = config.colorScheme.palette;

  shellQml = ''
    import QtQuick
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Io
    import "."

    ShellRoot {
        id: root

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
                family: "JetBrainsMono Nerd Font",
                pixelSize: 14,
                weight: Font.Medium
            })
        }

        WmDetector { id: wmDetector }

        QtObject { id: makoDnd; property bool isDnd: false }
        QtObject { id: btInfo; property bool connected: false }
        QtObject {
            id: volume
            property int level: 0
            property bool muted: false
        }
        
        QtObject {
            id: battery
            property int percentage: 0
            property string icon: "󰂎"
            property bool charging: false
            
            onPercentageChanged: {
                if (percentage === 0) icon = "󰁹"
                else if (percentage <= 10) icon = "󰂎"
                else if (percentage <= 30) icon = "󰁻"
                else if (percentage <= 50) icon = "󰁽"
                else if (percentage <= 70) icon = "󰁾"
                else if (percentage <= 90) icon = "󰂀"
                else icon = "󰂂"
            }
        }

        QtObject { id: cpu; property int usage: 0 }
        QtObject { id: mem; property int percent: 0 }
        QtObject { id: disk; property int percent: 0 }
        
        QtObject {
            id: activeWindow
            property string title: "No Window Focused"
        }

        Connections {
            target: Quickshell.Wayland
            function onActiveClientChanged() {
                activeWindow.title = Quickshell.Wayland.activeClient?.title || "No Window Focused"
            }
        }

        Process {
            id: makoProc
            command: ["makoctl", "mode"]
            onExited: {
                if (stdout) makoDnd.isDnd = stdout.trim() === "do-not-disturb"
            }
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: makoProc.running = true
        }

        Process {
            id: btProc
            command: ["bluetoothctl", "info"]
            onExited: {
                if (stdout) btInfo.connected = stdout.includes("Connected: yes")
            }
        }

        Timer {
            interval: 5000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: btProc.running = true
        }

        Process {
            id: volumeProc
            command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
            onExited: {
                if (!stdout) return
                const out = stdout.trim()
                volume.muted = out.includes("[MUTED]")
                const match = out.match(/Volume: ([0-9.]+)/)
                if (match) volume.level = Math.round(parseFloat(match[1]) * 100)
            }
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: volumeProc.running = true
        }

        Timer {
            interval: 10000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                batCapacityProc.running = true
                batStatusProc.running = true
            }
        }

        Process {
            id: batCapacityProc
            command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo 0"]
            onExited: {
                if (stdout) battery.percentage = parseInt(stdout.trim()) || 0
            }
        }

        Process {
            id: batStatusProc
            command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/status 2>/dev/null || echo Discharging"]
            onExited: {
                if (stdout) battery.charging = stdout.trim() === "Charging"
            }
        }

        Process {
            id: cpuProc
            command: ["top", "-bn1"]
            onExited: {
                if (!stdout) return
                const lines = stdout.split("\n")
                for (let line of lines) {
                    if (line.includes("%Cpu")) {
                        const parts = line.split(/\s+/)
                        cpu.usage = Math.round(100 - parseFloat(parts[7]))
                        break
                    }
                }
            }
        }

        Timer {
            interval: 2000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: cpuProc.running = true
        }

        Process {
            id: memProc
            command: ["free"]
            onExited: {
                if (!stdout) return
                const line = stdout.split("\n")[1] || ""
                const parts = line.split(/\s+/)
                const total = parseInt(parts[1]) || 1
                const used = parseInt(parts[2]) || 0
                mem.percent = Math.round(used / total * 100)
            }
        }

        Timer {
            interval: 2000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: memProc.running = true
        }

        Process {
            id: diskProc
            command: ["sh", "-c", "df / | tail -1"]
            onExited: {
                if (!stdout) return
                const line = stdout.split("\n")[0] || ""
                const parts = line.split(/\s+/)
                var percentStr = parts[4] || "0%"
                disk.percent = parseInt(percentStr.replace("%", "")) || 0
            }
        }

        Timer {
            interval: 10000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: diskProc.running = true
        }
        
        Bar {
            theme: theme
            wmDetector: wmDetector
            makoDnd: makoDnd
            btInfo: btInfo
            volume: volume
            battery: battery
            cpu: cpu
            mem: mem
            disk: disk
            activeWindow: activeWindow
        }
    }
  '';
in
{
  xdg.configFile."quickshell/shell.qml".text = shellQml;
  xdg.configFile."quickshell/bar.qml".source = ./bar.qml;
  xdg.configFile."quickshell/WmDetector.qml".source = ./WmDetector.qml;
  xdg.configFile."quickshell/WorkspacesRiver.qml".source = ./WorkspacesRiver.qml;
  xdg.configFile."quickshell/WorkspacesNiri.qml".source = ./WorkspacesNiri.qml;
  xdg.configFile."quickshell/WorkspacesDWL.qml".source = ./WorkspacesDWL.qml;
  xdg.configFile."quickshell/WorkspaceWidget.qml".source = ./WorkspaceWidget.qml;
}
