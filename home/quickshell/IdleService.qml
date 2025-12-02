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
    
    // Internal state
    property bool monitorsOff: false
    property bool locked: false
    
    // Monitor to turn off screen
    IdleMonitor {
        id: monitorOffMonitor
        enabled: true
        respectInhibitors: true
        timeout: root.monitorTimeout
        
        onIsIdleChanged: {
            if (isIdle && !root.monitorsOff) {
                console.log("Turning off monitors...")
                root.monitorsOff = true
                Process.execute("wlopm", ["--off", "*"])
            } else if (!isIdle && root.monitorsOff) {
                console.log("Turning on monitors...")
                root.monitorsOff = false
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
            if (isIdle && !root.locked) {
                console.log("Locking with gtklock...")
                root.locked = true
                Process.execute("gtklock", ["-d"])
            } else if (!isIdle) {
                root.locked = false
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
        console.log("  Monitor off: " + (monitorTimeout / 1000) + "s (" + (monitorTimeout / 60000) + " min)")
        console.log("  Lock:        " + (lockTimeout / 1000) + "s (" + (lockTimeout / 60000) + " min)")
        console.log("  Suspend:     " + (suspendTimeout / 1000) + "s (" + (suspendTimeout / 60000) + " min)")
    }
    
    // Function to temporarily disable idle
    function inhibitIdle(reason) {
        console.log("Idle inhibited: " + reason)
        monitorOffMonitor.enabled = false
        lockMonitor.enabled = false
        suspendMonitor.enabled = false
    }
    
    // Function to re-enable idle
    function uninhibitIdle() {
        console.log("Idle uninhibited")
        monitorOffMonitor.enabled = true
        lockMonitor.enabled = true
        suspendMonitor.enabled = true
    }
}
