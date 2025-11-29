{
  config,
  pkgs,
  lib,
  ...
}:
let
  palette = config.colorScheme.palette;
in
{
  # Create qmldir for Singleton declarations
  xdg.configFile."quickshell/qmldir".text = ''
    singleton NotificationService 1.0 NotificationService.qml
    singleton MprisService 1.0 MprisService.qml
  '';

  # Main shell entry point for notification center
  xdg.configFile."quickshell/shell.qml".text = ''
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Io

    ShellRoot {
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
        }
        
        // File watcher for toggle command
        Timer {
            id: toggleFileWatcher
            interval: 100
            running: true
            repeat: true
            
            property string lastContent: ""
            
            onTriggered: {
                var result = Process.execute("cat", ["/tmp/quickshell-toggle-cmd"])
                if (result.exitCode === 0) {
                    var content = result.stdout.trim()
                    if (content && content !== lastContent) {
                        console.log("Toggle command received:", content)
                        notificationCenter.visible = !notificationCenter.visible
                        console.log("Notification center visible:", notificationCenter.visible)
                        lastContent = content
                    }
                }
            }
        }
        
        Component.onCompleted: {
            console.log("Quickshell Notification Center started")
            console.log("Toggle file: /tmp/quickshell-toggle-cmd")
            console.log("Status file: /tmp/quickshell-notification-status.json")
            
            // Initialize toggle file
            Process.execute("touch", ["/tmp/quickshell-toggle-cmd"])
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
        
        NotificationServer {
            id: notifServer
            
            onNotification: notification => {
                console.log("New notification:", notification.summary)
                
                root.notifications.unshift({
                    id: notification.id,
                    appName: notification.appName,
                    appIcon: notification.appIcon,
                    summary: notification.summary,
                    body: notification.body,
                    time: new Date(),
                    actions: notification.actions
                })
                
                if (root.notifications.length > root.maxNotifications) {
                    root.notifications.pop()
                }
                
                if (!root.dndEnabled) {
                    console.log("Would show popup for:", notification.summary)
                }
                
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
            Process.execute("sh", ["-c", "echo '" + statusJson + "' > /tmp/quickshell-notification-status.json"])
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

  # Helper scripts
  home.packages = [
    (pkgs.writeShellScriptBin "quickshell-notif-toggle" ''
      #!/usr/bin/env bash

      TOGGLE_FILE="/tmp/quickshell-toggle-cmd"

      # Create file if doesn't exist
      touch "$TOGGLE_FILE"

      # Write toggle command with timestamp
      echo "toggle-$(date +%s%N)" > "$TOGGLE_FILE"

      echo "Toggle command sent"
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

    (pkgs.writeShellScriptBin "quickshell-notif-test" ''
      #!/usr/bin/env bash
      echo "=== Quickshell Notification Center Test ==="
      echo ""
      echo "1. Checking if quickshell is running:"
      if pgrep -a quickshell; then
        echo "  ✅ Quickshell is running"
      else
        echo "  ❌ Quickshell is NOT running"
      fi
      echo ""
      echo "2. Checking files:"
      [ -f /tmp/quickshell-toggle-cmd ] && echo "  ✅ Toggle file exists" || echo "  ❌ Toggle file missing"
      [ -f /tmp/quickshell-notification-status.json ] && echo "  ✅ Status file exists" || echo "  ❌ Status file missing"
      echo ""
      echo "3. Status content:"
      cat /tmp/quickshell-notification-status.json 2>/dev/null | ${pkgs.jq}/bin/jq || echo "  No status file"
      echo ""
      echo "4. Testing toggle:"
      quickshell-notif-toggle
      sleep 0.5
      echo "  Check if notification center appeared!"
      echo ""
      echo "5. Sending test notification:"
      ${pkgs.libnotify}/bin/notify-send "Test" "Test notification from quickshell"
    '')
  ];
}
