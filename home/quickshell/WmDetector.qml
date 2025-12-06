import QtQuick
import Quickshell.Io

QtObject {
    id: root

    readonly property int typeUnknown: 0
    readonly property int typeRiver: 1
    readonly property int typeNiri: 2
    readonly property int typeMangoWC: 3
    readonly property int typeDWL: 4

    property int detectedWm: typeUnknown
    property string wmName: "Unknown"
    property bool isDetecting: true

    signal wmDetected(int wmType, string name)

    Component.onCompleted: detectWm()

    function detectWm() {
        isDetecting = true
        wmDetectionProc.running = true
    }

    Process {
        id: wmDetectionProc
        command: ["sh", "-c", "echo $XDG_CURRENT_DESKTOP; pgrep -x river && echo river; pgrep -x niri && echo niri; pgrep -x mangowc && echo mangowc; pgrep -x dwl && echo dwl"]
        
        onExited: {
            if (!stdout) {
                console.log("WM Detection: Failed to detect")
                isDetecting = false
                return
            }

            const output = stdout.toLowerCase().trim()
            
            if (output.includes("river")) {
                root.detectedWm = root.typeRiver
                root.wmName = "River"
            } else if (output.includes("niri")) {
                root.detectedWm = root.typeNiri
                root.wmName = "Niri"
            } else if (output.includes("mangowc")) {
                root.detectedWm = root.typeMangoWC
                root.wmName = "MangoWC"
            } else if (output.includes("dwl")) {
                root.detectedWm = root.typeDWL
                root.wmName = "DWL"
            } else {
                root.detectedWm = root.typeUnknown
                root.wmName = "Unknown"
            }

            console.log("WM Detection: Detected", root.wmName)
            isDetecting = false
            root.wmDetected(root.detectedWm, root.wmName)
        }
    }

    function isRiver() { return detectedWm === typeRiver }
    function isNiri() { return detectedWm === typeNiri }
    function isMangoWC() { return detectedWm === typeMangoWC }
    function isDWL() { return detectedWm === typeDWL }
    function isSupported() { return detectedWm !== typeUnknown }
}
