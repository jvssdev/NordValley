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
                Process.execute("wlopm", ["--off", "*"])
            } else {
                console.log("Turning on monitors...")
                Process.execute("wlopm", ["--on", "*"])
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
                Process.execute("gtklock", ["-d"])
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
                Process.execute("systemctl", ["suspend"])
            }
        }
    }
    
    Component.onCompleted: {
        console.log("IdleService started with timeouts:")
        console.log("  Monitor off: " + (monitorTimeout / 1000) + "s")
        console.log("  Lock: " + (lockTimeout / 1000) + "s")
        console.log("  Suspend: " + (suspendTimeout / 1000) + "s")
    }
}
