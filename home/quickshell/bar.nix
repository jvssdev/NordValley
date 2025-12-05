{
  config,
  pkgs,
  lib,
  ...
}:
let
  p = config.colorScheme.palette;
in
{
  xdg.configFile."quickshell/shell.qml".text = ''
    import QtQuick
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Io

    ShellRoot {
      QtObject {
        id: theme
        readonly property string bg: "#${p.base00}"
        readonly property string bgLighter: "#${p.base02}"
        readonly property string fg: "#${p.base05}"
        readonly property string fgMuted: "#${p.base04}"
        readonly property string red: "#${p.base08}"
        readonly property string yellow: "#${p.base0A}"
        readonly property string cyan: "#${p.base0C}"
        readonly property string blue: "#${p.base0D}"
        readonly property int radius: 12
        readonly property int borderWidth: 2
        readonly property int padding: 14
        readonly property int spacing: 10
        readonly property string font: "JetBrainsMono Nerd Font"
        readonly property int fontSize: 14
      }

      QtObject {
        id: makoDnd
        property bool isDnd: false
        Timer {
          interval: 1000; running: true; repeat: true
          onTriggered: Process {
            command: ["makoctl", "mode"]
            running: true
            onExited: makoDnd.isDnd = stdout.trim() === "do-not-disturb"
          }
        }
      }

      QtObject {
        id: btInfo
        property bool connected: false
        Timer {
          interval: 5000; running: true; repeat: true
          onTriggered: Process {
            command: ["bluetoothctl", "info"]
            running: true
            onExited: btInfo.connected = stdout.includes("Connected: yes")
          }
        }
      }

      QtObject {
        id: volume
        property int level: 0
        property bool muted: false
        Timer {
          interval: 1000; running: true; repeat: true
          onTriggered: Process {
            command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
            running: true
            onExited: {
              const out = stdout.trim()
              volume.muted = out.includes("[MUTED]")
              const match = out.match(/Volume: ([0-9.]+)/)
              if (match) volume.level = Math.round(parseFloat(match[1]) * 100)
            }
          }
        }
      }

      QtObject {
        id: battery
        property int percentage: 0
        property string icon: "󰂎"
        property bool charging: false
        Timer {
          interval: 10000; running: true; repeat: true
          onTriggered: {
            Process {
              command: ["cat", "/sys/class/power_supply/BAT*/capacity"]
              running: true
              onExited: battery.percentage = parseInt(stdout.trim()) || 0
            }
            Process {
              command: ["cat", "/sys/class/power_supply/BAT*/status"]
              running: true
              onExited: battery.charging = stdout.trim() === "Charging"
            }
          }
        }
        onPercentageChanged: {
          if (percentage <= 10) icon = "󰂎"
          else if (percentage <= 20) icon = "󰁺"
          else if (percentage <= 30) icon = "󰁻"
          else if (percentage <= 40) icon = "󰁼"
          else if (percentage <= 50) icon = "󰁽"
          else if (percentage <= 60) icon = "󰁾"
          else if (percentage <= 80) icon = "󰁿"
          else if (percentage <= 90) icon = "󰂀"
          else icon = "󰂂"
        }
      }

      QtObject {
        id: cpu
        property int usage: 0
        Timer {
          interval: 2000; running: true; repeat: true
          onTriggered: Process {
            command: ["top", "-bn1"]
            running: true
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
        }
      }

      QtObject {
        id: mem
        property int percent: 0
        Timer {
          interval: 2000; running: true; repeat: true
          onTriggered: Process {
            command: ["free"]
            running: true
            onExited: {
              const line = stdout.split("\n")[1]
              const parts = line.split(/\s+/)
              percent = Math.round(parts[2] / parts[1] * 100)
            }
          }
        }
      }

      Variants {
        model: Quickshell.screens
        PanelWindow {
          property var modelData
          screen: modelData
          anchors { top: true; left: true; right: true }
          implicitHeight: 36
          color: theme.bg
          exclusionMode: ExclusionMode.Normal

          Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.width: theme.borderWidth
            border.color: theme.bgLighter
            radius: theme.radius
            anchors.margins: 8

            RowLayout {
              anchors.fill: parent
              anchors.margins: theme.padding
              spacing: theme.spacing

              Item { Layout.fillWidth: true }

              Text {
                color: theme.fg
                font { family: theme.font; pixelSize: 14; bold: true }
                text: Qt.formatDateTime(new Date(), "HH:mm dd/MM")
                Timer { interval: 1000; running: true; repeat: true; onTriggered: parent.text = Qt.formatDateTime(new Date(), "HH:mm dd/MM") }
              }

              Item { Layout.fillWidth: true }

              Row {
                spacing: 14
                layoutDirection: Qt.RightToLeft

                Rectangle {
                  width: 32; height: 32; radius: 8
                  color: powerMouse.containsMouse ? theme.red : "transparent"
                  Text {
                    anchors.centerIn: parent
                    text: "⏻"
                    color: powerMouse.containsMouse ? "#${p.base00}" : theme.fg
                    font { family: theme.font; pixelSize: 16 }
                  }
                  MouseArea {
                    id: powerMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Process { command: ["wlogout"]; running: true }
                  }
                }

                Text {
                  text: makoDnd.isDnd ? "" : ""
                  color: makoDnd.isDnd ? theme.red : theme.fg
                  font { family: theme.font; pixelSize: 16; bold: makoDnd.isDnd }
                  MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Process { command: ["sh", "-c", "makoctl mode | grep -q do-not-disturb && makoctl mode -r do-not-disturb || makoctl mode -a do-not-disturb"]; running: true }
                  }
                }

                Text {
                  text: btInfo.connected ? "" : ""
                  color: btInfo.connected ? theme.cyan : theme.fgMuted
                  font { family: theme.font; pixelSize: 15 }
                  MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Process { command: ["blueman-manager"]; running: true }
                  }
                }

                Text {
                  text: volume.muted ? "󰖁" : volume.level > 66 ? "󰕾" : volume.level > 33 ? "󰖀" : "󰕿" + (volume.level > 0 && !volume.muted ? " " + volume.level + "%" : "")
                  color: volume.muted ? theme.fgMuted : theme.fg
                  font { family: theme.font; pixelSize: 14 }
                  MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Process { command: ["pavucontrol"]; running: true }
                  }
                }

                Text {
                  visible: battery.percentage > 0
                  text: battery.icon + " " + battery.percentage + "%" + (battery.charging ? " 󰂄" : "")
                  color: battery.percentage <= 15 ? theme.red : battery.percentage <= 30 ? theme.yellow : theme.fg
                  font { family: theme.font; pixelSize: 14 }
                }

                Row {
                  spacing: 10
                  Text {
                    text: " " + cpu.usage + "%"
                    color: cpu.usage > 85 ? theme.red : theme.fg
                    font { family: theme.font; pixelSize: 13 }
                  }
                  Text {
                    text: " " + mem.percent + "%"
                    color: theme.fg
                    font { family: theme.font; pixelSize: 13 }
                  }
                }
              }
            }
          }
        }
      }
    }
  '';
}
