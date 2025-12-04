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
    import "idle.qml"

    QtObject {
      id: theme
      readonly property string bg: "#${p.base00}"
      readonly property string bgAlt: "#${p.base01}"
      readonly property string bgLighter: "#${p.base02}"
      readonly property string fg: "#${p.base05}"
      readonly property string fgMuted: "#${p.base04}"
      readonly property string fgSubtle: "#${p.base03}"
      readonly property string red: "#${p.base08}"
      readonly property string green: "#${p.base0B}"
      readonly property string yellow: "#${p.base0A}"
      readonly property string blue: "#${p.base0D}"
      readonly property string magenta: "#${p.base0E}"
      readonly property string cyan: "#${p.base0C}"
      readonly property string orange: "#${p.base09}"
      readonly property int radius: 12
      readonly property int borderWidth: 2
      readonly property int padding: 14
      readonly property int spacing: 10
      readonly property string font: "JetBrainsMono Nerd Font"
      readonly property int fontSize: 14
    }

    IdleService {}

    Variants {
      model: Quickshell.screens
      delegate: PanelWindow {
        screen: modelData
        anchors { top: true; left: true; right: true }
        height: 36
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

            Loader {
              Layout.alignment: Qt.AlignVCenter
              sourceComponent: {
                if (typeof(RiverTags) !== "undefined") return riverTagsService
                if (typeof(NiriWorkspaces) !== "undefined") return niriWorkspacesService
                if (typeof(DwlTags) !== "undefined") return dwlTagsService
                if (Quickshell.env("RIVER_SOCKET")?.length > 0) return riverManual
                if (Quickshell.env("NIRI_SOCKET")?.length > 0) return niriManual
                return null
              }

              Component { id: riverTagsService; RiverTags { occupiedColor: theme.bgLighter; focusedColor: theme.blue; urgentColor: theme.red; vacantHidden: true; textColorFocused: theme.bg; textColorDefault: theme.fg; font.pixelSize: 14 } }
              Component { id: niriWorkspacesService; NiriWorkspaces { activeColor: theme.blue; inactiveColor: theme.bgLighter; textColorActive: theme.bg; textColorInactive: theme.fg; font.pixelSize: 14 } }
              Component { id: dwlTagsService; DwlTags { occupiedColor: theme.bgLighter; selectedColor: theme.blue; urgentColor: theme.red; textColorSelected: theme.bg; textColorDefault: theme.fg; font.pixelSize: 14 } }

              Component {
                id: riverManual
                RowLayout {
                  spacing: 6
                  Repeater {
                    model: 9
                    delegate: Rectangle {
                      width: 36; height: 26
                      color: riverTagState.focused ? theme.blue : riverTagState.occupied ? theme.bgLighter : "transparent"
                      radius: 6
                      Text {
                        anchors.centerIn: parent
                        color: riverTagState.focused ? theme.bg : theme.fg
                        font { family: theme.font; pixelSize: 13; bold: riverTagState.focused }
                        text: model.index + 1
                      }
                      MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Process { command: ["riverctl", "set-focused-tags", String(1 << model.index)]; running: true }
                      }
                      QtObject {
                        id: riverTagState
                        property bool focused: false
                        property bool occupied: false
                        Timer {
                          interval: 200; running: true; repeat: true
                          onTriggered: Process {
                            command: ["riverctl", "get-focused-tags"]
                            running: true
                            onExited: riverTagState.focused = (parseInt(stdout.trim()) & (1 << model.index)) !== 0
                          }
                        }
                        Timer {
                          interval: 500; running: true; repeat: true
                          onTriggered: Process {
                            command: ["river-tag-overlay"]
                            running: true
                            onExited: riverTagState.occupied = stdout.trim().split(" ").includes(String(model.index + 1))
                          }
                        }
                      }
                    }
                  }
                }
              }

              Component {
                id: niriManual
                RowLayout {
                  spacing: 6
                  Repeater {
                    model: niriWsModel.workspaces
                    delegate: Rectangle {
                      width: 40; height: 26
                      color: modelData.active ? theme.blue : theme.bgLighter
                      radius: 6
                      Text {
                        anchors.centerIn: parent
                        color: modelData.active ? theme.bg : theme.fg
                        font { family: theme.font; pixelSize: 13; bold: modelData.active }
                        text: modelData.name
                      }
                      MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Command { command: ["niri", "msg", "action", "focus-workspace", modelData.name]; running: true }
                      }
                    }
                  }
                  QtObject {
                    id: niriWsModel
                    property var workspaces: []
                    Timer {
                      interval: 500; running: true; repeat: true
                      onTriggered: Process {
                        command: ["niri", "msg", "-j", "workspaces"]
                        running: true
                        onExited: {
                          try {
                            const data = JSON.parse(stdout)
                            let list = []
                            for (let ws of data) {
                              list.push({ name: ws.name || String(ws.id), active: ws.is_focused })
                            }
                            niriWsModel.workspaces = list
                          } catch(e) {}
                        }
                      }
                    }
                  }
                }
              }
            }

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

              Text {
                text: "⏻"
                color: powerMouse.hovered ? theme.bg : theme.fg
                font { family: theme.font; pixelSize: 15 }
                MouseArea {
                  id: powerMouse
                  anchors.fill: parent
                  hoverEnabled: true
                  cursorShape: Qt.PointingHandCursor
                  onClicked: Command { command: ["wlogout"]; running: true }
                }
                background: Rectangle { color: theme.red; radius: 8; opacity: powerMouse.hovered ? 1 : 0 }
              }

              Text {
                text: makoDnd.isDnd ? "" : ""
                color: makoDnd.isDnd ? theme.red : theme.fg
                font { family: theme.font; pixelSize: 16; bold: makoDnd.isDnd }
                MouseArea {
                  anchors.fill: parent
                  cursorShape: Qt.PointingHandCursor
                  onClicked: Command { command: ["sh", "-c", "makoctl mode | grep -q do-not-disturb && makoctl mode -r do-not-disturb || makoctl mode -a do-not-disturb"]; running: true }
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
              }

              Text {
                text: btInfo.connected ? "" : ""
                color: btInfo.connected ? theme.cyan : theme.fgMuted
                font { family: theme.font; pixelSize: 15 }
                MouseArea {
                  anchors.fill: parent
                  cursorShape: Qt.PointingHandCursor
                  onClicked: Command { command: ["blueman-manager"]; running: true }
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
              }

              Text {
                text: volume.muted ? "󰖁" : volume.volume > 66 ? "󰕾" : volume.volume > 33 ? "󰖀" : "󰕿" + (volume.volume > 0 && !volume.muted ? " " + volume.volume + "%" : "")
                color: volume.muted ? theme.fgMuted : theme.fg
                font { family: theme.font; pixelSize: 14 }
                MouseArea {
                  anchors.fill: parent
                  cursorShape: Qt.PointingHandCursor
                  onClicked: Command { command: ["pavucontrol"]; running: true }
                }
                QtObject {
                  id: volume
                  property int volume: 0
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
                        if (match) volume.volume = Math.round(parseFloat(match[1]) * 100)
                      }
                    }
                  }
                }
              }

              Text {
                visible: battery.percentage > 0
                text: battery.icon + " " + battery.percentage + "%" + (battery.charging ? " 󰂄" : "")
                color: battery.percentage <= 15 ? theme.red : battery.percentage <= 30 ? theme.yellow : theme.fg
                font { family: theme.font; pixelSize: 14 }
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
              }

              Row {
                spacing: 10
                Text {
                  text: " " + cpu.usage + "%"
                  color: cpu.usage > 85 ? theme.red : theme.fg
                  font { family: theme.font; pixelSize: 13 }
                  QtObject {
                    id: cpu
                    property int usage: 0
                    Timer {
                      interval: 2000; running: true; repeat: true
                      onTriggered: Process {
                        command: ["top", "-bn1"]
                        running: true
                        onExited: {
                          const line = stdout.split("\n").find(l => l.includes("%Cpu"))
                          if (line) cpu.usage = Math.round(100 - parseFloat(line.split(/\s+/)[7]))
                        }
                      }
                    }
                  }
                }
                Text {
                  text: " " + mem.percent + "%"
                  color: theme.fg
                  font { family: theme.font; pixelSize: 13 }
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
                          const fields = line.split(/\s+/)
                          mem.percent = Math.round(fields[2] / fields[1] * 100)
                        }
                      }
                    }
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
