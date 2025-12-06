import QtQuick
import QtQuick.Layouts
import Quickshell.Io

QtObject {
    id: root

    property int activeTag: 0
    property var occupiedTags: []
    property int maxTags: 9

    signal tagChanged(int tag)

    Component.onCompleted: updateTags()

    function updateTags() {
        tagQueryProc.running = true
    }

    function switchToTag(tagIndex) {
        if (tagIndex < 1 || tagIndex > maxTags) return
        switchTagProc.command = ["riverctl", "set-focused-tags", (1 << (tagIndex - 1)).toString()]
        switchTagProc.running = true
    }

    Process {
        id: tagQueryProc
        command: ["sh", "-c", "riverctl list-outputs 2>/dev/null | head -1"]
        
        onExited: {
            if (!stdout) return
            
            activeTagProc.running = true
            occupiedTagsProc.running = true
        }
    }

    Process {
        id: activeTagProc
        command: ["sh", "-c", "riverctl list-outputs 2>/dev/null | head -1"]
        
        onExited: {
            if (!stdout) return
            
            const lines = stdout.split("\n")
            for (let line of lines) {
                if (line.includes("Focused tags:")) {
                    const match = line.match(/Focused tags: (\d+)/)
                    if (match) {
                        const tagBits = parseInt(match[1])
                        for (let i = 0; i < maxTags; i++) {
                            if (tagBits & (1 << i)) {
                                root.activeTag = i + 1
                                break
                            }
                        }
                    }
                }
            }
        }
    }

    Process {
        id: occupiedTagsProc
        command: ["sh", "-c", "riverctl list-outputs 2>/dev/null"]
        
        onExited: {
            if (!stdout) return
            
            let occupied = []
            const lines = stdout.split("\n")
            
            for (let line of lines) {
                if (line.includes("Occupied tags:")) {
                    const match = line.match(/Occupied tags: (\d+)/)
                    if (match) {
                        const tagBits = parseInt(match[1])
                        for (let i = 0; i < maxTags; i++) {
                            if (tagBits & (1 << i)) {
                                occupied.push(i + 1)
                            }
                        }
                    }
                }
            }
            
            root.occupiedTags = occupied
        }
    }

    Process {
        id: switchTagProc
        command: []
        
        onExited: {
            updateTags()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateTags()
    }
}
