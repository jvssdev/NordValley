pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Io

Singleton {
    id: root
    property var notifications: []
    property int maxNotifications: 50
    property bool dndEnabled: false

    NotificationServer {
        onNotification: function(n) {
            root.notifications.unshift({
                id: n.id,
                appName: n.appName || "Unknown",
                summary: n.summary || "Notification",
                body: n.body || "",
                time: new Date()
            })

            if (root.notifications.length > root.maxNotifications)
                root.notifications.pop()

            root.updateStatusFile()
        }

        onNotificationClosed: (id, reason) => root.removeNotification(id)
    }

    function removeNotification(id) {
        root.notifications = root.notifications.filter(n => n.id !== id)
        updateStatusFile()
    }

    function clearAll() {
        root.notifications = []
        updateStatusFile()
    }

    function toggleDND() {
        root.dndEnabled = !root.dndEnabled
        updateStatusFile()
    }

    function updateStatusFile() {
        var count = root.notifications.length
        var text = count > 0 ? String(count) : ""
        var tooltip = root.dndEnabled ? "Do Not Disturb" :
                      count === 0 ? "No notifications" :
                      count === 1 ? "1 notification" : count + " notifications"
        var cls = root.dndEnabled ? "dnd" : count > 0 ? "notification" : "none"

        Process.exec("qs-write-status", [text, tooltip, cls])
    }

    Component.onCompleted: updateStatusFile()
}
