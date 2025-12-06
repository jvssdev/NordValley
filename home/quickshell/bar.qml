import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

Variants {
    id: bar

    required property QtObject theme
    required property QtObject wmDetector
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
        anchors.top: true
        anchors.left: true
        anchors.right: true
        height: 30
        color: bar.theme.bg

        Process { id: pavuProcess; command: ["pavucontrol"] }
        Process { id: bluemanProcess; command: ["blueman-manager"] }
        Process { id: makoDndProcess; command: ["sh", "-c", "makoctl mode | grep -q do-not-disturb && makoctl mode -r do-not-disturb || makoctl mode -a do-not-disturb"] }
        Process { id: wlogoutProcess; command: ["wlogout"] }

        Rectangle {
            anchors.fill: parent
            color: bar.theme.bg

            RowLayout {
                anchors.fill: parent
                spacing: bar.theme.spacing / 2

                Item { width: bar.theme.padding / 2 }

                Text {
                    text: "~"
                    color: bar.theme.magenta
                    font {
                        family: bar.theme.font.family
                        pixelSize: 18
                        bold: true
                    }
                }

                Item { width: bar.theme.spacing }

                WorkspaceWidget {
                    theme: bar.theme
                    wmDetector: bar.wmDetector
                    Layout.leftMargin: bar.theme.spacing
                }

                Rectangle {
                    Layout.preferredWidth: bar.theme.borderWidth
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: bar.theme.spacing
                    Layout.rightMargin: bar.theme.spacing
                    color: bar.theme.fgSubtle
                }

                Text {
                    text: bar.activeWindow.title
                    color: bar.theme.magenta
                    font {
                        family: bar.theme.font.family
                        pixelSize: bar.theme.font.pixelSize
                        bold: true
                    }
                    Layout.fillWidth: true
                    Layout.leftMargin: bar.theme.spacing
                    Layout.rightMargin: bar.theme.spacing
                    elide: Text.ElideRight
                    maximumLineCount: 1
                }

                Rectangle {
                    Layout.preferredWidth: bar.theme.borderWidth
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: bar.theme.spacing
                    Layout.rightMargin: bar.theme.spacing
                    color: bar.theme.fgSubtle
                }

                Text {
                    id: clockText
                    text: Qt.formatDateTime(new Date(), "HH:mm dd/MM")
                    color: bar.theme.cyan
                    font {
                        family: bar.theme.font.family
                        pixelSize: bar.theme.font.pixelSize
                        bold: true
                    }
                    Layout.rightMargin: bar.theme.spacing / 2

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: clockText.text = Qt.formatDateTime(new Date(), "HH:mm dd/MM")
                    }
                }

                Rectangle {
                    Layout.preferredWidth: bar.theme.borderWidth
                    Layout.preferredHeight: 16
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: 0
                    Layout.rightMargin: bar.theme.spacing / 2
                    color: bar.theme.fgSubtle
                }

                Text {
                    text: " " + bar.cpu.usage + "%"
                    color: bar.cpu.usage > 85 ? bar.theme.red : bar.theme.yellow
                    font {
                        family: bar.theme.font.family
                        pixelSize: bar.theme.font.pixelSize
                        bold: true
                    }
                    Layout.rightMargin: bar.theme.spacing / 2
                }

                Text {
                    text: " " + bar.mem.percent + "%"
                    color: bar.mem.percent > 85 ? bar.theme.red : bar.theme.cyan
                    font {
                        family: bar.theme.font.family
                        pixelSize: bar.theme.font.pixelSize
                        bold: true
                    }
                    Layout.rightMargin: bar.theme.spacing / 2
                }

                Text {
                    text: " " + bar.disk.percent + "%"
                    color: bar.disk.percent > 85 ? bar.theme.red : bar.theme.blue
                    font {
                        family: bar.theme.font.family
                        pixelSize: bar.theme.font.pixelSize
                        bold: true
                    }
                    Layout.rightMargin: bar.theme.spacing / 2
                }

                Text {
                    text: bar.volume.muted ? " Muted" : " " + bar.volume.level + "%"
                    color: bar.volume.muted ? bar.theme.fgSubtle : bar.theme.fg
                    font {
                        family: bar.theme.font.family
                        pixelSize: bar.theme.font.pixelSize
                        bold: true
                    }
                    Layout.rightMargin: bar.theme.spacing / 2
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: pavuProcess.running = true
                    }
                }

                Text {
                    text: bar.btInfo.connected ? "" : ""
                    color: bar.btInfo.connected ? bar.theme.cyan : bar.theme.fgSubtle
                    font {
                        family: bar.theme.font.family
                        pixelSize: bar.theme.font.pixelSize
                        bold: true
                    }
                    Layout.rightMargin: bar.theme.spacing / 2
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: bluemanProcess.running = true
                    }
                }

                Text {
                    visible: bar.battery.percentage > 0
                    text: bar.battery.icon + " " + bar.battery.percentage + "%" + (bar.battery.charging ? " 󰂄" : "")
                    color: bar.battery.percentage <= 15 ? bar.theme.red : bar.battery.percentage <= 30 ? bar.theme.yellow : bar.theme.fg
                    font {
                        family: bar.theme.font.family
                        pixelSize: bar.theme.font.pixelSize
                    }
                    Layout.rightMargin: bar.theme.spacing / 2
                }

                Text {
                    text: bar.makoDnd.isDnd ? "" : ""
                    color: bar.makoDnd.isDnd ? bar.theme.red : bar.theme.fg
                    font {
                        family: bar.theme.font.family
                        pixelSize: bar.theme.font.pixelSize
                        bold: bar.makoDnd.isDnd
                    }
                    Layout.rightMargin: bar.theme.spacing / 2
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: makoDndProcess.running = true
                    }
                }

                Text {
                    text: "⏻"
                    color: bar.theme.fg
                    font {
                        family: bar.theme.font.family
                        pixelSize: 16
                    }
                    Layout.rightMargin: bar.theme.spacing / 2
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: wlogoutProcess.running = true
                    }
                }

                Item { width: bar.theme.padding / 2 }
            }
        }
    }
}
