import QtQuick
import Quickshell
import "."

Rectangle {
    color: Theme.bg
    radius: Theme.radius

    border.width: Theme.borderWidth
    border.color: Theme.blue

    Column {
        anchors.fill: parent
        anchors.margins: Theme.padding
        spacing: Theme.spacing

        Row {
            width: parent.width
            height: 44
            spacing: Theme.spacing

            Text {
                text: "Notifications"
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: 17
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                height: parent.height
            }

            Item { width: 1; height: 1 }

            Rectangle {
                width: 44; height: 32
                color: NotificationService.dndEnabled ? Theme.red : Theme.bgLighter
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

            Rectangle {
                width: 90; height: 32
                color: Theme.bgLighter
                radius: 8

                Text {
                    anchors.centerIn: parent
                    text: "Clear All"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: NotificationService.clearAll()
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }

        Rectangle {
            width: parent.width
            height: parent.height - 60
            color: "transparent"

            ListView {
                anchors.fill: parent
                spacing: 10
                clip: true
                model: NotificationService.notifications

                delegate: Rectangle {
                    width: ListView.view.width
                    height: 86
                    color: Theme.bgAlt
                    radius: 10

                    Column {
                        anchors.fill: parent
                        anchors.margins: Theme.padding
                        spacing: 6

                        Text {
                            text: modelData.summary
                            color: Theme.fg
                            font.family: Theme.fontFamily
                            font.bold: true
                            font.pixelSize: 14
                            elide: Text.ElideRight
                            width: parent.width
                        }

                        Text {
                            text: modelData.body || ""
                            color: Theme.fgMuted
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSize
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            width: parent.width
                        }

                        Text {
                            text: Qt.formatTime(modelData.time, "hh:mm")
                            color: Theme.fgSubtle
                            font.family: Theme.fontFamily
                            font.pixelSize: 11
                        }
                    }
                }
            }
        }
    }
}
