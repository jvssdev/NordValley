import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import "."

ShellRoot {
    NotificationService {}
    MprisService {}
    IdleService {}

    WaylandWindow {
        id: notificationCenter
        visible: false

        PanelWindow {
            anchors { top: true; right: true; margins: 10 }
            width: 420
            height: 650
            color: Theme.bg

            NotificationCenter { anchors.fill: parent }
        }
    }

    File {
        path: "/tmp/quickshell-toggle-cmd"
        onContentChanged: {
            notificationCenter.visible = !notificationCenter.visible
            content = ""
        }
    }

    Component.onCompleted: NotificationService.updateStatusFile()
}
