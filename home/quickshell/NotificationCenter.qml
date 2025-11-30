import QtQuick
import Quickshell

Rectangle {
    id: root
    property QtObject theme
    property PanelWindow panel

    color: theme.bg
    radius: theme.radius
    border.width: theme.borderWidth
    border.color: theme.blue

    Column {
        anchors.fill: parent
        anchors.margins: theme.padding
        spacing: theme.spacing

        Rectangle {
            width: parent.width
            height: 50
            color: "transparent"

            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: "Notifications"
                color: theme.fg
                font.family: theme.fontFamily
                font.pixelSize: 17
                font.bold: true
            }

            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: theme.spacing

                // DND
                Rectangle {
                    width: 44; height: 32
                    color: NotificationService.dndEnabled ? theme.red : theme.bgLighter
                    radius: 8
                    Text {
                        anchors.centerIn: parent
                        text: NotificationService.dndEnabled ? "🔕" : "🔔"
                        font.pixelSize: 18
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: NotificationService.toggleDND()
                        cursorShape: Qt.PointingHandCursor
                    }
                }

                // Clear All
                Rectangle {
                    width: 90; height: 32
                    color: theme.bgLighter
                    radius: 8
                    Text {
                        anchors.centerIn: parent
                        text: "Clear All"
                        color: theme.fg
                        font.family: theme.fontFamily
                        font.pixelSize: theme.fontSize
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: NotificationService.clearAll()
                        cursorShape: Qt.PointingHandCursor
                    }
                }

                // Close button
                Rectangle {
                    width: 44; height: 32
                    color: theme.bgLighter
                    radius: 8
                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: theme.fg
                        font.pixelSize: 20
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: panel.visible = false
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: parent.height - 66
            color: "transparent"
            clip: true

            ListView {
                anchors.fill: parent
                spacing: 10
                model: NotificationService.notifications
                delegate: Rectangle {
                    width: ListView.view.width
                    height: 86
                    color: theme.bgAlt
                    radius: theme.radius

                    Column {
                        anchors.fill: parent
                        anchors.margins: theme.padding
                        spacing: 6

                        Text {
                            text: modelData.summary
                            color: theme.fg
                            font.family: theme.fontFamily
                            font.bold: true
                            font.pixelSize: 14
                            elide: Text.ElideRight
                            width: parent.width
                        }
                        Text {
                            text: modelData.body || ""
                            color: theme.fgMuted
                            font.family: theme.fontFamily
                            font.pixelSize: theme.fontSize
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            width: parent.width
                        }
                        Text {
                            text: Qt.formatTime(modelData.time, "hh:mm")
                            color: theme.fgSubtle
                            font.family: theme.fontFamily
                            font.pixelSize: 11
                        }
                    }
                }
            }
        }
    }
}
