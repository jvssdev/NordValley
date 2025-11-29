pragma Singleton
import QtQuick
import Quickshell.Services.Mpris

Singleton {
    id: root
    property var activePlayer: null

    Mpris {
        onPlayersChanged: {
            for (var p of players) {
                if (p.playbackState === MprisPlaybackState.Playing) {
                    root.activePlayer = p
                    return
                }
            }
            root.activePlayer = players[0] || null
        }
    }

    function toggle() { if (activePlayer) activePlayer.togglePlaying() }
    function next()   { if (activePlayer) activePlayer.next() }
    function prev()   { if (activePlayer) activePlayer.previous() }
}
