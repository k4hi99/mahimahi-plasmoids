import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.private.mpris as Mpris

PlasmoidItem {
    id: root
    
    width: Kirigami.Units.gridUnit * 20
    height: Kirigami.Units.gridUnit * 10
    
    // Couleurs MahiTheme (onglet "Couleurs", voir CLAUDE.md)
    property color primaryColor: plasmoid.configuration.primaryColor
    property color secondaryColor: plasmoid.configuration.secondaryColor
    property color accentColor: plasmoid.configuration.accentColor
    property color tertiaryColor: plasmoid.configuration.tertiaryColor
    property color bgColor: plasmoid.configuration.bgColor
    property color textColor: plasmoid.configuration.textColor
    property color secTextColor: plasmoid.configuration.secTextColor
    property color badgeTextColor: plasmoid.configuration.badgeTextColor
    property bool widgetBorderEnabled: plasmoid.configuration.widgetBorderEnabled
    property string pauseColor: plasmoid.configuration.pauseButtonColor
    property string progressColor: plasmoid.configuration.progressBarColor
    
    // Tailles MahiTheme (onglet "Tailles", voir CLAUDE.md)
    property int titleFontSize: plasmoid.configuration.titleFontSize
    property int textFontSize: plasmoid.configuration.textFontSize
    property int smallFontSize: plasmoid.configuration.smallFontSize
    property int borderRadius: plasmoid.configuration.borderRadius
    property int widgetBorderWidth: plasmoid.configuration.widgetBorderWidth
    property int albumSize: plasmoid.configuration.albumSize
    property int buttonSize: plasmoid.configuration.buttonSize
    
    // ========== LECTEUR MPRIS ==========
    // Sélectionne Spotify dès qu'il apparaît parmi les lecteurs MPRIS
    property var mpris2Model: Mpris.Mpris2Model {
        onRowsInserted: function(_, rowIndex) {
            const CONTAINER_ROLE = Qt.UserRole + 1
            const player = mpris2Model.data(mpris2Model.index(rowIndex, 0), CONTAINER_ROLE)
            if (player && player.identity === "Spotify") {
                mpris2Model.currentIndex = rowIndex
            }
        }
    }
    
    Component.onCompleted: {
    }
    
    readonly property var player: mpris2Model.currentPlayer
    readonly property bool ready: player !== null && player !== undefined && player.identity === "Spotify"
    
    readonly property string trackTitle: (ready && player.track) ? player.track : "Pas de musique"
    readonly property string trackArtist: (ready && player.artist) ? player.artist : "Spotify non détecté"
    readonly property string albumArt: (ready && player.artUrl) ? player.artUrl : ""
    readonly property bool isPlaying: (ready && player.playbackStatus) ? player.playbackStatus === Mpris.PlaybackStatus.Playing : false
    readonly property real trackLength: (ready && player.length) ? player.length : 0
    readonly property real trackPosition: ready ? getDaemonPosition() : 0
    readonly property bool canGoNext: (ready && player.canGoNext !== undefined) ? player.canGoNext : false
    readonly property bool canGoPrevious: (ready && player.canGoPrevious !== undefined) ? player.canGoPrevious : false
    readonly property bool canPlay: (ready && player.canPlay !== undefined) ? player.canPlay : false
    readonly property bool canPause: (ready && player.canPause !== undefined) ? player.canPause : false
    
    property var timeLastPositionChanged: new Date().getTime()
    
    // MPRIS ne signale pas l'avancement : la position est extrapolée (getDaemonPosition)
    // depuis le dernier positionChanged et réévaluée toutes les 100 ms
    Timer {
        id: updateTimer
        interval: 100
        running: isPlaying
        repeat: true
        onTriggered: {
            trackPositionChanged()
        }
    }
    
    Connections {
        target: player
        function onPositionChanged() {
            timeLastPositionChanged = new Date().getTime()
        }
    }
    
    function getDaemonPosition() {
        if (!ready) return 0
        let timePassed = new Date().getTime() - timeLastPositionChanged
        return player.position + (isPlaying ? (timePassed * 1000) : 0)
    }
    
    // ========== COMMANDES ==========
    function togglePlayPause() {
        if (ready) {
            player.PlayPause()
        }
    }
    
    function nextTrack() {
        if (ready) {
            player.Next()
        }
    }
    
    function previousTrack() {
        if (ready) {
            player.Previous()
        }
    }
    
    function seek(position) {
        if (ready) {
            const currentPos = getDaemonPosition()
            const delta = position - currentPos
            player.Seek(delta)
        }
    }
    
    // ========== REPRÉSENTATION COMPLÈTE ==========
    fullRepresentation: Rectangle {
        color: bgColor
        radius: borderRadius
        border.color: tertiaryColor
        border.width: widgetBorderEnabled ? widgetBorderWidth : 0
        anchors.fill: parent
            anchors.margins: -10
        
        ColumnLayout {
            
            anchors.fill: parent
                    anchors.margins: 10
            
            // ========== POCHETTE ET TITRE ==========
            RowLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.largeSpacing
                
                Rectangle {
                    Layout.preferredWidth: Kirigami.Units.gridUnit * albumSize
                    Layout.preferredHeight: Kirigami.Units.gridUnit * albumSize
                    color: secondaryColor
                    radius: borderRadius
                    clip: true
                    
                    Image {
                        id: albumImage
                        anchors.fill: parent
                        source: albumArt
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                        visible: albumArt !== ""
                        cache: true
                        asynchronous: true
                    }
                    
                    Kirigami.Icon {
                        anchors.centerIn: parent
                        width: Kirigami.Units.iconSizes.huge
                        height: Kirigami.Units.iconSizes.huge
                        source: "spotify-client"
                        opacity: 0.3
                        visible: albumArt === ""
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (ready && player.canRaise) {
                                player.Raise()
                            }
                        }
                        
                        PlasmaComponents.ToolTip {
                            text: "Ouvrir Spotify"
                        }
                    }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: Kirigami.Units.smallSpacing * 0.5
                    
                    PlasmaComponents.Label {
                        Layout.fillWidth: true
                        text: trackTitle
                        font.pixelSize: titleFontSize
                        font.weight: Font.Bold
                        color: textColor
                        elide: Text.ElideRight
                        maximumLineCount: 2
                        wrapMode: Text.Wrap
                    }
                    
                    PlasmaComponents.Label {
                        Layout.fillWidth: true
                        text: trackArtist
                        font.pixelSize: textFontSize
                        color: secTextColor
                        elide: Text.ElideRight
                    }
                }
            }
            
            // ========== BOUTONS DE LECTURE ==========
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: Kirigami.Units.largeSpacing
                
                PlasmaComponents.ToolButton {
                    icon.name: "media-skip-backward"
                    icon.width: buttonSize
                    icon.height: buttonSize
                    icon.color: primaryColor
                    enabled: canGoPrevious && ready
                    onClicked: previousTrack()
                    
                    PlasmaComponents.ToolTip {
                        text: "Précédent"
                    }
                }
                
                PlasmaComponents.ToolButton {
                    icon.name: isPlaying ? "media-playback-pause" : "media-playback-start"
                    icon.width: buttonSize * 1.2
                    icon.height: buttonSize * 1.2
                    icon.color: isPlaying ? pauseColor : accentColor
                    enabled: ready && (isPlaying ? canPause : canPlay)
                    onClicked: togglePlayPause()
                    
                    PlasmaComponents.ToolTip {
                        text: isPlaying ? "Pause" : "Lecture"
                    }
                }
                
                PlasmaComponents.ToolButton {
                    icon.name: "media-skip-forward"
                    icon.width: buttonSize
                    icon.height: buttonSize
                    icon.color: primaryColor
                    enabled: canGoNext && ready
                    onClicked: nextTrack()
                    
                    PlasmaComponents.ToolTip {
                        text: "Suivant"
                    }
                }
            }
            
            // ========== BARRE DE PROGRESSION ==========
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                
                PlasmaComponents.Slider {
                    id: progressSlider
                    Layout.fillWidth: true
                    from: 0
                    to: trackLength > 0 ? trackLength : 1
                    value: trackPosition
                    enabled: trackLength > 0 && ready
                    
                    // Fond redessiné pour appliquer la couleur spéciale progressColor
                    background: Rectangle {
                        x: progressSlider.leftPadding
                        y: progressSlider.topPadding + progressSlider.availableHeight / 2 - height / 2
                        implicitWidth: 200
                        implicitHeight: 4
                        width: progressSlider.availableWidth
                        height: implicitHeight
                        radius: 2
                        color: tertiaryColor
                        
                        Rectangle {
                            width: progressSlider.visualPosition * parent.width
                            height: parent.height
                            color: progressColor
                            radius: 2
                        }
                    }
                    
                    onMoved: {
                        seek(value)
                    }
                    
                    Connections {
                        target: root
                        function onTrackPositionChanged() {
                            if (!progressSlider.pressed) {
                                progressSlider.value = trackPosition
                            }
                        }
                    }
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    
                    PlasmaComponents.Label {
                        text: formatTime(trackPosition)
                        font.pixelSize: smallFontSize
                        color: secTextColor
                        opacity: 0.8
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    PlasmaComponents.Label {
                        text: formatTime(trackLength)
                        font.pixelSize: smallFontSize
                        color: secTextColor
                        opacity: 0.8
                    }
                }
            }
        }
    }
    
    function formatTime(microseconds) {
        var seconds = Math.floor(microseconds / 1000000)
        var mins = Math.floor(seconds / 60)
        var secs = seconds % 60
        return mins + ":" + (secs < 10 ? "0" : "") + secs
    }
}