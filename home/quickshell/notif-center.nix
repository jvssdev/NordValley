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

  # Main shell entry point
  xdg.configFile."quickshell/shell.qml".text = ''
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Io
    import QtQuick

    ShellRoot {
        NotificationService {}
        MprisService {}
        
        // Notification Center Window
        WaylandWindow {
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
                
                NotificationCenter {
                    anchors.fill: parent
                }
            }
        }
        
        // Simple toggle mechanism usando Process
        Timer {
            id: toggleChecker
            interval: 200
            running: true
            repeat: true
            
            property string lastToggle: ""
            
            onTriggered: {
                var proc = Process.exec("cat", ["/tmp/quickshell-toggle-cmd"])
                if (proc.exitCode === 0) {
                    var content = proc.stdout.trim()
                    if (content && content !== lastToggle) {
                        console.log("Toggle received: " + content)
                        notificationCenter.visible = !notificationCenter.visible
                        console.log("Notification center now: " + (notificationCenter.visible ? "visible" : "hidden"))
                        lastToggle = content
                    }
                }
            }
        }
        
        Component.onCompleted: {
            console.log("Quickshell Notification Center Started")
            console.log("Toggle file: /tmp/quickshell-toggle-cmd")
            console.log("Status file: /tmp/quickshell-notification-status.json")
            
            // Initialize files
            Process.exec("touch", ["/tmp/quickshell-toggle-cmd"])
            Process.exec("sh", ["-c", "echo '' > /tmp/quickshell-toggle-cmd"])
            
            // Force initial status update
            NotificationService.updateStatusFile()
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
            
            onNotification: function(notification) {
                console.log("New Notification")
                console.log("App " + notification.appName)
                console.log("Summary " + notification.summary)
                console.log("Body " + notification.body)
                
                var notif = {
                    id: notification.id,
                    appName: notification.appName || "Unknown",
                    appIcon: notification.appIcon || "",
                    summary: notification.summary || "No title",
                    body: notification.body || "",
                    time: new Date(),
                    actions: notification.actions || []
                }
                
                root.notifications.unshift(notif)
                
                if (root.notifications.length > root.maxNotifications) {
                    root.notifications.pop()
                }
                
                console.log("Total notifications " + root.notifications.length)
                
                root.updateStatusFile()
            }
            
            onNotificationClosed: function(id, reason) {
                console.log("Notification closed " + id + " reason " + reason)
                root.removeNotification(id)
            }
        }
        
        function getUnreadCount() {
            return root.notifications.length
        }
        
        function updateStatusFile() {
            var count = getUnreadCount()
            var iconName = root.dndEnabled ? "dnd" : (count > 0 ? "notification" : "none")
            
            var status = {
                text: count > 0 ? String(count) : "",
                tooltip: root.dndEnabled ? "Do Not Disturb" : 
                         (count > 0 ? String(count) + " notification" + (count > 1 ? "s" : "") : "No notifications"),
                class: iconName
            }
            
            var statusJson = JSON.stringify(status)
            console.log("Updating status " + statusJson)
            
            Process.exec("sh", ["-c", "echo '" + statusJson + "' > /tmp/quickshell-notification-status.json"])
        }
        
        function removeNotification(id) {
            var originalLength = root.notifications.length
            root.notifications = root.notifications.filter(function(n) { return n.id !== id })
            if (root.notifications.length !== originalLength) {
                console.log("Removed notification " + id)
                root.updateStatusFile()
            }
        }
        
        function clearAll() {
            console.log("Clearing all notifications")
            root.notifications = []
            root.updateStatusFile()
        }
        
        function toggleDND() {
            root.dndEnabled = !root.dndEnabled
            console.log("DND " + (root.dndEnabled ? "ON" : "OFF"))
            root.updateStatusFile()
        }
        
        Component.onCompleted: {
            console.log("NotificationService Initialized")
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
        id: root
        color: "#${palette.base00}"
        radius: 10
        border.width: 2
        border.color: "#${palette.base0D}"
        
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
                    text: "Notifications"
                    color: "#${palette.base05}"
                    font.bold: true
                    font.pixelSize: 16
                    verticalAlignment: Text.AlignVCenter
                    height: parent.height
                }
                
                Item { Layout.fillWidth: true }
                
                // DND Toggle
                Rectangle {
                    width: 40
                    height: 30
                    color: NotificationService.dndEnabled ? "#${palette.base08}" : "#${palette.base02}"
                    radius: 5
                    
                    Text {
                        anchors.centerIn: parent
                        text: NotificationService.dndEnabled ? "🔕" : "🔔"
                        font.pixelSize: 16
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: NotificationService.toggleDND()
                        cursorShape: Qt.PointingHandCursor
                    }
                }
                
                // Clear All
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
            
            // Notifications List
            Rectangle {
                width: parent.width
                height: parent.height - 50
                color: "transparent"
                
                ListView {
                    id: notifList
                    anchors.fill: parent
                    spacing: 10
                    clip: true
                    
                    model: NotificationService.notifications
                    
                    delegate: Rectangle {
                        width: notifList.width
                        height: 80
                        color: "#${palette.base01}"
                        radius: 8
                        
                        Column {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 5
                            
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

  # Helper scripts - MELHORADOS
  home.packages = [
    (pkgs.writeShellScriptBin "quickshell-notif-toggle" ''
      #!/usr/bin/env bash
      TOGGLE_FILE="/tmp/quickshell-toggle-cmd"
      echo "toggle-$(date +%s%N)" > "$TOGGLE_FILE"
      echo "Toggle command sent at $(date)"
    '')

    (pkgs.writeShellScriptBin "quickshell-notif-status" ''
      #!/usr/bin/env bash
      STATUS_FILE="/tmp/quickshell-notification-status.json"
      
      if [ ! -f "$STATUS_FILE" ]; then
        echo '{"text":"","tooltip":"No notifications","class":"none"}'
      else
        cat "$STATUS_FILE"
      fi
    '')

    (pkgs.writeShellScriptBin "quickshell-notif-test" ''
      #!/usr/bin/env bash
      echo "Quickshell Notification Test"
      echo ""
      
      echo "1. Quickshell process:"
      pgrep -a quickshell || echo "  NOT RUNNING"
      echo ""
      
      echo "2. Files:"
      ls -lh /tmp/quickshell-* 2>/dev/null || echo "  No files found"
      echo ""
      
      echo "3. Current status:"
      cat /tmp/quickshell-notification-status.json 2>/dev/null | ${pkgs.jq}/bin/jq || echo "  No status"
      echo ""
      
      echo "4. Sending test notification:"
      ${pkgs.libnotify}/bin/notify-send "Test Notification" "This is a test from quickshell"
      sleep 1
      echo ""
      
      echo "5. Updated status:"
      cat /tmp/quickshell-notification-status.json 2>/dev/null | ${pkgs.jq}/bin/jq
      echo ""
      
      echo "6. Testing toggle:"
      quickshell-notif-toggle
      echo "  Check if notification center appeared!"
    '')

    (pkgs.writeShellScriptBin "quickshell-debug" ''
      #!/usr/bin/env bash
      echo "Quickshell Debug Info"
      echo ""
      echo "Quickshell logs:"
      journalctl --user -u quickshell -n 50 --no-pager
    '')
  ];
}
