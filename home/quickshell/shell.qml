import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
ShellRoot {
    id: root
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
        property string title: Quickshell.Wayland.activeClient.title || "No Window Focused"
        Connections {
            target: Quickshell.Wayland.activeClient
            onTitleChanged: activeWindow.title = title || "No Window Focused"
        }
    }
    Process {
        id: makoProc
        command: ["makoctl", "mode"]
        onExited: makoDnd.isDnd = stdout.trim() === "do-not-disturb"
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
        onExited: btInfo.connected = stdout.includes("Connected: yes")
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
        onExited: battery.percentage = parseInt(stdout.trim()) || 0
    }
    Process {
        id: batStatusProc
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/status 2>/dev/null || echo Discharging"]
        onExited: battery.charging = stdout.trim() === "Charging"
    }
    Process {
        id: cpuProc
        command: ["top", "-bn1"]
        onExited: {
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
        command: ["sh", "-c", "free | grep Mem"]
        onExited: {
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
