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

    ShellRoot {
        id: root

        QtObject {
            id: wmDetector

            readonly property int typeUnknown: 0
            readonly property int typeRiver: 1
            readonly property int typeNiri: 2
            readonly property int typeMangoWC: 3
            readonly property int typeDWL: 4

            property int detectedWm: typeUnknown
            property string wmName: "Unknown"
            property bool isDetecting: true

            signal wmDetected(int wmType, string name)

            Component.onCompleted: detectWm()

            function detectWm() {
                isDetecting = true
                wmDetectionProc.running = true
            }

            Process {
                id: wmDetectionProc
                command: ["sh", "-c", "echo $XDG_CURRENT_DESKTOP; pgrep -x river && echo river; pgrep -x niri && echo niri; pgrep -x mangowc && echo mangowc; pgrep -x dwl && echo dwl"]
                
                onExited: {
                    if (!stdout) {
                        console.log("WM Detection: Failed to detect")
                        isDetecting = false
                        return
                    }

                    const output = stdout.toLowerCase().trim()
                    
                    if (output.includes("river")) {
                        detectedWm = typeRiver
                        wmName = "River"
                    } else if (output.includes("niri")) {
                        detectedWm = typeNiri
                        wmName = "Niri"
                    } else if (output.includes("mangowc")) {
                        detectedWm = typeMangoWC
                        wmName = "MangoWC"
                    } else if (output.includes("dwl")) {
                        detectedWm = typeDWL
                        wmName = "DWL"
                    } else {
                        detectedWm = typeUnknown
                        wmName = "Unknown"
                    }

                    console.log("WM Detection: Detected", wmName)
                    isDetecting = false
                    wmDetected(detectedWm, wmName)
                }
            }

            function isRiver() { return detectedWm === typeRiver }
            function isNiri() { return detectedWm === typeNiri }
            function isMangoWC() { return detectedWm === typeMangoWC }
            function isDWL() { return detectedWm === typeDWL }
            function isSupported() { return detectedWm !== typeUnknown }
        }

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
        
        Variants {
            id: barVariants
            model: Quickshell.screens

            PanelWindow {
                property var theme: root.theme
                property var wmDetector: root.wmDetector
                property var makoDnd: root.makoDnd
                property var btInfo: root.btInfo
                property var volume: root.volume
                property var battery: root.battery
                property var cpu: root.cpu
                property var mem: root.mem
                property var disk: root.disk
                property var activeWindow: root.activeWindow

                anchors.top: true
                anchors.left: true
                anchors.right: true
                height: 30
                color: theme.bg

                Process { id: pavuProcess; command: ["pavucontrol"] }
                Process { id: bluemanProcess; command: ["blueman-manager"] }
                Process { id: makoDndProcess; command: ["sh", "-c", "makoctl mode | grep -q do-not-disturb && makoctl mode -r do-not-disturb || makoctl mode -a do-not-disturb"] }
                Process { id: wlogoutProcess; command: ["wlogout"] }

                Rectangle {
                    anchors.fill: parent
                    color: theme.bg

                    RowLayout {
                        anchors.fill: parent
                        spacing: theme.spacing / 2

                        Item { width: theme.padding / 2 }

                        Text {
                            text: "~"
                            color: theme.magenta
                            font {
                                family: theme.font.family
                                pixelSize: 18
                                bold: true
                            }
                        }

                        Item { width: theme.spacing }

                        RowLayout {
                            id: workspaceWidget
                            spacing: theme.spacing / 2
                            Layout.leftMargin: theme.spacing

                            property QtObject workspaceManager: null

                            Connections {
                                target: wmDetector
                                function onWmDetected() {
                                    workspaceWidget.setupWorkspaces()
                                }
                            }

                            Component.onCompleted: {
                                if (wmDetector.isSupported() && !wmDetector.isDetecting) {
                                    setupWorkspaces()
                                }
                            }

                            function setupWorkspaces() {
                                if (wmDetector.isRiver()) {
                                    if (!riverWorkspaces.active) riverWorkspaces.active = true
                                } else if (wmDetector.isNiri()) {
                                    if (!niriWorkspaces.active) niriWorkspaces.active = true
                                } else if (wmDetector.isMangoWC() || wmDetector.isDWL()) {
                                    if (!dwlWorkspaces.active) dwlWorkspaces.active = true
                                }
                            }

                            Loader {
                                id: riverWorkspaces
                                active: false
                                sourceComponent: Component {
                                    QtObject {
                                        id: riverWs
                                        
                                        property int activeTag: 0
                                        property var occupiedTags: []
                                        property int maxTags: 9

                                        signal tagChanged(int tag)

                                        Component.onCompleted: {
                                            workspaceWidget.workspaceManager = riverWs
                                            updateTags()
                                        }

                                        function updateTags() {
                                            tagQueryProc.running = true
                                        }

                                        function switchToTag(tagIndex) {
                                            if (tagIndex < 1 || tagIndex > maxTags) return
                                            switchTagProc.command = ["riverctl", "set-focused-tags", (1 << (tagIndex - 1)).toString()]
                                            switchTagProc.running = true
                                        }

                                        Process {
                                            id: tagQueryProc
                                            command: ["sh", "-c", "riverctl list-outputs 2>/dev/null | head -1"]
                                            
                                            onExited: {
                                                if (!stdout) return
                                                activeTagProc.running = true
                                                occupiedTagsProc.running = true
                                            }
                                        }

                                        Process {
                                            id: activeTagProc
                                            command: ["sh", "-c", "riverctl list-outputs 2>/dev/null | head -1"]
                                            
                                            onExited: {
                                                if (!stdout) return
                                                const lines = stdout.split("\n")
                                                for (let line of lines) {
                                                    if (line.includes("Focused tags:")) {
                                                        const match = line.match(/Focused tags: (\d+)/)
                                                        if (match) {
                                                            const tagBits = parseInt(match[1])
                                                            for (let i = 0; i < maxTags; i++) {
                                                                if (tagBits & (1 << i)) {
                                                                    activeTag = i + 1
                                                                    break
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        Process {
                                            id: occupiedTagsProc
                                            command: ["sh", "-c", "riverctl list-outputs 2>/dev/null"]
                                            
                                            onExited: {
                                                if (!stdout) return
                                                let occupied = []
                                                const lines = stdout.split("\n")
                                                for (let line of lines) {
                                                    if (line.includes("Occupied tags:")) {
                                                        const match = line.match(/Occupied tags: (\d+)/)
                                                        if (match) {
                                                            const tagBits = parseInt(match[1])
                                                            for (let i = 0; i < maxTags; i++) {
                                                                if (tagBits & (1 << i)) {
                                                                    occupied.push(i + 1)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                occupiedTags = occupied
                                            }
                                        }

                                        Process {
                                            id: switchTagProc
                                            command: []
                                            onExited: { updateTags() }
                                        }

                                        Timer {
                                            interval: 1000
                                            running: true
                                            repeat: true
                                            onTriggered: riverWs.updateTags()
                                        }
                                    }
                                }
                            }

                            Loader {
                                id: niriWorkspaces
                                active: false
                                sourceComponent: Component {
                                    QtObject {
                                        id: niriWs
                                        
                                        property int activeWorkspace: 1
                                        property var workspaces: []

                                        signal workspaceChanged(int workspace)

                                        Component.onCompleted: {
                                            workspaceWidget.workspaceManager = niriWs
                                            updateWorkspaces()
                                        }

                                        function updateWorkspaces() {
                                            workspaceQueryProc.running = true
                                        }

                                        function switchToWorkspace(index) {
                                            if (index < 1) return
                                            switchWorkspaceProc.command = ["niri", "msg", "action", "focus-workspace", index.toString()]
                                            switchWorkspaceProc.running = true
                                        }

                                        Process {
                                            id: workspaceQueryProc
                                            command: ["niri", "msg", "--json", "workspaces"]
                                            
                                            onExited: {
                                                if (!stdout) return
                                                try {
                                                    const data = JSON.parse(stdout)
                                                    let wsList = []
                                                    let activeIdx = 1
                                                    
                                                    if (Array.isArray(data)) {
                                                        for (let i = 0; i < data.length; i++) {
                                                            const ws = data[i]
                                                            wsList.push({
                                                                id: ws.id || (i + 1),
                                                                name: ws.name || String(i + 1),
                                                                output: ws.output || "",
                                                                isActive: ws.is_active || false,
                                                                isEmpty: !ws.has_windows
                                                            })
                                                            if (ws.is_active) {
                                                                activeIdx = ws.id || (i + 1)
                                                            }
                                                        }
                                                    }
                                                    workspaces = wsList
                                                    activeWorkspace = activeIdx
                                                } catch (e) {
                                                    console.error("Niri workspaces parse error:", e)
                                                }
                                            }
                                        }

                                        Process {
                                            id: switchWorkspaceProc
                                            command: []
                                            onExited: { Qt.callLater(updateWorkspaces) }
                                        }

                                        Timer {
                                            interval: 500
                                            running: true
                                            repeat: true
                                            onTriggered: niriWs.updateWorkspaces()
                                        }
                                    }
                                }
                            }

                            Loader {
                                id: dwlWorkspaces
                                active: false
                                sourceComponent: Component {
                                    QtObject {
                                        id: dwlWs
                                        
                                        property int activeTag: 1
                                        property var occupiedTags: []
                                        property int maxTags: 9

                                        signal tagChanged(int tag)

                                        Component.onCompleted: {
                                            workspaceWidget.workspaceManager = dwlWs
                                            updateTags()
                                        }

                                        function updateTags() {
                                            tagQueryProc.running = true
                                        }

                                        function switchToTag(tagIndex) {
                                            if (tagIndex < 1 || tagIndex > maxTags) return
                                            switchTagProc.command = ["dwlmsg", "tag", "view", tagIndex.toString()]
                                            switchTagProc.running = true
                                        }

                                        Process {
                                            id: tagQueryProc
                                            command: ["sh", "-c", "dwlmsg tag status 2>/dev/null || echo 'error'"]
                                            
                                            onExited: {
                                                if (!stdout || stdout.includes("error")) {
                                                    mangoWCQueryProc.running = true
                                                    return
                                                }
                                                parseDWLOutput(stdout)
                                            }
                                        }

                                        Process {
                                            id: mangoWCQueryProc
                                            command: ["sh", "-c", "mangowcctl tag status 2>/dev/null || echo 'error'"]
                                            
                                            onExited: {
                                                if (!stdout || stdout.includes("error")) return
                                                parseMangoWCOutput(stdout)
                                            }
                                        }

                                        function parseDWLOutput(output) {
                                            const lines = output.split("\n")
                                            let occupied = []
                                            let active = 1
                                            
                                            for (let line of lines) {
                                                const parts = line.trim().split(/\s+/)
                                                if (parts.length >= 3) {
                                                    const tagNum = parseInt(parts[0])
                                                    const isOccupied = parts[1] === "1" || parts[1] === "occupied"
                                                    const isActive = parts[2] === "1" || parts[2] === "active"
                                                    
                                                    if (isOccupied) occupied.push(tagNum)
                                                    if (isActive) active = tagNum
                                                }
                                            }
                                            occupiedTags = occupied
                                            activeTag = active
                                        }

                                        function parseMangoWCOutput(output) {
                                            const lines = output.split("\n")
                                            let occupied = []
                                            let active = 1
                                            
                                            for (let line of lines) {
                                                if (line.includes("tag")) {
                                                    const match = line.match(/tag(\d+).*active/)
                                                    if (match) active = parseInt(match[1])
                                                    
                                                    const occupiedMatch = line.match(/tag(\d+)/)
                                                    if (occupiedMatch) occupied.push(parseInt(occupiedMatch[1]))
                                                }
                                            }
                                            occupiedTags = occupied
                                            activeTag = active
                                        }

                                        Process {
                                            id: switchTagProc
                                            command: []
                                            onExited: { Qt.callLater(updateTags) }
                                        }

                                        Timer {
                                            interval: 1000
                                            running: true
                                            repeat: true
                                            onTriggered: dwlWs.updateTags()
                                        }
                                    }
                                }
                            }

                            Repeater {
                                model: getWorkspaceModel()

                                Rectangle {
                                    Layout.preferredWidth: 28
                                    Layout.preferredHeight: 20
                                    radius: 6
                                    
                                    color: isActive() ? theme.blue : (isOccupied() ? theme.bgLighter : "transparent")
                                    border.color: theme.fgSubtle
                                    border.width: isActive() ? 0 : 1

                                    function isActive() {
                                        if (!workspaceWidget.workspaceManager) return false
                                        
                                        if (wmDetector.isNiri()) {
                                            return workspaceWidget.workspaceManager.activeWorkspace === modelData.id
                                        } else {
                                            return workspaceWidget.workspaceManager.activeTag === modelData
                                        }
                                    }

                                    function isOccupied() {
                                        if (!workspaceWidget.workspaceManager) return false
                                        
                                        if (wmDetector.isNiri()) {
                                            return !modelData.isEmpty
                                        } else {
                                            return workspaceWidget.workspaceManager.occupiedTags.indexOf(modelData) !== -1
                                        }
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: getWorkspaceLabel()
                                        color: parent.isActive() ? theme.bg : theme.fg
                                        font {
                                            family: theme.font.family
                                            pixelSize: 11
                                            bold: parent.isActive()
                                        }

                                        function getWorkspaceLabel() {
                                            if (wmDetector.isNiri()) {
                                                return modelData.name || modelData.id
                                            } else {
                                                return modelData
                                            }
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (!workspaceWidget.workspaceManager) return
                                            
                                            if (wmDetector.isNiri()) {
                                                workspaceWidget.workspaceManager.switchToWorkspace(modelData.id)
                                            } else {
                                                workspaceWidget.workspaceManager.switchToTag(modelData)
                                            }
                                        }
                                    }
                                }
                            }

                            function getWorkspaceModel() {
                                if (!workspaceManager) return []
                                
                                if (wmDetector.isNiri()) {
                                    return workspaceManager.workspaces || []
                                } else {
                                    return [1, 2, 3, 4, 5, 6, 7, 8, 9]
                                }
                            }

                            Text {
                                visible: !wmDetector.isSupported()
                                text: "WM not supported"
                                color: theme.fgMuted
                                font {
                                    family: theme.font.family
                                    pixelSize: theme.font.pixelSize - 2
                                }
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: theme.borderWidth
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                            Layout.leftMargin: theme.spacing
                            Layout.rightMargin: theme.spacing
                            color: theme.fgSubtle
                        }

                        Text {
                            text: activeWindow.title
                            color: theme.magenta
                            font {
                                family: theme.font.family
                                pixelSize: theme.font.pixelSize
                                bold: true
                            }
                            Layout.fillWidth: true
                            Layout.leftMargin: theme.spacing
                            Layout.rightMargin: theme.spacing
                            elide: Text.ElideRight
                            maximumLineCount: 1
                        }

                        Rectangle {
                            Layout.preferredWidth: theme.borderWidth
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                            Layout.leftMargin: theme.spacing
                            Layout.rightMargin: theme.spacing
                            color: theme.fgSubtle
                        }

                        Text {
                            id: clockText
                            text: Qt.formatDateTime(new Date(), "HH:mm dd/MM")
                            color: theme.cyan
                            font {
                                family: theme.font.family
                                pixelSize: theme.font.pixelSize
                                bold: true
                            }
                            Layout.rightMargin: theme.spacing / 2

                            Timer {
                                interval: 1000
                                running: true
                                repeat: true
                                onTriggered: clockText.text = Qt.formatDateTime(new Date(), "HH:mm dd/MM")
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: theme.borderWidth
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                            Layout.leftMargin: 0
                            Layout.rightMargin: theme.spacing / 2
                            color: theme.fgSubtle
                        }

                        Text {
                            text: " " + cpu.usage + "%"
                            color: cpu.usage > 85 ? theme.red : theme.yellow
                            font {
                                family: theme.font.family
                                pixelSize: theme.font.pixelSize
                                bold: true
                            }
                            Layout.rightMargin: theme.spacing / 2
                        }

                        Text {
                            text: " " + mem.percent + "%"
                            color: mem.percent > 85 ? theme.red : theme.cyan
                            font {
                                family: theme.font.family
                                pixelSize: theme.font.pixelSize
                                bold: true
                            }
                            Layout.rightMargin: theme.spacing / 2
                        }

                        Text {
                            text: " " + disk.percent + "%"
                            color: disk.percent > 85 ? theme.red : theme.blue
                            font {
                                family: theme.font.family
                                pixelSize: theme.font.pixelSize
                                bold: true
                            }
                            Layout.rightMargin: theme.spacing / 2
                        }

                        Text {
                            text: volume.muted ? " Muted" : " " + volume.level + "%"
                            color: volume.muted ? theme.fgSubtle : theme.fg
                            font {
                                family: theme.font.family
                                pixelSize: theme.font.pixelSize
                                bold: true
                            }
                            Layout.rightMargin: theme.spacing / 2
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: pavuProcess.running = true
                            }
                        }

                        Text {
                            text: btInfo.connected ? "" : ""
                            color: btInfo.connected ? theme.cyan : theme.fgSubtle
                            font {
                                family: theme.font.family
                                pixelSize: theme.font.pixelSize
                                bold: true
                            }
                            Layout.rightMargin: theme.spacing / 2
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: bluemanProcess.running = true
                            }
                        }

                        Text {
                            visible: battery.percentage > 0
                            text: battery.icon + " " + battery.percentage + "%" + (battery.charging ? " 󰂄" : "")
                            color: battery.percentage <= 15 ? theme.red : battery.percentage <= 30 ? theme.yellow : theme.fg
                            font {
                                family: theme.font.family
                                pixelSize: theme.font.pixelSize
                            }
                            Layout.rightMargin: theme.spacing / 2
                        }

                        Text {
                            text: makoDnd.isDnd ? "" : ""
                            color: makoDnd.isDnd ? theme.red : theme.fg
                            font {
                                family: theme.font.family
                                pixelSize: theme.font.pixelSize
                                bold: makoDnd.isDnd
                            }
                            Layout.rightMargin: theme.spacing / 2
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: makoDndProcess.running = true
                            }
                        }

                        Text {
                            text: "⏻"
                            color: theme.fg
                            font {
                                family: theme.font.family
                                pixelSize: 16
                            }
                            Layout.rightMargin: theme.spacing / 2
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: wlogoutProcess.running = true
                            }
                        }

                        Item { width: theme.padding / 2 }
                    }
                }
            }
        }
    }
  '';
in
{
  xdg.configFile."quickshell/shell.qml".text = shellQml;
}
