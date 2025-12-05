import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

Variants {
    required property QtObject makoDnd
    required property QtObject btInfo
    required property QtObject volume
    required property QtObject battery
    required property QtObject cpu
    required property QtObject mem
    required property QtObject disk
    required property QtObject activeWindow

    model: Quickshell.screens

    PanelWindow {
        property var modelData

        anchors.top: true
        anchors.left: true
        anchors.right: true

        height: 30
        color: Theme.bg

        Process { id: pavuProcess; command: ["pavucontrol"] }
        Process { id: bluemanProcess; command: ["blueman-manager"] }
        Process { id: makoDndProcess; command: ["sh", "-c", "makoctl mode | grep -q do-not-disturb && makoctl mode -r do-not-disturb || makoctl mode -a do-not-disturb"] }
        Process { id: wlogoutProcess; command: ["wlogout"] }

        Rectangle {
            anchors.fill: parent
            color: Theme.bg

            RowLayout {
                anchors.fill: parent
                spacing: Theme.spacing / 2

                Item { width: Theme.padding / 2 }

                Text {
                    text: "~"
                    color: Theme.magenta
                    font: Theme.font
                    font.pixelSize: 18
                    font.bold: true
                }

                Item { width: Theme.spacing }

                Rectangle {
                    Layout.preferredWidth: Theme.borderWidth
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: Theme.spacing
                    Layout.rightMargin: Theme.spacing
                    color: Theme.fgSubtle
                }

                Text {
                    text: activeWindow.title
                    color: Theme.magenta
                    font: Theme.font
                    font.bold: true
                    Layout.fillWidth: true
                    Layout.leftMargin: Theme.spacing
                    Layout.rightMargin: Theme.spacing
                    elide: Text.ElideRight
                    maximumLineCount: 1
                }

                Rectangle {
                    Layout.preferredWidth: Theme.borderWidth
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: Theme.spacing
                    Layout.rightMargin: Theme.spacing
                    color: Theme.fgSubtle
                }

                Text {
                    id: clockText
                    text: Qt.formatDateTime(new Date(), "HH:mm dd/MM")
                    color: Theme.cyan
                    font: Theme.font
                    font.bold: true
                    Layout.rightMargin: Theme.spacing / 2

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: clockText.text = Qt.formatDateTime(new Date(), "HH:mm dd/MM")
                    }
                }

                Rectangle {
                    Layout.preferredWidth: Theme.borderWidth
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: 0
                    Layout.rightMargin: Theme.spacing / 2
                    color: Theme.fgSubtle
                }

                Text {
                    text: " " + cpu.usage + "%"
                    color: cpu.usage > 85 ? Theme.red : Theme.yellow
                    font: Theme.font
                    font.bold: true
                    Layout.rightMargin: Theme.spacing / 2
                }

                Text {
                    text: " " + mem.percent + "%"
                    color: mem.percent > 85 ? Theme.red : Theme.cyan
                    font: Theme.font
                    font.bold: true
                    Layout.rightMargin: Theme.spacing / 2
                }

                Text {
                    text: " " + disk.percent + "%"
                    color: disk.percent > 85 ? Theme.red : Theme.blue
                    font: Theme.font
                    font.bold: true
                    Layout.rightMargin: Theme.spacing / 2
                }

                Text {
                    text: volume.muted ? " Muted" : " " + volume.level + "%"
                    color: volume.muted ? Theme.fgSubtle : Theme.fg
                    font: Theme.font
                    font.bold: true
                    Layout.rightMargin: Theme.spacing / 2
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: pavuProcess.running = true
                    }
                }

                Text {
                    text: btInfo.connected ? "" : ""
                    color: btInfo.connected ? Theme.cyan : Theme.fgSubtle
                    font: Theme.font
                    font.bold: true
                    Layout.rightMargin: Theme.spacing / 2
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: bluemanProcess.running = true
                    }
                }

                Text {
                    visible: battery.percentage > 0
                    text: battery.icon + " " + battery.percentage + "%" + (battery.charging ? " 󰂄" : "")
                    color: battery.percentage <= 15 ? Theme.red : battery.percentage <= 30 ? Theme.yellow : Theme.fg
                    font: Theme.font
                    Layout.rightMargin: Theme.spacing / 2
                }

                Text {
                    text: makoDnd.isDnd ? "" : ""
                    color: makoDnd.isDnd ? Theme.red : Theme.fg
                    font: Theme.font
                    font.bold: makoDnd.isDnd
                    Layout.rightMargin: Theme.spacing / 2
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: makoDndProcess.running = true
                    }
                }

                Text {
                    text: "⏻"
                    color: Theme.fg
                    font.family: Theme.font.family
                    font.pixelSize: 16
                    Layout.rightMargin: Theme.spacing / 2
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: wlogoutProcess.running = true
                    }
                }

                Item { width: Theme.padding / 2 }
            }
        }
    }
}
