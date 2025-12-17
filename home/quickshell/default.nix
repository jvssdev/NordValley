{
  config,
  pkgs,
  lib,
  isRiver,
  isMango,
  isNiri,
  ...
}:
let
  p = config.colorScheme.palette;
  ms = s: s * 1000;
in
{
  home.packages = [
    pkgs.jq
    pkgs.procps
    pkgs.coreutils
    pkgs.wireplumber
    pkgs.bluez
    pkgs.dunst
    pkgs.gtklock
    pkgs.systemd
    pkgs.wlogout
    pkgs.pavucontrol
    pkgs.blueman
    pkgs.wlopm
    pkgs.kdePackages.qt5compat
    pkgs.kdePackages.qtbase
    pkgs.kdePackages.qtdeclarative
  ]
  ++ lib.optionals isRiver [ pkgs.river ]
  ++ lib.optionals isNiri [ pkgs.niri ];
  home.sessionVariables = {
    QML_IMPORT_PATH = lib.concatStringsSep ":" [
      "$HOME/.config/quickshell"
      "${pkgs.quickshell}/share/qml"
      (lib.makeSearchPath "lib/qt-6/qml" [
        pkgs.kdePackages.qtdeclarative
        pkgs.kdePackages.qtbase
      ])
    ];
  };
  xdg.configFile."quickshell/WorkspaceModule.qml".text = ''
    import QtQuick
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Io
    RowLayout {
        id: workspaceModule
        spacing: 4
        ${
          if isRiver then
            ''
              Repeater {
                  model: 9
                  Rectangle {
                      Layout.preferredWidth: 24
                      Layout.preferredHeight: 24
                      color: "transparent"
                      property int tagId: index + 1
                      property bool isActive: false
                      property bool isOccupied: false
                      Process {
                          id: riverTagProc
                          command: ["${pkgs.bash}/bin/sh", "-c", "${pkgs.river}/bin/riverctl list-views"]
                          stdout: SplitParser {
                              onRead: data => {
                                  if (!data) return
                                  const lines = data.split("\n")
                                  parent.parent.isOccupied = lines.some(line => line.includes("tag:" + parent.parent.tagId))
                              }
                          }
                      }
                      Process {
                          id: riverFocusProc
                          command: ["${pkgs.bash}/bin/sh", "-c", "${pkgs.river}/bin/riverctl list-views | grep focused"]
                          stdout: SplitParser {
                              onRead: data => {
                                  if (!data) return
                                  parent.parent.isActive = data.includes("tag:" + parent.parent.tagId)
                              }
                          }
                      }
                      Timer {
                          interval: 500
                          running: true
                          repeat: true
                          triggeredOnStart: true
                          onTriggered: {
                              riverTagProc.running = true
                              riverFocusProc.running = true
                          }
                      }
                      Rectangle {
                          anchors.fill: parent
                          color: parent.isActive ? "#${p.base0D}" : (parent.isOccupied ? "#${p.base02}" : "transparent")
                          radius: 0
                          Text {
                              text: parent.parent.tagId
                              color: parent.parent.isActive ? "#${p.base00}" : "#${p.base05}"
                              font.pixelSize: 12
                              font.family: "JetBrainsMono Nerd Font"
                              font.bold: parent.parent.isActive
                              anchors.centerIn: parent
                          }
                      }
                      MouseArea {
                          anchors.fill: parent
                          cursorShape: Qt.PointingHandCursor
                          onClicked: {
                              Qt.callLater(() => {
                                  const tagMask = Math.pow(2, parent.tagId - 1)
                                  const proc = Qt.createQmlObject(
                                      'import Quickshell.Io; Process { command: ["${pkgs.river}/bin/riverctl", "set-focused-tags", "' + tagMask + '"] }',
                                      parent
                                  )
                                  proc.running = true
                              })
                          }
                      }
                  }
              }
            ''
          else if isMango then
            ''
              RowLayout {
                  spacing: 12
                  
                  Row {
                      spacing: 2
                      Repeater {
                          model: ListModel {
                              id: dwlTagsModel
                              Component.onCompleted: {
                                  for (let i = 1; i <= 9; i++) {
                                      append({ tagId: i.toString(), isActive: false, isOccupied: false, isUrgent: false });
                                  }
                              }
                          }
                          Rectangle {
                              visible: model.isActive || model.isOccupied || model.isUrgent
                              width: visible ? 24 : 0
                              height: 24
                              color: "transparent"
                              Rectangle {
                                  anchors.fill: parent
                                  anchors.margins: 2
                                  color: model.isUrgent ? "#${p.base08}" : (model.isActive ? "#${p.base0C}" : (model.isOccupied ? "#${p.base02}" : "transparent"))
                                  radius: 4
                                  Text {
                                      text: model.tagId
                                      color: (model.isActive || model.isUrgent) ? "#${p.base00}" : "#${p.base05}"
                                      font.pixelSize: 11
                                      font.family: "JetBrainsMono Nerd Font"
                                      font.bold: model.isActive
                                      anchors.centerIn: parent
                                  }
                              }
                          }
                      }
                  }

                  Text {
                      id: dwlLayoutText
                      text: ""
                      color: "#${p.base0C}"
                      font.pixelSize: 11
                      font.family: "JetBrainsMono Nerd Font"
                      font.bold: true
                  }
              }

              Process {
                  id: dwlUpdateProc
                  command: ["mmsg", "-g"]
                  stdout: SplitParser {
                      onRead: data => {
                          const lines = data.trim().split("\n");
                          for (let line of lines) {
                              const parts = line.trim().split(/\s+/);
                              if (line.includes(" tag ")) {
                                  const idx = parts.indexOf("tag");
                                  const id = parseInt(parts[idx + 1]);
                                  if (id >= 1 && id <= 9) {
                                      dwlTagsModel.setProperty(id - 1, "isActive", parts[idx + 2] === "1");
                                      dwlTagsModel.setProperty(id - 1, "isOccupied", parts[idx + 3] === "1");
                                      dwlTagsModel.setProperty(id - 1, "isUrgent", parts[idx + 4] === "1");
                                  }
                              } else if (line.includes(" layout ")) {
                                  const idx = parts.indexOf("layout");
                                  const symbol = parts[idx + 1] || "";
                                  dwlLayoutText.text = symbol ? "[" + symbol.replace(/[\[\]]/g, "") + "]" : "";
                              }
                          }
                      }
                  }
              }

              Timer {
                  interval: 150
                  running: true
                  repeat: true
                  triggeredOnStart: true
                  onTriggered: {
                      if (!dwlUpdateProc.running) {
                          dwlUpdateProc.running = true;
                      }
                  }
              }
            ''
          else if isNiri then
            ''
              Repeater {
                  model: ListModel {
                      id: niriWorkspaces
                  }
                  Rectangle {
                      Layout.preferredWidth: contentText.width + 16
                      Layout.preferredHeight: 24
                      color: modelData.isActive ? "#${p.base0D}" : "#${p.base02}"
                      radius: 0
                      Text {
                          id: contentText
                          text: modelData.name || (modelData.index + 1)
                          color: modelData.isActive ? "#${p.base00}" : "#${p.base05}"
                          font.pixelSize: 12
                          font.family: "JetBrainsMono Nerd Font"
                          font.bold: modelData.isActive
                          anchors.centerIn: parent
                      }
                      MouseArea {
                          anchors.fill: parent
                          cursorShape: Qt.PointingHandCursor
                          onClicked: {
                              Qt.callLater(() => {
                                  const proc = Qt.createQmlObject(
                                      'import Quickshell.Io; Process { command: ["${pkgs.niri}/bin/niri", "msg", "action", "focus-workspace", "' + modelData.index + '"] }',
                                      parent
                                  )
                                  proc.running = true
                              })
                          }
                      }
                  }
              }
              Process {
                  id: niriWorkspaceProc
                  command: ["${pkgs.niri}/bin/niri", "msg", "-j", "workspaces"]
                  stdout: SplitParser {
                      onRead: data => {
                          if (!data) return
                          try {
                              const workspaces = JSON.parse(data)
                              niriWorkspaces.clear()
                              workspaces.forEach((ws, idx) => {
                                  niriWorkspaces.append({
                                      index: idx,
                                      name: ws.name || "",
                                      isActive: ws.is_active || false
                                  })
                              })
                          } catch (e) {}
                      }
                  }
              }
              Timer {
                  interval: 300
                  running: true
                  repeat: true
                  triggeredOnStart: true
                  onTriggered: niriWorkspaceProc.running = true
              }
            ''
          else
            ''
              Text {
                  text: "~"
                  color: "#${p.base0E}"
                  font.pixelSize: 18
                  font.family: "JetBrainsMono Nerd Font"
                  font.bold: true
              }
            ''
        }
    }
  '';
  xdg.configFile."quickshell/shell.qml".text = ''
    import QtQuick
    import QtQuick.Layouts
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Io
    ShellRoot {
        id: root
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
            readonly property string fontFamily: "JetBrainsMono Nerd Font"
            readonly property int fontPixelSize: 14
        }
        QtObject { id: dunstDnd; property bool isDnd: false }
        QtObject { id: btInfo; property bool connected: false }
        QtObject {
            id: volume
            property int level: 0
            property bool muted: false
        }
        QtObject {
            id: battery
            property int percentage: 0
            property string icon: "󰂎"
            property bool charging: false
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
        QtObject { id: cpu; property int usage: 0 }
        QtObject { id: mem; property int percent: 0 }
        QtObject { id: disk; property int percent: 0 }
        property var lastCpuIdle: 0
        property var lastCpuTotal: 0
        Process {
            id: dunstProc
            command: ["${pkgs.dunst}/bin/dunstctl", "is-paused"]
            stdout: SplitParser {
                onRead: data => {
                    if (data) dunstDnd.isDnd = data.trim() === "true"
                }
            }
        }
        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: dunstProc.running = true
        }
        Process {
            id: btProc
            command: ["${pkgs.bluez}/bin/bluetoothctl", "info"]
            stdout: SplitParser {
                onRead: data => {
                    if (data) btInfo.connected = data.includes("Connected: yes")
                }
            }
        }
        Timer {
            interval: 5000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: btProc.running = true
        }
        Process {
            id: volumeProc
            command: ["${pkgs.wireplumber}/bin/wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data) return
                    const out = data.trim()
                    volume.muted = out.includes("[MUTED]")
                    const match = out.match(/Volume: ([0-9.]+)/)
                    if (match) volume.level = Math.round(parseFloat(match[1]) * 100)
                }
            }
        }
        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: volumeProc.running = true
        }
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
            command: ["${pkgs.bash}/bin/sh", "-c", "cat /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo 0"]
            stdout: SplitParser {
                onRead: data => {
                    if (data) battery.percentage = parseInt(data.trim()) || 0
                }
            }
        }
        Process {
            id: batStatusProc
            command: ["${pkgs.bash}/bin/sh", "-c", "cat /sys/class/power_supply/BAT*/status 2>/dev/null || echo Discharging"]
            stdout: SplitParser {
                onRead: data => {
                    if (data) battery.charging = data.trim() === "Charging"
                }
            }
        }
        Process {
            id: cpuProc
            command: ["${pkgs.bash}/bin/sh", "-c", "head -1 /proc/stat"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data) return
                    var parts = data.trim().split(/\s+/)
                    var user = parseInt(parts[1]) || 0
                    var nice = parseInt(parts[2]) || 0
                    var system = parseInt(parts[3]) || 0
                    var idle = parseInt(parts[4]) || 0
                    var iowait = parseInt(parts[5]) || 0
                    var irq = parseInt(parts[6]) || 0
                    var softirq = parseInt(parts[7]) || 0
                    var total = user + nice + system + idle + iowait + irq + softirq
                    var idleTime = idle + iowait
                    if (lastCpuTotal > 0) {
                        var totalDiff = total - lastCpuTotal
                        var idleDiff = idleTime - lastCpuIdle
                        if (totalDiff > 0) {
                            cpu.usage = Math.round(100 * (totalDiff - idleDiff) / totalDiff)
                        }
                    }
                    lastCpuTotal = total
                    lastCpuIdle = idleTime
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
        Process {
            id: memProc
            command: ["${pkgs.bash}/bin/sh", "-c", "${pkgs.procps}/bin/free | grep Mem"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data) return
                    var parts = data.trim().split(/\s+/)
                    var total = parseInt(parts[1]) || 1
                    var used = parseInt(parts[2]) || 0
                    mem.percent = Math.round(100 * used / total)
                }
            }
        }
        Timer {
            interval: 2000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: memProc.running = true
        }
        Process {
            id: diskProc
            command: ["${pkgs.bash}/bin/sh", "-c", "${pkgs.coreutils}/bin/df / | ${pkgs.coreutils}/bin/tail -1"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data) return
                    var parts = data.trim().split(/\s+/)
                    var percentStr = parts[4] || "0%"
                    disk.percent = parseInt(percentStr.replace("%", "")) || 0
                }
            }
        }
        Timer {
            interval: 10000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: diskProc.running = true
        }
        Process { id: wlopmOffProc; command: ["${pkgs.wlopm}/bin/wlopm", "--off", "*"] }
        Process { id: wlopmOnProc; command: ["${pkgs.wlopm}/bin/wlopm", "--on", "*"] }
        Process { id: gtklockProc; command: ["${pkgs.gtklock}/bin/gtklock", "-d"] }
        Process { id: suspendProc; command: ["${pkgs.systemd}/bin/systemctl", "suspend"] }
        IdleMonitor {
            id: monitorOffMonitor
            enabled: true
            respectInhibitors: true
            timeout: ${toString (ms 240)}
            onIsIdleChanged: {
                if (isIdle) {
                    wlopmOffProc.running = true
                } else {
                    wlopmOnProc.running = true
                }
            }
        }
        IdleMonitor {
            id: lockMonitor
            enabled: true
            respectInhibitors: true
            timeout: ${toString (ms 300)}
            onIsIdleChanged: {
                if (isIdle) {
                    gtklockProc.running = true
                }
            }
        }
        IdleMonitor {
            id: suspendMonitor
            enabled: true
            respectInhibitors: true
            timeout: ${toString (ms 600)}
            onIsIdleChanged: {
                if (isIdle) {
                    suspendProc.running = true
                }
            }
        }
        PanelWindow {
            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 30
            color: "transparent"
            Process { id: pavuProcess; command: ["${pkgs.pavucontrol}/bin/pavucontrol"] }
            Process { id: bluemanProcess; command: ["${pkgs.blueman}/bin/blueman-manager"] }
            Process { id: dunstDndProcess; command: ["${pkgs.dunst}/bin/dunstctl", "set-paused", "toggle"] }
            Process { id: wlogoutProcess; command: ["${pkgs.wlogout}/bin/wlogout"] }
            Rectangle {
                anchors.fill: parent
                color: theme.bg
                RowLayout {
                    anchors.fill: parent
                    spacing: theme.spacing / 2
                    Item { width: theme.padding / 2 }
                    WorkspaceModule {}
                    Item { Layout.fillWidth: true }
                    Text {
                        id: clockText
                        text: Qt.formatDateTime(new Date(), "HH:mm dd/MM")
                        color: theme.cyan
                        font {
                            family: theme.fontFamily
                            pixelSize: theme.fontPixelSize
                            bold: true
                        }
                        Layout.rightMargin: theme.spacing / 2
                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: clockText.text = Qt.formatDateTime(new Date(), "HH:mm dd/MM")
                        }
                    }
                    Rectangle {
                        Layout.preferredWidth: theme.borderWidth
                        Layout.preferredHeight: 16
                        Layout.alignment: Qt.AlignVCenter
                        Layout.leftMargin: 0
                        Layout.rightMargin: theme.spacing / 2
                        color: theme.fgSubtle
                    }
                    Text {
                        text: " " + cpu.usage + "%"
                        color: cpu.usage > 85 ? theme.red : theme.yellow
                        font {
                            family: theme.fontFamily
                            pixelSize: theme.fontPixelSize
                            bold: true
                        }
                        Layout.rightMargin: theme.spacing / 2
                    }
                    Text {
                        text: " " + mem.percent + "%"
                        color: mem.percent > 85 ? theme.red : theme.cyan
                        font {
                            family: theme.fontFamily
                            pixelSize: theme.fontPixelSize
                            bold: true
                        }
                        Layout.rightMargin: theme.spacing / 2
                    }
                    Text {
                        text: " " + disk.percent + "%"
                        color: disk.percent > 85 ? theme.red : theme.blue
                        font {
                            family: theme.fontFamily
                            pixelSize: theme.fontPixelSize
                            bold: true
                        }
                        Layout.rightMargin: theme.spacing / 2
                    }
                    Text {
                        text: volume.muted ? " Muted" : " " + volume.level + "%"
                        color: volume.muted ? theme.fgSubtle : theme.fg
                        font {
                            family: theme.fontFamily
                            pixelSize: theme.fontPixelSize
                            bold: true
                        }
                        Layout.rightMargin: theme.spacing / 2
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: pavuProcess.running = true
                        }
                    }
                    Text {
                        text: btInfo.connected ? "" : ""
                        color: btInfo.connected ? theme.cyan : theme.fgSubtle
                        font {
                            family: theme.fontFamily
                            pixelSize: theme.fontPixelSize
                            bold: true
                        }
                        Layout.rightMargin: theme.spacing / 2
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: bluemanProcess.running = true
                        }
                    }
                    Text {
                        visible: battery.percentage > 0
                        text: battery.icon + " " + battery.percentage + "%" + (battery.charging ? " 󰂄" : "")
                        color: battery.percentage <= 15 ? theme.red : battery.percentage <= 30 ? theme.yellow : theme.fg
                        font {
                            family: theme.fontFamily
                            pixelSize: theme.fontPixelSize
                        }
                        Layout.rightMargin: theme.spacing / 2
                    }
                    Text {
                        text: dunstDnd.isDnd ? "" : ""
                        color: dunstDnd.isDnd ? theme.red : theme.fg
                        font {
                            family: theme.fontFamily
                            pixelSize: theme.fontPixelSize
                            bold: dunstDnd.isDnd
                        }
                        Layout.rightMargin: theme.spacing / 2
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: dunstDndProcess.running = true
                        }
                    }
                    Text {
                        text: "⏻"
                        color: theme.fg
                        font {
                            family: theme.fontFamily
                            pixelSize: 16
                        }
                        Layout.rightMargin: theme.spacing / 2
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: wlogoutProcess.running = true
                        }
                    }
                    Item { width: theme.padding / 2 }
                }
            }
        }
    }
  '';
}
