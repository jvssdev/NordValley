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
  xdg.configFile."quickshell/bar.qml".text = ''
    import QtQuick
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Services.Pipewire
    import Quickshell.Services.Upower
    import Quickshell.Services.Bluez
    import Quickshell.Services.Mako
    import Quickshell.Services.Network
    import Quickshell.Cpu
    import Quickshell.Memory
    import Quickshell.River
    import Quickshell.Niri
    import Quickshell.Dwl
    import Quickshell.Io

    ShellRoot {
      Variants {
        model: Quickshell.screens
        PanelWindow {
          screen: modelData
          anchors { top: true; left: true; right: true }
          height: 34
          color: "#${p.base00}"
          exclusionMode: ExclusionMode.Normal

          Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.width: 2
            border.color: "#${p.base02}"
            radius: 12
            anchors.margins: 8

            RowLayout {
              anchors.fill: parent
              anchors.margins: 12
              spacing: 12

              Loader {
                active: true
                sourceComponent: {
                  if (Quickshell.env("NIRI_SOCKET").length > 0) return niriComp
                  if (Quickshell.env("RIVER_SOCKET").length > 0) return riverComp
                  if (typeof(DwlTags) !== "undefined") return dwlComp
                  return null
                }

                Component {
                  id: riverComp
                  RiverTags {
                    occupiedColor: "#${p.base02}"
                    focusedColor: "#${p.base0D}"
                    urgentColor: "#${p.base08}"
                    vacantHidden: true
                    textColorFocused: "#${p.base00}"
                    textColorDefault: "#${p.base05}"
                    font.pixelSize: 14
                    Layout.alignment: Qt.AlignVCenter
                  }
                }

                Component {
                  id: niriComp
                  NiriWorkspaces {
                    activeColor: "#${p.base0D}"
                    inactiveColor: "#${p.base02}"
                    textColorActive: "#${p.base00}"
                    textColorInactive: "#${p.base05}"
                    font.pixelSize: 14
                    Layout.alignment: Qt.AlignVCenter
                  }
                }

                Component {
                  id: dwlComp
                  DwlTags {
                    occupiedColor: "#${p.base02}"
                    selectedColor: "#${p.base0D}"
                    urgentColor: "#${p.base08}"
                    textColorSelected: "#${p.base00}"
                    textColorDefault: "#${p.base05}"
                    font.pixelSize: 14
                    Layout.alignment: Qt.AlignVCenter
                  }
                }
              }

              Item { Layout.fillWidth: true }

              Text {
                color: "#${p.base05}"
                font { family: "JetBrainsMono Nerd Font"; pixelSize: 14; bold: true }
                text: Qt.formatDateTime(new Date(), "HH:mm dd/MM")
                Timer { interval: 1000; running: true; repeat: true; onTriggered: parent.text = Qt.formatDateTime(new Date(), "HH:mm dd/MM") }
              }

              Item { Layout.fillWidth: true }

              Row {
                spacing: 16
                layoutDirection: Qt.RightToLeft

                Text {
                  text: "⏻"
                  color: mouse.hovered ? "#${p.base00}" : "#${p.base05}"
                  font { family: "JetBrainsMono Nerd Font"; pixelSize: 15 }
                  MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Command { command: "wlogout"; running: true }
                  }
                  background: Rectangle { color: "#${p.base08}"; radius: 8; opacity: mouse.hovered ? 1 : 0 }
                }

                Text {
                  text: network.wifi.connected ? "" : network.ethernet.connected ? "󰈀" : ""
                  color: network.online ? "#${p.base0C}" : "#${p.base08}"
                  font { family: "JetBrainsMono Nerd Font"; pixelSize: 16 }
                  Network { id: network }
                }

                Text {
                  text: bluetooth.connectedDevices.length > 0 ? "" : ""
                  color: bluetooth.connectedDevices.length > 0 ? "#${p.base0F}" : "#${p.base04}"
                  font { family: "JetBrainsMono Nerd Font"; pixelSize: 15 }
                  MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Command { command: "blueman-manager"; running: true }
                  }
                  Bluez { id: bluetooth }
                }

                Text {
                  text: volume.muted ? "󰖁" : volume.volume > 66 ? "󰕾" : volume.volume > 33 ? "󰖀" : "󰕿"
                        + (volume.volume > 0 && !volume.muted ? " " + Math.round(volume.volume) + "%" : "")
                  color: volume.muted ? "#${p.base03}" : "#${p.base05}"
                  font { family: "JetBrainsMono Nerd Font"; pixelSize: 14 }
                  MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Command { command: "pavucontrol"; running: true }
                  }
                  PipewireDefaultAudio { id: volume; type: AudioSink }
                }

                Battery {
                  device: Upower.primaryDevice
                  visible: available
                  text: (if (percentage <= 10) "󰂎"
                  else if (percentage <= 20) "󰁺"
                  else if (percentage <= 30) "󰁻"
                  else if (percentage <= 40) "󰁼"
                  else if (percentage <= 50) "󰁽"
                  else if (percentage <= 60) "󰁾"
                  else if (percentage <= 80) "󰁿"
                  else if (percentage <= 90) "󰂀"
                  else "󰂂") + " " + percentage + "%" + (charging ? " 󰂄" : "")
                  color: percentage <= 15 ? "#${p.base08}" : percentage <= 30 ? "#${p.base0A}" : "#${p.base05}"
                  font { family: "JetBrainsMono Nerd Font"; pixelSize: 14 }
                }

                Row {
                  spacing: 8
                  Text { 
                    text: " " + Math.round(cpu.usage) + "%"
                    color: cpu.usage > 85 ? "#${p.base08}" : "#${p.base05}"
                    font { family: "JetBrainsMono Nerd Font"; pixelSize: 13 }
                    Cpu { id: cpu }
                  }
                  Text { 
                    text: " " + Math.round((mem.used / mem.total) * 100) + "%"
                    color: "#${p.base05}"
                    font { family: "JetBrainsMono Nerd Font"; pixelSize: 13 }
                    Memory { id: mem }
                  }
                }

                Text {
                  text: mako.mode === "do-not-disturb" ? "" : ""
                  color: mako.mode === "do-not-disturb" ? "#${p.base08}" : "#${p.base05}"
                  font { family: "JetBrainsMono Nerd Font"; pixelSize: 16; bold: mako.mode === "do-not-disturb" }
                  MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: mako.toggleMode("do-not-disturb")
                  }
                  Mako { id: mako }
                }
              }
            }
          }
        }
      }
    }
  '';
}
