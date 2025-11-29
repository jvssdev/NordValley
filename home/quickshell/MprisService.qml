pragma Singleton
import QtQuick
import Quickshell.Services.Mpris

Singleton {
    id: root
    property var activePlayer: null

    Mpris {
        onPlayersChanged: {
            activePlayer = null
            for (var p of players) {
                if (p.playbackState === MprisPlaybackState.Playing) {
                    activePlayer = p
                    return
                }
            }
            if (players.length > 0) activePlayer = players[0]
        }
    }

    function toggle() { if (activePlayer) activePlayer.togglePlaying() }
    function next()   { if (activePlayer) activePlayer.next() }
    function prev()   { if (activePlayer) activePlayer.previous() }
}
