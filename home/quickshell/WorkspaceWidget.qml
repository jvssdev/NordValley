import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root

    required property QtObject theme
    required property QtObject wmDetector
    
    property QtObject workspaceManager: null

    spacing: theme.spacing / 2

    Component.onCompleted: {
        wmDetector.wmDetected.connect(onWmDetected)
        if (wmDetector.isSupported() && !wmDetector.isDetecting) {
            setupWorkspaceManager()
        }
    }

    function onWmDetected(wmType, name) {
        setupWorkspaceManager()
    }

    function setupWorkspaceManager() {
        if (wmDetector.isRiver()) {
            const component = Qt.createComponent("WorkspacesRiver.qml")
            if (component.status === Component.Ready) {
                workspaceManager = component.createObject(root)
            }
        } else if (wmDetector.isNiri()) {
            const component = Qt.createComponent("WorkspacesNiri.qml")
            if (component.status === Component.Ready) {
                workspaceManager = component.createObject(root)
            }
        } else if (wmDetector.isMangoWC() || wmDetector.isDWL()) {
            const component = Qt.createComponent("WorkspacesDWL.qml")
            if (component.status === Component.Ready) {
                workspaceManager = component.createObject(root)
            }
        }
    }

    Repeater {
        model: getWorkspaceModel()

        Rectangle {
            Layout.preferredWidth: 28
            Layout.preferredHeight: 20
            radius: 6
            
            color: isActive() ? root.theme.blue : (isOccupied() ? root.theme.bgLighter : "transparent")
            border.color: root.theme.fgSubtle
            border.width: isActive() ? 0 : 1

            function isActive() {
                if (!root.workspaceManager) return false
                
                if (root.wmDetector.isNiri()) {
                    return root.workspaceManager.activeWorkspace === modelData.id
                } else {
                    return root.workspaceManager.activeTag === modelData
                }
            }

            function isOccupied() {
                if (!root.workspaceManager) return false
                
                if (root.wmDetector.isNiri()) {
                    return !modelData.isEmpty
                } else {
                    return root.workspaceManager.occupiedTags.indexOf(modelData) !== -1
                }
            }

            Text {
                anchors.centerIn: parent
                text: getWorkspaceLabel()
                color: parent.isActive() ? root.theme.bg : root.theme.fg
                font {
                    family: root.theme.font.family
                    pixelSize: 11
                    bold: parent.isActive()
                }

                function getWorkspaceLabel() {
                    if (root.wmDetector.isNiri()) {
                        return modelData.name || modelData.id
                    } else {
                        return modelData
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (!root.workspaceManager) return
                    
                    if (root.wmDetector.isNiri()) {
                        root.workspaceManager.switchToWorkspace(modelData.id)
                    } else {
                        root.workspaceManager.switchToTag(modelData)
                    }
                }
            }
        }
    }

    function getWorkspaceModel() {
        if (!root.workspaceManager) return []
        
        if (root.wmDetector.isNiri()) {
            return root.workspaceManager.workspaces || []
        } else {
            return [1, 2, 3, 4, 5, 6, 7, 8, 9]
        }
    }

    Text {
        visible: !root.wmDetector.isSupported()
        text: "WM not supported"
        color: root.theme.fgMuted
        font {
            family: root.theme.font.family
            pixelSize: root.theme.font.pixelSize - 2
        }
    }
}
