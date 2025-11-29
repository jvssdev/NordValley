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

    Timer {
        interval: 100
        running: true
        repeat: true
        
        property string lastContent: ""
        
        onTriggered: {
            var result = Process.exec("cat", ["/tmp/quickshell-toggle-cmd"])
            if (result.exitCode === 0 && result.stdout !== lastContent && result.stdout !== "") {
                notificationCenter.visible = !notificationCenter.visible
                lastContent = result.stdout
                Process.exec("sh", ["-c", "echo '' > /tmp/quickshell-toggle-cmd"])
            }
        }
    }

    Component.onCompleted: NotificationService.updateStatusFile()
}
