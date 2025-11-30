import Quickshell
import Quickshell.Wayland
import QtQuick

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

    Component.onCompleted: {
        NotificationService.updateStatusFile()
    }
}
