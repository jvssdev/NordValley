// quickshell/bar.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    required property QtObject theme
    required property QtObject makoDnd
    required property QtObject btInfo
    required property QtObject volume
    required property QtObject battery
    required property QtObject cpu
    required property QtObject mem
    required property QtObject disk
    required property QtObject activeWindow
    required property QtObject wm

    anchors.top: true
    anchors.left: true
    anchors.right: true
    height: 30
    color: theme.bg

    Process { id: pavuProcess;    command: ["pavucontrol"] }
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
                font { family: theme.font.family; pixelSize: 18; bold: true }
            }

            // Workspaces / Tags 1–9
            Row {
                spacing: theme.spacing
                visible: wm.isNiri || wm.isDwl || wm.isRiver
                Repeater {
                    model: 9
                    Item {
                        width: 28; height: 28
                        Rectangle {
                            anchors.centerIn: parent
                            width: 20; height: 20; radius: 10
                            color: {
                                switch (wm.state(index + 1)) {
                                    case "urgent":   return theme.red
                                    case "active":   return theme.cyan
                                    case "occupied": return theme.blue
                                    default:         return theme.bgLighter
                                }
                            }
                        }
                        Text {
                            anchors.centerIn: parent
                            text: index + 1
                            color: wm.state(index + 1) === "active" ? theme.bg : theme.fg
                            font { family: theme.font.family; pixelSize: 12; bold: true }
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: wm.switchTo(index + 1)
                        }
                    }
                }
            }

            Item { width: theme.spacing }

            Rectangle {
                Layout.preferredWidth: theme.borderWidth
                Layout.preferredHeight: 16
                Layout.alignment: Qt.AlignVCenter
                color: theme.fgSubtle
            }

            Text {
                text: activeWindow.title
                color: theme.magenta
                font { family: theme.font.family; pixelSize: theme.font.pixelSize; bold: true }
                Layout.fillWidth: true
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            Rectangle {
                Layout.preferredWidth: theme.borderWidth
                Layout.preferredHeight: 16
                Layout.alignment: Qt.AlignVCenter
                color: theme.fgSubtle
            }

            Text {
                id: clockText
                text: Qt.formatDateTime(new Date(), "HH:mm dd/MM")
                color: theme.cyan
                font { family: theme.font.family; pixelSize: theme.font.pixelSize; bold: true }
                Timer { interval: 1000; running: true; repeat: true; onTriggered: clockText.text = Qt.formatDateTime(new Date(), "HH:mm dd/MM") }
            }

            Rectangle {
                Layout.preferredWidth: theme.borderWidth
                Layout.preferredHeight: 16
                Layout.alignment: Qt.AlignVCenter
                color: theme.fgSubtle
            }

            Text { text: " " + cpu.usage + "%";    color: cpu.usage > 85 ? theme.red : theme.yellow;    font { family: theme.font.family; pixelSize: theme.font.pixelSize; bold: true } }
            Text { text: " " + mem.percent + "%";  color: mem.percent > 85 ? theme.red : theme.cyan;    font { family: theme.font.family; pixelSize: theme.font.pixelSize; bold: true } }
            Text { text: " " + disk.percent + "%"; color: disk.percent > 85 ? theme.red : theme.blue;   font { family: theme.font.family; pixelSize: theme.font.pixelSize; bold: true } }

            Text {
                text: volume.muted ? " Muted" : " " + volume.level + "%"
                color: volume.muted ? theme.fgSubtle : theme.fg
                font { family: theme.font.family; pixelSize: theme.font.pixelSize; bold: true }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: pavuProcess.running = true }
            }

            Text {
                text: btInfo.connected ? "" : ""
                color: btInfo.connected ? theme.cyan : theme.fgSubtle
                font { family: theme.font.family; pixelSize: theme.font.pixelSize; bold: true }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: bluemanProcess.running = true }
            }

            Text {
                visible: battery.percentage > 0
                text: battery.icon + " " + battery.percentage + "%" + (battery.charging ? " 󰂄" : "")
                color: battery.percentage <= 15 ? theme.red : battery.percentage <= 30 ? theme.yellow : theme.fg
                font { family: theme.font.family; pixelSize: theme.font.pixelSize }
            }

            Text {
                text: makoDnd.isDnd ? "" : ""
                color: makoDnd.isDnd ? theme.red : theme.fg
                font { family: theme.font.family; pixelSize: theme.font.pixelSize; bold: makoDnd.isDnd }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: makoDndProcess.running = true }
            }

            Text {
                text: "⏻"
                color: theme.fg
                font { family: theme.font.family; pixelSize: 16 }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: wlogoutProcess.running = true }
            }

            Item { width: theme.padding / 2 }
        }
    }
}
