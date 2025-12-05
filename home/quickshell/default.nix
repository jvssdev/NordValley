{
  config,
  pkgs,
  lib,
  ...
}:
let
  palette = config.colorScheme.palette;
  formatColor = c: "#${lib.strings.substring 0 6 c}";

  theme = {
    colBg = formatColor palette.base00;
    colFg = formatColor palette.base05;
    colMuted = formatColor palette.base03;
    colCyan = formatColor palette.base0C;
    colPurple = formatColor palette.base0E;
    colRed = formatColor palette.base08;
    colYellow = formatColor palette.base0A;
    colBlue = formatColor palette.base0D;
    fontFamily = "JetBrainsMono Nerd Font";
    fontSize = 14;
  };

  shellQml = ''
    import QtQuick
    import QtQuick.Layouts
    import QtQml
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Io

    ShellRoot {
        id: root

        QtObject {
          id: theme
          readonly property color colBg: "${theme.colBg}"
          readonly property color colFg: "${theme.colFg}"
          readonly property color colMuted: "${theme.colMuted}"
          readonly property color colCyan: "${theme.colCyan}"
          readonly property color colPurple: "${theme.colPurple}"
          readonly property color colRed: "${theme.colRed}"
          readonly property color colYellow: "${theme.colYellow}"
          readonly property color colBlue: "${theme.colBlue}"
          readonly property string fontFamily: "${theme.fontFamily}"
          readonly property int fontSize: ${toString theme.fontSize}
        }
        
        QtObject {
            id: makoDnd
            property bool isDnd: false

            Process {
                id: makoProc
                command: ["makoctl", "mode"]
                onExited: makoDnd.isDnd = stdout.trim() === "do-not-disturb"
            }

            Timer {
                interval: 1000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: makoProc.running = true
            }
        }

        QtObject {
            id: btInfo
            property bool connected: false

            Process {
                id: btProc
                command: ["bluetoothctl", "info"]
                onExited: btInfo.connected = stdout.includes("Connected: yes")
            }

            Timer {
                interval: 5000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: btProc.running = true
            }
        }

        QtObject {
            id: volume
            property int level: 0
            property bool muted: false

            Process {
                id: volumeProc
                command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
                onExited: {
                    const out = stdout.trim()
                    volume.muted = out.includes("[MUTED]")
                    const match = out.match(/Volume: ([0-9.]+)/)
                    if (match) volume.level = Math.round(parseFloat(match[1]) * 100)
                }
            }

            Timer {
                interval: 1000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: volumeProc.running = true
            }
        }
        
        QtObject {
            id: battery
            property int percentage: 0
            property string icon: "󰂎"
            property bool charging: false

            Timer {
                interval: 10000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    batCapacityProc.running = true
                    batStatusProc.running = true
                }
            }
            
            Process {
                id: batCapacityProc
                command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo 0"]
                onExited: battery.percentage = parseInt(stdout.trim()) || 0
            }

            Process {
                id: batStatusProc
                command: ["sh", "-c", "cat /sys/class/power_supply/BAT*/status 2>/dev/null || echo Discharging"]
                onExited: battery.charging = stdout.trim() === "Charging"
            }
            
            onPercentageChanged: {
                if (percentage === 0) icon = "󰁹"
                else if (percentage <= 10) icon = "󰂎"
                else if (percentage <= 30) icon = "󰁻"
                else if (percentage <= 50) icon = "󰁽"
                else if (percentage <= 70) icon = "󰁾"
                else if (percentage <= 90) icon = "󰂀"
                else icon = "󰂂"
            }
        }

        QtObject {
            id: cpu
            property int usage: 0

            Process {
                id: cpuProc
                command: ["top", "-bn1"]
                onExited: {
                    const lines = stdout.split("\n")
                    for (let line of lines) {
                        if (line.includes("%Cpu")) {
                            const parts = line.split(/\s+/)
                            usage = Math.round(100 - parseFloat(parts[7]))
                            break
                        }
                    }
                }
            }

            Timer {
                interval: 2000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: cpuProc.running = true
            }
        }

        QtObject {
            id: mem
            property int percent: 0

            Process {
                id: memProc
                command: ["free"]
                onExited: {
                    const line = stdout.split("\n")[1] || ""
                    const parts = line.split(/\s+/)
                    const total = parseInt(parts[1]) || 1
                    const used = parseInt(parts[2]) || 0
                    percent = Math.round(used / total * 100)
                }
            }

            Timer {
                interval: 2000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: memProc.running = true
            }
        }

        QtObject {
            id: disk
            property int percent: 0

            Process {
                id: diskProc
                command: ["sh", "-c", "df / | tail -1"]
                onExited: {
                    const line = stdout.split("\n")[0] || ""
                    const parts = line.split(/\s+/)
                    var percentStr = parts[4] || "0%"
                    disk.percent = parseInt(percentStr.replace("%", "")) || 0
                }
            }

            Timer {
                interval: 10000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: diskProc.running = true
            }
        }

        Variants {
            model: Quickshell.screens

            PanelWindow {
                property var modelData
                screen: modelData

                anchors { top: true; left: true; right: true }

                height: 30
                color: theme.colBg

                margins {
                    top: 0
                    bottom: 0
                    left: 0
                    right: 0
                }

                Rectangle {
                    anchors.fill: parent
                    color: theme.colBg

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0

                        Item { width: 8 }

                        Text {
                            text: "~"
                            color: theme.colPurple
                            font.pixelSize: theme.fontSize + 4
                            font.family: theme.fontFamily
                            font.bold: true
                        }

                        Item { width: 16 }

                        Text {
                            id: clockText
                            text: Qt.formatDateTime(new Date(), "HH:mm dd/MM")
                            color: theme.colCyan
                            font.pixelSize: theme.fontSize
                            font.family: theme.fontFamily
                            font.bold: true
                            Layout.fillWidth: true

                            Timer {
                                interval: 1000
                                running: true
                                repeat: true
                                onTriggered: clockText.text = Qt.formatDateTime(new Date(), "HH:mm dd/MM")
                            }
                        }

                        Text {
                            text: " " + cpu.usage + "%"
                            color: cpu.usage > 85 ? theme.colRed : theme.colYellow
                            font.pixelSize: theme.fontSize
                            font.family: theme.fontFamily
                            font.bold: true
                            Layout.rightMargin: 8
                        }

                        Text {
                            text: " " + mem.percent + "%"
                            color: mem.percent > 85 ? theme.colRed : theme.colCyan
                            font.pixelSize: theme.fontSize
                            font.family: theme.fontFamily
                            font.bold: true
                            Layout.rightMargin: 8
                        }

                        Text {
                            text: " " + disk.percent + "%"
                            color: disk.percent > 85 ? theme.colRed : theme.colBlue
                            font.pixelSize: theme.fontSize
                            font.family: theme.fontFamily
                            font.bold: true
                            Layout.rightMargin: 8
                        }

                        Text {
                            text: volume.muted ? " Muted" : " " + volume.level + "%"
                            color: volume.muted ? theme.colMuted : theme.colFg
                            font.pixelSize: theme.fontSize
                            font.family: theme.fontFamily
                            font.bold: true
                            Layout.rightMargin: 8
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Process { command: ["pavucontrol"]; running: true }
                            }
                        }

                        Text {
                            text: btInfo.connected ? "" : ""
                            color: btInfo.connected ? theme.colCyan : theme.colMuted
                            font.pixelSize: theme.fontSize
                            font.family: theme.fontFamily
                            font.bold: true
                            Layout.rightMargin: 8
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Process { command: ["blueman-manager"]; running: true }
                            }
                        }

                        Text {
                            visible: battery.percentage > 0
                            text: battery.icon + " " + battery.percentage + "%" + (battery.charging ? " 󰂄" : "")
                            color: battery.percentage <= 15 ? theme.colRed : battery.percentage <= 30 ? theme.colYellow : theme.colFg
                            font.family: theme.fontFamily
                            font.pixelSize: theme.fontSize
                            Layout.rightMargin: 8
                        }

                        Text {
                            text: makoDnd.isDnd ? "" : ""
                            color: makoDnd.isDnd ? theme.colRed : theme.colFg
                            font.family: theme.fontFamily
                            font.pixelSize: theme.fontSize
                            font.bold: makoDnd.isDnd
                            Layout.rightMargin: 8
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Process { command: ["sh", "-c", "makoctl mode | grep -q do-not-disturb && makoctl mode -r do-not-disturb || makoctl mode -a do-not-disturb"]; running: true }
                            }
                        }

                        Text {
                            text: "⏻"
                            color: theme.colFg
                            font.family: theme.fontFamily
                            font.pixelSize: 16
                            Layout.rightMargin: 8
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Process { command: ["wlogout"]; running: true }
                            }
                        }

                        Item { width: 8 }
                    }
                }
            }
        }
    }
  '';
in
{
  xdg.configFile."quickshell/shell.qml".text = shellQml;
}
