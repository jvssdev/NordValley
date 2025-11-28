{
  config,
  pkgs,
  lib,
  homeDir,
  isRiver,
  isMango,
  ...
}:
let
  palette = config.colorScheme.palette;
in
{
  # Create qmldir for Singleton declarations
  xdg.configFile."quickshell/qmldir".text = ''
    singleton IdleService 1.0 IdleService.qml
    singleton NotificationService 1.0 NotificationService.qml
    singleton MprisService 1.0 MprisService.qml
  '';

  # Main shell entry point
  xdg.configFile."quickshell/shell.qml".text = ''
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Io

    ShellRoot {
        IdleService {}
        NotificationService {}
        MprisService {}
        
        // Notification Center Window
        WaylandWindowitem {
            id: notificationCenter
            visible: false
            
            PanelWindow {
                anchors {
                    top: true
                    right: true
                    margins: 10
                }
                
                width: 400
                height: 600
                
                color: "#${palette.base00}"
                
                NotificationCenter {}
            }
            
            // Toggle visibility when receiving IPC signal
            Connections {
                target: NotificationService
                function onToggleRequested() {
                    notificationCenter.visible = !notificationCenter.visible
                }
            }
        }
        
        // IPC Server for waybar integration
        Process {
            id: ipcServer
            running: true
            command: ["sh", "-c", "while true; do read line; echo toggle; done"]
            stdin: Process.Buffer
            stdout: Process.Buffer
            
            onStdout: data => {
                if (data.trim() === "toggle") {
                    notificationCenter.visible = !notificationCenter.visible
                }
            }
        }
    }
  '';

  # Notification Service
  xdg.configFile."quickshell/NotificationService.qml".text = ''
    pragma Singleton
    import QtQuick
    import Quickshell
    import Quickshell.Services.Notifications

    Singleton {
        id: root
        
        property var notifications: []
        property int maxNotifications: 50
        property bool dndEnabled: false
        
        signal toggleRequested()
        
        NotificationServer {
            id: notifServer
            
            onNotification: notification => {
                console.log("New notification:", notification.summary)
                
                // Add to list
                root.notifications.unshift({
                    id: notification.id,
                    appName: notification.appName,
                    appIcon: notification.appIcon,
                    summary: notification.summary,
                    body: notification.body,
                    time: new Date(),
                    actions: notification.actions
                })
                
                // Limit size
                if (root.notifications.length > root.maxNotifications) {
                    root.notifications.pop()
                }
                
                // Show popup only if DND is disabled
                if (!root.dndEnabled) {
                    showNotificationPopup(notification)
                }
                
                // Update status file for waybar
                updateStatusFile()
            }
            
            onNotificationClosed: (id, reason) => {
                console.log("Notification closed:", id)
                removeNotification(id)
                updateStatusFile()
            }
        }
        
        function getUnreadCount() {
            return root.notifications.length
        }
        
        function updateStatusFile() {
            var count = getUnreadCount()
            var status = {
                text: count > 0 ? count.toString() : "",
                tooltip: count > 0 ? count + " notification" + (count > 1 ? "s" : "") : "No notifications",
                class: root.dndEnabled ? "dnd" : (count > 0 ? "notification" : "none")
            }
            
            // Write to temporary status file
            var statusJson = JSON.stringify(status)
            Process.execute("sh", ["-c", "echo '" + statusJson + "' > /tmp/quickshell-notification-status.json"])
        }
        
        function showNotificationPopup(notification) {
            // Create temporary popup window
            var popup = Qt.createQmlObject('
                import Quickshell
                import Quickshell.Wayland
                import QtQuick
                
                WaylandWindowitem {
                    visible: true
                    
                    PanelWindow {
                        anchors {
                            top: true
                            right: true
                            margins: 10
                        }
                        
                        width: 350
                        height: 100
                        
                        Rectangle {
                            anchors.fill: parent
                            color: "#${palette.base01}"
                            radius: 10
                            border.color: "#${palette.base03}"
                            border.width: 1
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 10
                                
                                Image {
                                    width: 48
                                    height: 48
                                    source: "' + notification.appIcon + '"
                                    fillMode: Image.PreserveAspectFit
                                }
                                
                                Column {
                                    spacing: 5
                                    width: parent.width - 68
                                    
                                    Text {
                                        text: "' + notification.summary + '"
                                        color: "#${palette.base05}"
                                        font.bold: true
                                        font.pixelSize: 14
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }
                                    
                                    Text {
                                        text: "' + notification.body + '"
                                        color: "#${palette.base04}"
                                        font.pixelSize: 12
                                        wrapMode: Text.WordWrap
                                        maximumLineCount: 2
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }
                                }
                            }
                        }
                        
                        Timer {
                            interval: 5000
                            running: true
                            onTriggered: parent.parent.destroy()
                        }
                    }
                }
            ', root)
        }
        
        function removeNotification(id) {
            root.notifications = root.notifications.filter(n => n.id !== id)
        }
        
        function clearAll() {
            root.notifications = []
            updateStatusFile()
        }
        
        function toggleDND() {
            root.dndEnabled = !root.dndEnabled
            console.log("Do Not Disturb:", root.dndEnabled ? "enabled" : "disabled")
            updateStatusFile()
            
            // Show DND status notification
            var statusMsg = root.dndEnabled ? "Do Not Disturb enabled" : "Do Not Disturb disabled"
            showDNDStatusPopup(statusMsg)
        }
        
        function showDNDStatusPopup(message) {
            var popup = Qt.createQmlObject('
                import Quickshell
                import Quickshell.Wayland
                import QtQuick
                
                WaylandWindowitem {
                    visible: true
                    
                    PanelWindow {
                        anchors.centerIn: parent
                        
                        width: 300
                        height: 80
                        
                        Rectangle {
                            anchors.fill: parent
                            color: "#${palette.base01}"
                            radius: 10
                            border.color: "#${palette.base0D}"
                            border.width: 2
                            
                            Column {
                                anchors.centerIn: parent
                                spacing: 8
                                
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: "🔕"
                                    font.pixelSize: 32
                                }
                                
                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: "' + message + '"
                                    color: "#${palette.base05}"
                                    font.bold: true
                                    font.pixelSize: 14
                                }
                            }
                        }
                        
                        Timer {
                            interval: 2000
                            running: true
                            onTriggered: parent.parent.destroy()
                        }
                    }
                }
            ', root)
        }
        
        Component.onCompleted: {
            updateStatusFile()
        }
    }
  '';

  # MPRIS Service
  xdg.configFile."quickshell/MprisService.qml".text = ''
    pragma Singleton
    import QtQuick
    import Quickshell
    import Quickshell.Services.Mpris

    Singleton {
        id: root
        
        property var players: []
        property var activePlayer: null
        
        Mpris {
            id: mpris
            
            onPlayersChanged: {
                root.players = []
                for (var i = 0; i < mpris.players.length; i++) {
                    var player = mpris.players[i]
                    root.players.push(player)
                    
                    if (!root.activePlayer && player.playbackState === MprisPlaybackState.Playing) {
                        root.activePlayer = player
                    }
                }
            }
        }
        
        function togglePlayPause() {
            if (root.activePlayer) {
                root.activePlayer.togglePlaying()
            }
        }
        
        function next() {
            if (root.activePlayer) {
                root.activePlayer.next()
            }
        }
        
        function previous() {
            if (root.activePlayer) {
                root.activePlayer.previous()
            }
        }
    }
  '';

  # Notification Center UI
  xdg.configFile."quickshell/NotificationCenter.qml".text = ''
    import QtQuick
    import Quickshell

    Rectangle {
        anchors.fill: parent
        color: "#${palette.base00}"
        radius: 10
        
        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10
            
            // Header
            Row {
                width: parent.width
                height: 40
                spacing: 10
                
                Text {
                    text: "Notification Center"
                    color: "#${palette.base05}"
                    font.bold: true
                    font.pixelSize: 18
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                }
                
                Item { Layout.fillWidth: true }
                
                // DND Toggle Button
                Rectangle {
                    width: 40
                    height: 30
                    color: NotificationService.dndEnabled ? "#${palette.base08}" : "#${palette.base02}"
                    radius: 5
                    
                    Text {
                        anchors.centerIn: parent
                        text: "🔕"
                        font.pixelSize: 16
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: NotificationService.toggleDND()
                        cursorShape: Qt.PointingHandCursor
                    }
                }
                
                // Clear All Button
                Rectangle {
                    width: 80
                    height: 30
                    color: "#${palette.base02}"
                    radius: 5
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Clear All"
                        color: "#${palette.base05}"
                        font.pixelSize: 12
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: NotificationService.clearAll()
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
            
            // MPRIS Player Widget
            Rectangle {
                width: parent.width
                height: 120
                color: "#${palette.base01}"
                radius: 8
                visible: MprisService.activePlayer !== null
                
                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 8
                    
                    Text {
                        text: MprisService.activePlayer ? MprisService.activePlayer.title : ""
                        color: "#${palette.base05}"
                        font.bold: true
                        font.pixelSize: 14
                        elide: Text.ElideRight
                        width: parent.width
                    }
                    
                    Text {
                        text: MprisService.activePlayer ? MprisService.activePlayer.artist : ""
                        color: "#${palette.base04}"
                        font.pixelSize: 12
                        elide: Text.ElideRight
                        width: parent.width
                    }
                    
                    Row {
                        spacing: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Rectangle {
                            width: 40
                            height: 40
                            color: "#${palette.base02}"
                            radius: 20
                            
                            Text {
                                anchors.centerIn: parent
                                text: "⏮"
                                color: "#${palette.base05}"
                                font.pixelSize: 18
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: MprisService.previous()
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                        
                        Rectangle {
                            width: 40
                            height: 40
                            color: "#${palette.base0D}"
                            radius: 20
                            
                            Text {
                                anchors.centerIn: parent
                                text: MprisService.activePlayer && 
                                      MprisService.activePlayer.playbackState === MprisPlaybackState.Playing 
                                      ? "⏸" : "▶"
                                color: "#${palette.base00}"
                                font.pixelSize: 18
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: MprisService.togglePlayPause()
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                        
                        Rectangle {
                            width: 40
                            height: 40
                            color: "#${palette.base02}"
                            radius: 20
                            
                            Text {
                                anchors.centerIn: parent
                                text: "⏭"
                                color: "#${palette.base05}"
                                font.pixelSize: 18
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: MprisService.next()
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }
                }
            }
            
            // Notifications List
            ScrollView {
                width: parent.width
                height: parent.height - 170
                
                Column {
                    width: parent.width
                    spacing: 10
                    
                    Repeater {
                        model: NotificationService.notifications
                        
                        Rectangle {
                            width: parent.width
                            height: 80
                            color: "#${palette.base01}"
                            radius: 8
                            
                            Row {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 10
                                
                                Image {
                                    width: 48
                                    height: 48
                                    source: modelData.appIcon
                                    fillMode: Image.PreserveAspectFit
                                }
                                
                                Column {
                                    spacing: 5
                                    width: parent.width - 68
                                    
                                    Text {
                                        text: modelData.summary
                                        color: "#${palette.base05}"
                                        font.bold: true
                                        font.pixelSize: 13
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }
                                    
                                    Text {
                                        text: modelData.body
                                        color: "#${palette.base04}"
                                        font.pixelSize: 11
                                        wrapMode: Text.WordWrap
                                        maximumLineCount: 2
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }
                                    
                                    Text {
                                        text: Qt.formatTime(modelData.time, "hh:mm")
                                        color: "#${palette.base03}"
                                        font.pixelSize: 10
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
  '';

  # Idle monitoring service
  xdg.configFile."quickshell/IdleService.qml".text = ''
    pragma Singleton
    import QtQuick
    import Quickshell
    import Quickshell.Wayland

    Singleton {
        id: root
        property int monitorTimeout: 240000
        property int lockTimeout: 300000
        property int suspendTimeout: 600000
        
        IdleMonitor {
            id: monitorOffMonitor
            enabled: true
            respectInhibitors: true
            timeout: root.monitorTimeout
            onIsIdleChanged: {
                if (isIdle) {
                    console.log("Turning off monitors...")
                    Process.execute("${pkgs.wlopm}/bin/wlopm", ["--off", "*"])
                } else {
                    console.log("Turning on monitors...")
                    Process.execute("${pkgs.wlopm}/bin/wlopm", ["--on", "*"])
                }
            }
        }
        
        IdleMonitor {
            id: lockMonitor
            enabled: true
            respectInhibitors: true
            timeout: root.lockTimeout
            onIsIdleChanged: {
                if (isIdle) {
                    console.log("Locking with gtklock...")
                    Process.execute("${pkgs.gtklock}/bin/gtklock", ["-d"])
                }
            }
        }
        
        IdleMonitor {
            id: suspendMonitor
            enabled: true
            respectInhibitors: true
            timeout: root.suspendTimeout
            onIsIdleChanged: {
                if (isIdle) {
                    console.log("Suspending system...")
                    Process.execute("${pkgs.systemd}/bin/systemctl", ["suspend"])
                }
            }
        }
    }
  '';

  home.packages = [
    (pkgs.writeShellScriptBin "quickshell-notification-status" ''
      #!/usr/bin/env bash

      STATUS_FILE="/tmp/quickshell-notification-status.json"

      # Initialize status file if it doesn't exist
      if [ ! -f "$STATUS_FILE" ]; then
        echo '{"text":"","tooltip":"No notifications","class":"none"}' > "$STATUS_FILE"
      fi

      # Watch for changes and output status
      while true; do
        if [ -f "$STATUS_FILE" ]; then
          cat "$STATUS_FILE"
        fi
        sleep 0.5
      done
    '')

    (pkgs.writeShellScriptBin "quickshell-notification-toggle" ''
      #!/usr/bin/env bash

      # Send signal to quickshell to toggle notification center
      pkill -SIGUSR1 quickshell || true

      # Alternative: use a socket or named pipe if available
      # echo "toggle" > /tmp/quickshell-notification-toggle
    '')
  ];
}
