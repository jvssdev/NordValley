{
  config,
  pkgs,
  lib,
  homeDir,
  isRiver,
  isMango,
  ...
}:

{
  # Create qmldir for Singleton declaration
  xdg.configFile."quickshell/qmldir".text = ''
    singleton IdleService 1.0 IdleService.qml
  '';

  # Main shell entry point
  xdg.configFile."quickshell/shell.qml".text = ''
    import Quickshell

    ShellRoot {
        IdleService {}
    }
  '';

  # Idle monitoring service
  xdg.configFile."quickshell/IdleService.qml".text = ''
    pragma Singleton

    import QtQuick
    import Quickshell
    import Quickshell.Wayland

    Singleton {
        id: root

        // Timeouts in milliseconds
        property int monitorTimeout: 240000   // 4 minutes
        property int lockTimeout: 300000      // 5 minutes
        property int suspendTimeout: 600000   // 10 minutes

        // Monitor to turn off screen
        IdleMonitor {
            id: monitorOffMonitor
            enabled: true
            respectInhibitors: true
            timeout: root.monitorTimeout

            onIsIdleChanged: {
                if (isIdle) {
                    console.log("Turning off monitors...")
                    Process.execute("${pkgs.wlopm}/bin/wlopm", ["--off", "*"])
                } else {
                    console.log("Turning on monitors...")
                    Process.execute("${pkgs.wlopm}/bin/wlopm", ["--on", "*"])
                }
            }
        }

        // Monitor to lock with gtklock
        IdleMonitor {
            id: lockMonitor
            enabled: true
            respectInhibitors: true
            timeout: root.lockTimeout

            onIsIdleChanged: {
                if (isIdle) {
                    console.log("Locking with gtklock...")
                    Process.execute("${pkgs.gtklock}/bin/gtklock", ["-d"])
                }
            }
        }

        // Monitor to suspend system
        IdleMonitor {
            id: suspendMonitor
            enabled: true
            respectInhibitors: true
            timeout: root.suspendTimeout

            onIsIdleChanged: {
                if (isIdle) {
                    console.log("Suspending system...")
                    Process.execute("${pkgs.systemd}/bin/systemctl", ["suspend"])
                }
            }
        }

        Component.onCompleted: {
            console.log("IdleService started with timeouts:")
            console.log("  Monitor off: " + (monitorTimeout / 1000) + "s")
            console.log("  Lock: " + (lockTimeout / 1000) + "s")
            console.log("  Suspend: " + (suspendTimeout / 1000) + "s")
            console.log("  Compositor: ${
              if isRiver then
                "River"
              else if isMango then
                "MangoWC"
              else
                "Unknown"
            }")
        }
    }
  '';

  # systemd.user.services.quickshell-idle = {
  #   Unit = {
  #     Description = "Quickshell Idle Manager (gtklock integration)";
  #     PartOf = [ "graphical-session.target" ];
  #     After = [ "graphical-session.target" ];
  #   };
  #
  #   Service = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.quickshell}/bin/quickshell";
  #     Restart = "on-failure";
  #     RestartSec = 3;
  #   };
  #
  #   Install = {
  #     WantedBy = [ "graphical-session.target" ];
  #   };
  # };
  #
  # systemd.user.services.quickshell-idle.enable = true;
}
