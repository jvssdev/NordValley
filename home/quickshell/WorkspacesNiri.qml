import QtQuick
import QtQuick.Layouts
import Quickshell.Io

QtObject {
    id: root

    property int activeWorkspace: 1
    property var workspaces: []

    signal workspaceChanged(int workspace)

    Component.onCompleted: updateWorkspaces()

    function updateWorkspaces() {
        workspaceQueryProc.running = true
    }

    function switchToWorkspace(index) {
        if (index < 1) return
        switchWorkspaceProc.command = ["niri", "msg", "action", "focus-workspace", index.toString()]
        switchWorkspaceProc.running = true
    }

    Process {
        id: workspaceQueryProc
        command: ["niri", "msg", "--json", "workspaces"]
        
        onExited: {
            if (!stdout) return
            
            try {
                const data = JSON.parse(stdout)
                let wsList = []
                let activeIdx = 1
                
                if (Array.isArray(data)) {
                    for (let i = 0; i < data.length; i++) {
                        const ws = data[i]
                        wsList.push({
                            id: ws.id || (i + 1),
                            name: ws.name || `${i + 1}`,
                            output: ws.output || "",
                            isActive: ws.is_active || false,
                            isEmpty: !ws.has_windows
                        })
                        
                        if (ws.is_active) {
                            activeIdx = ws.id || (i + 1)
                        }
                    }
                }
                
                root.workspaces = wsList
                root.activeWorkspace = activeIdx
            } catch (e) {
                console.error("Niri workspaces parse error:", e)
            }
        }
    }

    Process {
        id: switchWorkspaceProc
        command: []
        
        onExited: {
            Qt.callLater(updateWorkspaces)
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: root.updateWorkspaces()
    }
}
