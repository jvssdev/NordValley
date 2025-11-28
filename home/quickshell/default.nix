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
        Scope {
            property var window: WaylandWindowitem {
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
            }
            
            // Socket listener for toggle commands
            DataStreamParser {
                id: socketListener
                
                Process {
                    id: socketProcess
                    running: true
                    command: [
                        "sh", "-c",
                        "rm -f /tmp/quickshell-notif.sock; " +
                        "while true; do " +
                        "  nc -l -U /tmp/quickshell-notif.sock; " +
                        "  echo toggle; " +
                        "done"
                    ]
                    stdout: SplitParser {
                        onRead: data => {
                            var line = data.trim()
                            console.log("Received command:", line)
                            if (line === "toggle") {
                                notificationCenter.visible = !notificationCenter.visible
                                console.log("Notification center toggled, visible:", notificationCenter.visible)
                            }
                        }
                    }
                }
            }
        }
        
        Component.onCompleted: {
            console.log("Quickshell Notification Center started")
            console.log("Socket path: /tmp/quickshell-notif.sock")
        }
    }
  '';

  # Notification Service
  xdg.configFile."quickshell/NotificationService.qml".text = ''
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
            var iconName = root.dndEnabled ? "dnd" : (count > 0 ? "notification" : "none")
            var status = {
                text: count > 0 ? count.toString() : "",
                tooltip: root.dndEnabled ? "Do Not Disturb" : 
                         (count > 0 ? count + " notification" + (count > 1 ? "s" : "") : "No notifications"),
                class: iconName
            }
            
            var statusJson = JSON.stringify(status)
            
            // Use Process to write file
            Process.execute("sh", ["-c", "mkdir -p /tmp && echo '" + statusJson + "' > /tmp/quickshell-notification-status.json"])
        }
        
        function showNotificationPopup(notification) {
            console.log("Showing notification popup for:", notification.summary)
        }
        
        function removeNotification(id) {
            var originalLength = root.notifications.length
            root.notifications = root.notifications.filter(n => n.id !== id)
            if (root.notifications.length !== originalLength) {
                console.log("Removed notification:", id)
            }
        }
        
        function clearAll() {
            console.log("Clearing all notifications, count:", root.notifications.length)
            root.notifications = []
            updateStatusFile()
        }
        
        function toggleDND() {
            root.dndEnabled = !root.dndEnabled
            console.log("Do Not Disturb:", root.dndEnabled ? "enabled" : "disabled")
            updateStatusFile()
        }
        
        Component.onCompleted: {
            console.log("NotificationService initialized")
            updateStatusFile()
        }
        
        Timer {
            interval: 5000
            running: true
            repeat: true
            onTriggered: {
                console.log("Status - Notifications:", root.notifications.length, "DND:", root.dndEnabled)
            }
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
                
                Item { width: parent.width - 200 }
                
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
            ListView {
                width: parent.width
                height: parent.height - 170
                spacing: 10
                clip: true
                
                model: NotificationService.notifications
                
                delegate: Rectangle {
                    width: parent.width
                    height: 80
                    color: "#${palette.base01}"
                    radius: 8
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10
                        
                        Column {
                            spacing: 5
                            width: parent.width - 20
                            
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

  # Helper scripts
  home.packages = [
    (pkgs.writeShellScriptBin "quickshell-notif-toggle" ''
      #!/usr/bin/env bash
      echo "toggle" | ${pkgs.netcat}/bin/nc -U /tmp/quickshell-notif.sock 2>/dev/null || {
        echo "Error: Could not connect to quickshell socket"
        echo "Is quickshell running?"
        exit 1
      }
    '')

    (pkgs.writeShellScriptBin "quickshell-notif-status" ''
      #!/usr/bin/env bash

      STATUS_FILE="/tmp/quickshell-notification-status.json"

      # Initialize status file if it doesn't exist
      if [ ! -f "$STATUS_FILE" ]; then
        mkdir -p /tmp
        echo '{"text":"","tooltip":"No notifications","class":"none"}' > "$STATUS_FILE"
      fi

      # Watch for changes and output status
      ${pkgs.inotify-tools}/bin/inotifywait -m -e modify,create "$STATUS_FILE" 2>/dev/null | while read; do
        if [ -f "$STATUS_FILE" ]; then
          cat "$STATUS_FILE"
        fi
      done
    '')

    (pkgs.writeShellScriptBin "quickshell-test" ''
      #!/usr/bin/env bash
      echo "=== Quickshell Notification Center Debug ==="
      echo ""
      echo "1. Checking if quickshell is running:"
      pgrep -a quickshell || echo "  ❌ Quickshell is NOT running"
      echo ""
      echo "2. Checking socket file:"
      [ -S /tmp/quickshell-notif.sock ] && echo "  ✅ Socket exists" || echo "  ❌ Socket does not exist"
      echo ""
      echo "3. Checking status file:"
      if [ -f /tmp/quickshell-notification-status.json ]; then
        echo "  ✅ Status file exists"
        echo "  Content:"
        cat /tmp/quickshell-notification-status.json | ${pkgs.jq}/bin/jq 2>/dev/null || cat /tmp/quickshell-notification-status.json
      else
        echo "  ❌ Status file does not exist"
      fi
      echo ""
      echo "4. Testing toggle command:"
      quickshell-notif-toggle && echo "  ✅ Toggle successful" || echo "  ❌ Toggle failed"
      echo ""
      echo "5. Sending test notification:"
      ${pkgs.libnotify}/bin/notify-send "Test" "This is a test notification"
    '')
  ];
}
