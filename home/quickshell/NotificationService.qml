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
                summary: n.summary || "Notification",
                body: n.body || "",
                appName: n.appName || "Unknown",
                time: new Date()
            })

            if (root.notifications.length > root.maxNotifications)
                root.notifications.pop()

            root.updateStatusFile()
        }

        onNotificationClosed: (id) => root.removeNotification(id)
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
        dndEnabled = !dndEnabled
        updateStatusFile()
    }

    function updateStatusFile() {
        var count = notifications.length
        var text = count > 0 ? String(count) : ""
        var tooltip = dndEnabled ? "Do Not Disturb" :
                      count === 0 ? "No notifications" :
                      count === 1 ? "1 notification" : count + " notifications"
        var cls = dndEnabled ? "dnd" : count > 0 ? "notification" : "none"

        Process.execute("qs-write-status", [text, tooltip, cls])
    }

    Component.onCompleted: updateStatusFile()
}
