{
  config,
  pkgs,
  lib,
  ...
}:
let
  palette = config.colorScheme.palette;
  formatColor = c: "#${lib.strings.substring 0 6 c}";

  theme = {
    colBg = formatColor palette.base00;
    colFg = formatColor palette.base05;
    colMuted = formatColor palette.base03;
    colCyan = formatColor palette.base0C;
    colPurple = formatColor palette.base0E;
    colRed = formatColor palette.base08;
    colYellow = formatColor palette.base0A;
    colBlue = formatColor palette.base0D;
    fontFamily = "JetBrainsMono Nerd Font";
    fontSize = 14;
  };

  shellQml = ''
    import QtQuick
    import QtQuick.Layouts
    import QtQml
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Io

    import "bar.qml" as BarComponent

    ShellRoot {
        id: root

        QtObject {
          id: theme
          readonly property color colBg: "${theme.colBg}"
          readonly property color colFg: "${theme.colFg}"
          readonly property color colMuted: "${theme.colMuted}"
          readonly property color colCyan: "${theme.colCyan}"
          readonly property color colPurple: "${theme.colPurple}"
          readonly property color colRed: "${theme.colRed}"
          readonly property color colYellow: "${theme.colYellow}"
          readonly property color colBlue: "${theme.colBlue}"
          readonly property string fontFamily: "${theme.fontFamily}"
          readonly property int fontSize: ${toString theme.fontSize}
        }
        
        QtObject {
            id: makoDnd
            property bool isDnd: false

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
        }

        QtObject {
            id: btInfo
            property bool connected: false

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
        }

        QtObject {
            id: volume
            property int level: 0
            property bool muted: false

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
        }
        
        QtObject {
            id: battery
            property int percentage: 0
            property string icon: "󰂎"
            property bool charging: false

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
                command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/capacity"]
                onExited: battery.percentage = parseInt(stdout.trim()) || 0
            }

            Process {
                id: batStatusProc
                command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/status"]
                onExited: battery.charging = stdout.trim() === "Charging"
            }
            
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

        QtObject {
            id: cpu
            property int usage: 0

            Process {
                id: cpuProc
                command: ["top", "-bn1"]
                onExited: {
                    const lines = stdout.split("\\n")
                    for (let line of lines) {
                        if (line.includes("%Cpu")) {
                            const parts = line.split(/\\s+/)
                            usage = Math.round(100 - parseFloat(parts[7]))
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
        }

        QtObject {
            id: mem
            property int percent: 0

            Process {
                id: memProc
                command: ["sh", "-c", "free | grep Mem"]
                onExited: {
                    const line = stdout.split("\\n")[1] || ""
                    const parts = line.split(/\\s+/)
                    const total = parseInt(parts[1]) || 1
                    const used = parseInt(parts[2]) || 0
                    percent = Math.round(used / total * 100)
                }
            }

            Timer {
                interval: 2000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: memProc.running = true
            }
        }

        QtObject {
            id: disk
            property int percent: 0

            Process {
                id: diskProc
                command: ["sh", "-c", "df / | tail -1"]
                onExited: {
                    const line = stdout.split("\\n")[0] || ""
                    const parts = line.split(/\\s+/)
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
        }

        QtObject {
            id: activeWindow
            property string title: "No Window Focused"

            ActiveClient {
                onTitleChanged: activeWindow.title = title || "No Window Focused"
            }
        }
        
        BarComponent.Bar {
           theme: theme
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

  barComponentQml = ''
    import QtQuick
    import QtQuick.Layouts
    import QtQml
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Io

    Item {
        id: barRoot
        
        property QtObject theme
        property QtObject makoDnd
        property QtObject btInfo
        property QtObject volume
        property QtObject battery
        property QtObject cpu
        property QtObject mem
        property QtObject disk
        property QtObject activeWindow

        Variants {
            model: Quickshell.screens

            PanelWindow {
                property var modelData
                screen: modelData

                anchors { top: true; left: true; right: true }

                implicitHeight: 30
                color: theme.colBg

                margins {
                    top: 0
                    bottom: 0
                    left: 0
                    right: 0
                }

                Rectangle {
                    anchors.fill: parent
                    color: theme.colBg

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        Item { width: 8 }

                        Rectangle {
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                            color: "transparent"

                            Image {
                                anchors.fill: parent
                                source: "file:///home/tony/.config/quickshell/icons/tonybtw.png"
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Item { width: 8 }

                        Workspaces {
                            Layout.preferredHeight: parent.height
                            model: Quickshell.Wayland.Workspaces.all
                            spacing: 8
                            delegate: Rectangle {
                                color: parent.model.focused ? theme.colPurple : "transparent"
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: parent.height
                                radius: 3

                                property bool isFocused: parent.model.focused
                                property bool isUrgent: parent.model.urgent
                                property bool hasWindows: parent.model.windows.length > 0

                                Text {
                                    text: parent.model.name || parent.model.id
                                    color: parent.isFocused ? theme.colFg : (parent.isUrgent ? theme.colRed : (parent.hasWindows ? theme.colFg : theme.colMuted))
                                    font.pixelSize: theme.fontSize
                                    font.family: theme.fontFamily
                                    font.bold: parent.isFocused
                                    anchors.centerIn: parent
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: (mouse) => {
                                        if (mouse.button === Qt.LeftButton) {
                                            parent.model.focus()
                                        } else if (mouse.button === Qt.RightButton) {
                                            var wsId = parent.model.id

                                            Process {
                                                command: ["sh", "-c",
                                                          "if pgrep -x dwl > /dev/null; then dwl-cmd -s toggleview " + (wsId - 1) +
                                                          "elif pgrep -x river > /dev/null; then riverctl toggle-tag " + wsId +
                                                          "elif pgrep -x niri > /dev/null; then niri msg overview; fi"]
                                                running: true
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: 1
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                            Layout.leftMargin: 8
                            Layout.rightMargin: 8
                            color: theme.colMuted
                        }

                        Text {
                            text: activeWindow.title
                            color: theme.colPurple
                            font.pixelSize: theme.fontSize
                            font.family: theme.fontFamily
                            font.bold: true
                            Layout.fillWidth: true
                            Layout.leftMargin: 8
                            Layout.rightMargin: 8
                            elide: Text.ElideRight
                            maximumLineCount: 1
                        }

                        Rectangle {
                            Layout.preferredWidth: 1
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                            Layout.leftMargin: 8
                            Layout.rightMargin: 8
                            color: theme.colMuted
                        }

                        Text {
                            id: clockText
                            text: Qt.formatDateTime(new Date(), "HH:mm dd/MM")
                            color: theme.colCyan
                            font.pixelSize: theme.fontSize
                            font.family: theme.fontFamily
                            font.bold: true
                            Layout.rightMargin: 8

                            Timer {
                                interval: 1000
                                running: true
                                repeat: true
                                onTriggered: clockText.text = Qt.formatDateTime(new Date(), "HH:mm dd/MM")
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: 1
                            Layout.preferredHeight: 16
                            Layout.alignment: Qt.AlignVCenter
                            Layout.leftMargin: 0
                            Layout.rightMargin: 8
                            color: theme.colMuted
                        }

                        Text {
                            text: " " + cpu.usage + "%"
                            color: cpu.usage > 85 ? theme.colRed : theme.colYellow
                            font.pixelSize: theme.fontSize
                            font.family: theme.fontFamily
                            font.bold: true
                            Layout.rightMargin: 8
                        }

                        Text {
                            text: " " + mem.percent + "%"
                            color: mem.percent > 85 ? theme.colRed : theme.colCyan
                            font.pixelSize: theme.fontSize
                            font.family: theme.fontFamily
                            font.bold: true
                            Layout.rightMargin: 8
                        }

                        Text {
                            text: " " + disk.percent + "%"
                            color: disk.percent > 85 ? theme.colRed : theme.colBlue
                            font.pixelSize: theme.fontSize
                            font.family: theme.fontFamily
                            font.bold: true
                            Layout.rightMargin: 8
                        }

                        Text {
                            text: volume.muted ? " Muted" : " " + volume.level + "%"
                            color: volume.muted ? theme.colMuted : theme.colFg
                            font.pixelSize: theme.fontSize
                            font.family: theme.fontFamily
                            font.bold: true
                            Layout.rightMargin: 8
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Process { command: ["pavucontrol"]; running: true }
                            }
                        }

                        Text {
                            text: btInfo.connected ? "" : ""
                            color: btInfo.connected ? theme.colCyan : theme.colMuted
                            font.pixelSize: theme.fontSize
                            font.family: theme.fontFamily
                            font.bold: true
                            Layout.rightMargin: 8
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Process { command: ["blueman-manager"]; running: true }
                            }
                        }

                        Text {
                            text: battery.icon + " " + battery.percentage + "%" + (battery.charging ? " 󰂄" : "")
                            color: battery.percentage <= 15 ? theme.colRed : battery.percentage <= 30 ? theme.colYellow : theme.colFg
                            font { family: theme.fontFamily; pixelSize: theme.fontSize }
                            Layout.rightMargin: 8
                        }

                        Text {
                            text: makoDnd.isDnd ? "" : ""
                            color: makoDnd.isDnd ? theme.colRed : theme.colFg
                            font { family: theme.fontFamily; pixelSize: theme.fontSize; bold: makoDnd.isDnd }
                            Layout.rightMargin: 8
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Process { command: ["sh", "-c", "makoctl mode | grep -q do-not-disturb && makoctl mode -r do-not-disturb || makoctl mode -a do-not-disturb"]; running: true }
                            }
                        }

                        Text {
                            text: "⏻"
                            color: theme.colFg
                            font { family: theme.fontFamily; pixelSize: 16 }
                            Layout.rightMargin: 8
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Process { command: ["wlogout"]; running: true }
                            }
                        }

                        Item { width: 8 }
                    }
                }
            }
        }
    }
  '';
in
{
  xdg.configFile."quickshell/bar.qml".text = barComponentQml;
  xdg.configFile."quickshell/shell.qml".text = shellQml;
}
