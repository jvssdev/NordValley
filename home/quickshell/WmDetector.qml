import QtQuick
import Quickshell.Io

QtObject {
    id: root

    enum WmType {
        Unknown,
        River,
        Niri,
        MangoWC,
        DWL
    }

    property int detectedWm: WmDetector.WmType.Unknown
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
                root.detectedWm = WmDetector.WmType.River
                root.wmName = "River"
            } else if (output.includes("niri")) {
                root.detectedWm = WmDetector.WmType.Niri
                root.wmName = "Niri"
            } else if (output.includes("mangowc")) {
                root.detectedWm = WmDetector.WmType.MangoWC
                root.wmName = "MangoWC"
            } else if (output.includes("dwl")) {
                root.detectedWm = WmDetector.WmType.DWL
                root.wmName = "DWL"
            } else {
                root.detectedWm = WmDetector.WmType.Unknown
                root.wmName = "Unknown"
            }

            console.log("WM Detection: Detected", root.wmName)
            isDetecting = false
            root.wmDetected(root.detectedWm, root.wmName)
        }
    }

    function isRiver() { return detectedWm === WmDetector.WmType.River }
    function isNiri() { return detectedWm === WmDetector.WmType.Niri }
    function isMangoWC() { return detectedWm === WmDetector.WmType.MangoWC }
    function isDWL() { return detectedWm === WmDetector.WmType.DWL }
    function isSupported() { return detectedWm !== WmDetector.WmType.Unknown }
}
