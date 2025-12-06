import QtQuick
import QtQuick.Layouts
import Quickshell.Io

QtObject {
    id: root

    property int activeTag: 1
    property var occupiedTags: []
    property int maxTags: 9

    signal tagChanged(int tag)

    Component.onCompleted: updateTags()

    function updateTags() {
        tagQueryProc.running = true
    }

    function switchToTag(tagIndex) {
        if (tagIndex < 1 || tagIndex > maxTags) return
        switchTagProc.command = ["dwlmsg", "tag", "view", tagIndex.toString()]
        switchTagProc.running = true
    }

    Process {
        id: tagQueryProc
        command: ["sh", "-c", "dwlmsg tag status 2>/dev/null || echo 'error'"]
        
        onExited: {
            if (!stdout || stdout.includes("error")) {
                tryMangoWCQuery()
                return
            }
            
            parseDWLOutput(stdout)
        }
    }

    function tryMangoWCQuery() {
        mangoWCQueryProc.running = true
    }

    Process {
        id: mangoWCQueryProc
        command: ["sh", "-c", "mangowcctl tag status 2>/dev/null || echo 'error'"]
        
        onExited: {
            if (!stdout || stdout.includes("error")) {
                return
            }
            
            parseMangoWCOutput(stdout)
        }
    }

    function parseDWLOutput(output) {
        const lines = output.split("\n")
        let occupied = []
        let active = 1
        
        for (let line of lines) {
            const parts = line.trim().split(/\s+/)
            if (parts.length >= 3) {
                const tagNum = parseInt(parts[0])
                const isOccupied = parts[1] === "1" || parts[1] === "occupied"
                const isActive = parts[2] === "1" || parts[2] === "active"
                
                if (isOccupied) occupied.push(tagNum)
                if (isActive) active = tagNum
            }
        }
        
        root.occupiedTags = occupied
        root.activeTag = active
    }

    function parseMangoWCOutput(output) {
        const lines = output.split("\n")
        let occupied = []
        let active = 1
        
        for (let line of lines) {
            if (line.includes("tag")) {
                const match = line.match(/tag(\d+).*active/)
                if (match) {
                    active = parseInt(match[1])
                }
                
                const occupiedMatch = line.match(/tag(\d+)/)
                if (occupiedMatch) {
                    occupied.push(parseInt(occupiedMatch[1]))
                }
            }
        }
        
        root.occupiedTags = occupied
        root.activeTag = active
    }

    Process {
        id: switchTagProc
        command: []
        
        onExited: {
            Qt.callLater(updateTags)
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateTags()
    }
}
