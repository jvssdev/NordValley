// ./bar.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "quickshell" // Imports Theme singleton

Item {
    id: barRoot
    
    // Properties to receive state from shell.qml
    property QtObject makoDnd
    property QtObject btInfo
    property QtObject volume
    property QtObject battery
    property QtObject cpu
    property QtObject mem
    property QtObject disk
    property QtObject activeWindow

    // Define a reusable component for one-off shell commands
    Component {
        id: oneShotProcess
        Process {
            property var commandToRun: []
            command: commandToRun
            running: true
            // Automatically clean up the process object after it exits
            onExited: destroy() 
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData

            anchors { top: true; left: true; right: true }

            implicitHeight: 30
            color: Theme.bg

            margins { top: 0; bottom: 0; left: 0; right: 0 }

            Rectangle {
                anchors.fill: parent
                color: Theme.bg

                RowLayout {
                    anchors.fill: parent
                    spacing: Theme.spacing / 2

                    Item { width: Theme.padding / 2 }

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

                    Item { width: Theme.padding / 2 }

                    Workspaces {
                        Layout.preferredHeight: parent.height
                        model: Quickshell.Wayland.Workspaces.all
                        spacing: Theme.spacing
                        delegate: Rectangle {
                            color: parent.model.focused ? Theme.magenta : "transparent"
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: parent.height
                            radius: 3

                            property bool isFocused: parent.model.focused
                            property bool isUrgent: parent.model.urgent
                            property bool hasWindows: parent.model.windows.length > 0

                            Text {
                                text: parent.model.name || parent.model.id
                                color: parent.isFocused ? Theme.fg : (parent.isUrgent ? Theme.red : (parent.hasWindows ? Theme.fg : Theme.fgSubtle))
                                font: Theme.font
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
                                        oneShotProcess.createObject(barRoot, {
                                            commandToRun: ["sh", "-c",
                                                      "if pgrep -x dwl > /dev/null; then dwl-cmd -s toggleview " + (wsId - 1) +
                                                      "elif pgrep -x river > /dev/null; then riverctl toggle-tag " + wsId +
                                                      "elif pgrep -x niri > /dev/null; then niri msg overview; fi"]
                                        })
                                    }
                                }
                            }
                        }
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
                        text: " " + cpu.usage + "%"
                        color: cpu.usage > 85 ? Theme.red : Theme.yellow
                        font: Theme.font
                        font.bold: true
                        Layout.rightMargin: Theme.spacing / 2
                    }

                    Text {
                        text: " " + mem.percent + "%"
                        color: mem.percent > 85 ? Theme.red : Theme.cyan
                        font: Theme.font
                        font.bold: true
                        Layout.rightMargin: Theme.spacing / 2
                    }

                    Text {
                        text: " " + disk.percent + "%"
                        color: disk.percent > 85 ? Theme.red : Theme.blue
                        font: Theme.font
                        font.bold: true
                        Layout.rightMargin: Theme.spacing / 2
                    }

                    Text {
                        text: volume.muted ? " Muted" : " " + volume.level + "%"
                        color: volume.muted ? Theme.fgSubtle : Theme.fg
                        font: Theme.font
                        font.bold: true
                        Layout.rightMargin: Theme.spacing / 2
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: oneShotProcess.createObject(barRoot, { commandToRun: ["pavucontrol"] })
                        }
                    }

                    Text {
                        text: btInfo.connected ? "" : ""
                        color: btInfo.connected ? Theme.cyan : Theme.fgSubtle
                        font: Theme.font
                        font.bold: true
                        Layout.rightMargin: Theme.spacing / 2
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: oneShotProcess.createObject(barRoot, { commandToRun: ["blueman-manager"] })
                        }
                    }

                    Text {
                        text: battery.icon + " " + battery.percentage + "%" + (battery.charging ? " 󰂄" : "")
                        color: battery.percentage <= 15 ? Theme.red : battery.percentage <= 30 ? Theme.yellow : Theme.fg
                        font: Theme.font
                        Layout.rightMargin: Theme.spacing / 2
                    }

                    Text {
                        text: makoDnd.isDnd ? "" : ""
                        color: makoDnd.isDnd ? Theme.red : Theme.fg
                        font: Theme.font
                        font.bold: makoDnd.isDnd
                        Layout.rightMargin: Theme.spacing / 2
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: oneShotProcess.createObject(barRoot, { 
                                commandToRun: ["sh", "-c", "makoctl mode | grep -q do-not-disturb && makoctl mode -r do-not-disturb || makoctl mode -a do-not-disturb"]
                            })
                        }
                    }

                    Text {
                        text: "⏻"
                        color: Theme.fg
                        font { family: Theme.font.family; pixelSize: 16 }
                        Layout.rightMargin: Theme.spacing / 2
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: oneShotProcess.createObject(barRoot, { commandToRun: ["wlogout"] })
                        }
                    }

                    Item { width: Theme.padding / 2 }
                }
            }
        }
    }
}
