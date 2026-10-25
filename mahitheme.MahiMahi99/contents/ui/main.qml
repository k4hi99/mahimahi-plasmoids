// MahiTheme : popup des palettes de themes.json, appliquées à tout KDE
// via le script ~/.local/bin/mahitheme
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as P5Support
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    // ========== PROPRIÉTÉS ==========
    readonly property string scriptCommand: "\"$HOME/.local/bin/mahitheme\""
    property var themes: []
    property string currentTheme: ""
    property bool applying: false
    property string errorMessage: ""

    // Rotation du fond d'écran (timer systemd, lu via « mahitheme --status --json »)
    readonly property var intervalPresets: [5, 15, 30, 60]
    property bool rotationEnabled: false
    property int rotationInterval: 15
    property string nextWallpaper: ""

    // Couleurs MahiTheme (onglet "Couleurs", voir CLAUDE.md)
    property color primaryColor: plasmoid.configuration.primaryColor
    property color secondaryColor: plasmoid.configuration.secondaryColor
    property color accentColor: plasmoid.configuration.accentColor
    property color tertiaryColor: plasmoid.configuration.tertiaryColor
    property color bgColor: plasmoid.configuration.bgColor
    property color textColor: plasmoid.configuration.textColor
    property color secTextColor: plasmoid.configuration.secTextColor
    property color badgeTextColor: plasmoid.configuration.badgeTextColor

    // Tailles MahiTheme (onglet "Tailles", voir CLAUDE.md)
    property int titleFontSize: plasmoid.configuration.titleFontSize
    property int textFontSize: plasmoid.configuration.textFontSize
    property int smallFontSize: plasmoid.configuration.smallFontSize
    property int compactIconSize: plasmoid.configuration.compactIconSize
    property int borderRadius: plasmoid.configuration.borderRadius

    preferredRepresentation: compactRepresentation
    toolTipMainText: "MahiTheme"
    toolTipSubText: currentTheme ? "Thème : " + currentTheme : "Aucun thème appliqué"

    Component.onCompleted: refreshAll()

    // Relire le thème courant et la rotation à l'ouverture (ils ont pu changer via le terminal)
    onExpandedChanged: if (expanded) refreshAll()

    // ========== EXÉCUTION DU SCRIPT ==========
    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []

        onNewData: (sourceName, data) => {
            disconnectSource(sourceName)
            if (sourceName.endsWith("--list --json")) {
                root.readThemes(data["exit code"], data["stdout"], data["stderr"])
            } else if (sourceName.endsWith("--status --json")) {
                root.readStatus(data["exit code"], data["stdout"], data["stderr"])
            } else {
                root.applying = false
                root.errorMessage = data["exit code"] === 0 ? "" : data["stderr"].trim()
                root.refreshAll()
            }
        }
    }

    function refreshThemes() {
        executable.connectSource(scriptCommand + " --list --json")
    }

    function refreshStatus() {
        executable.connectSource(scriptCommand + " --status --json")
    }

    function refreshAll() {
        refreshThemes()
        refreshStatus()
    }

    function readThemes(exitCode, stdout, stderr) {
        if (exitCode !== 0) {
            errorMessage = stderr.trim() || "Script mahitheme introuvable"
            return
        }
        try {
            const list = JSON.parse(stdout)
            themes = list
            const current = list.find(t => t.current)
            currentTheme = current ? current.name : ""
        } catch (e) {
            errorMessage = "Réponse illisible de mahitheme : " + e
        }
    }

    function readStatus(exitCode, stdout, stderr) {
        if (exitCode !== 0) {
            errorMessage = stderr.trim() || "État de la rotation illisible"
            return
        }
        try {
            const status = JSON.parse(stdout)
            rotationEnabled = status.rotation
            if (status.interval) rotationInterval = status.interval
            nextWallpaper = status.next || ""
        } catch (e) {
            errorMessage = "Réponse illisible de mahitheme : " + e
        }
    }

    function shellQuote(text) {
        return "'" + text.replace(/'/g, "'\\''") + "'"
    }

    function runScript(args) {
        if (applying) return
        applying = true
        errorMessage = ""
        executable.connectSource(scriptCommand + " " + args)
    }

    function applyTheme(name) {
        runScript(shellQuote(name))
    }

    // ========== REPRÉSENTATION COMPACTE ==========
    compactRepresentation: MouseArea {
        Layout.minimumWidth: Kirigami.Units.iconSizes.small
        Layout.minimumHeight: Kirigami.Units.iconSizes.small
        Layout.preferredWidth: root.compactIconSize
        Layout.preferredHeight: root.compactIconSize

        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton

        Kirigami.Icon {
            anchors.fill: parent
            source: "kcolorchooser"
            active: parent.containsMouse
            opacity: root.applying ? 0.5 : 1
        }

        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                root.expanded = !root.expanded
            } else if (mouse.button === Qt.MiddleButton) {
                root.runScript("--next-theme")
            }
        }
    }

    // ========== REPRÉSENTATION COMPLÈTE ==========
    fullRepresentation: Rectangle {
        color: root.bgColor
        radius: root.borderRadius
        Layout.minimumWidth: 420
        Layout.minimumHeight: Math.max(260, popupColumn.implicitHeight + 24)
        Layout.preferredWidth: 480

        ColumnLayout {
            id: popupColumn
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10

            // ========== EN-TÊTE ==========
            RowLayout {
                Layout.fillWidth: true

                PlasmaComponents.Label {
                    text: "🎨 MahiTheme"
                    font.pixelSize: root.titleFontSize
                    font.bold: true
                    color: root.primaryColor
                    Layout.fillWidth: true
                }

                PlasmaComponents.Label {
                    text: root.applying ? "Application…" : root.currentTheme
                    font.pixelSize: root.smallFontSize
                    color: root.secTextColor
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: root.tertiaryColor
            }

            // ========== GRILLE DES THÈMES ==========
            GridLayout {
                Layout.fillWidth: true
                columns: 3
                columnSpacing: 6
                rowSpacing: 6

                Repeater {
                    model: root.themes

                    MouseArea {
                        id: themeCard
                        readonly property bool isCurrent: modelData.name === root.currentTheme

                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        enabled: !root.applying

                        onClicked: root.applyTheme(modelData.name)

                        Rectangle {
                            anchors.fill: parent
                            radius: root.borderRadius
                            color: themeCard.isCurrent ? root.accentColor
                                 : themeCard.containsMouse ? Qt.lighter(root.secondaryColor, 1.2)
                                 : root.secondaryColor
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 12

                            PlasmaComponents.Label {
                                text: modelData.name
                                font.pixelSize: root.textFontSize
                                font.bold: themeCard.isCurrent
                                color: themeCard.isCurrent ? root.badgeTextColor : root.textColor
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Row {
                                spacing: 3

                                Rectangle { width: 5; height: 22; color: modelData.colors.primary; radius: 2 }
                                Rectangle { width: 5; height: 22; color: modelData.colors.secondary; radius: 2 }
                                Rectangle { width: 5; height: 22; color: modelData.colors.accent; radius: 2 }
                                Rectangle { width: 5; height: 22; color: modelData.colors.tertiary; radius: 2 }
                            }
                        }
                    }
                }
            }

            // ========== ROTATION DU FOND D'ÉCRAN ==========
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: root.tertiaryColor
            }

            RowLayout {
                Layout.fillWidth: true

                PlasmaComponents.Label {
                    text: "🖼️ Fond d'écran"
                    font.pixelSize: root.textFontSize
                    font.bold: true
                    color: root.primaryColor
                    Layout.fillWidth: true
                }

                PlasmaComponents.Label {
                    text: root.rotationEnabled && root.nextWallpaper
                          ? "prochain : " + root.nextWallpaper : ""
                    font.pixelSize: root.smallFontSize
                    color: root.secTextColor
                }
            }

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 12
                rowSpacing: 6

                PlasmaComponents.Label {
                    text: "Rotation"
                    font.pixelSize: root.textFontSize
                    color: root.textColor
                }

                RowLayout {
                    spacing: 8

                    PlasmaComponents.Switch {
                        id: rotationSwitch
                        checked: root.rotationEnabled
                        enabled: !root.applying
                        onToggled: {
                            root.runScript("--rotation " + (checked ? "on" : "off"))
                            // Revenir à l'état réel, relu après la commande
                            checked = Qt.binding(() => root.rotationEnabled)
                        }
                    }

                    PlasmaComponents.Label {
                        text: root.rotationEnabled ? "activée" : "désactivée"
                        font.pixelSize: root.textFontSize
                        color: root.secTextColor
                    }
                }

                PlasmaComponents.Label {
                    text: "Fréquence"
                    font.pixelSize: root.textFontSize
                    color: root.textColor
                    opacity: root.rotationEnabled ? 1 : 0.5
                }

                RowLayout {
                    spacing: 6
                    enabled: root.rotationEnabled && !root.applying
                    opacity: enabled ? 1 : 0.5

                    Repeater {
                        model: root.intervalPresets

                        MouseArea {
                            id: presetButton
                            readonly property bool isCurrent: modelData === root.rotationInterval

                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 26
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: if (!isCurrent) root.runScript("--interval " + modelData)

                            Rectangle {
                                anchors.fill: parent
                                radius: root.borderRadius
                                color: presetButton.isCurrent ? root.accentColor
                                     : presetButton.containsMouse ? Qt.lighter(root.secondaryColor, 1.2)
                                     : root.secondaryColor
                            }

                            PlasmaComponents.Label {
                                anchors.centerIn: parent
                                text: modelData
                                font.pixelSize: root.textFontSize
                                font.bold: presetButton.isCurrent
                                color: presetButton.isCurrent ? root.badgeTextColor : root.textColor
                            }
                        }
                    }

                    // Valeur personnalisée : envoyée après une courte pause, pas à chaque cran
                    QQC2.SpinBox {
                        id: intervalSpin
                        from: 1
                        to: 1440
                        editable: true
                        value: root.rotationInterval
                        font.pixelSize: root.textFontSize
                        textFromValue: (value) => value + " min"
                        valueFromText: (text) => parseInt(text) || root.rotationInterval
                        Layout.preferredWidth: 110

                        onValueModified: intervalTimer.restart()

                        Timer {
                            id: intervalTimer
                            interval: 800
                            onTriggered: {
                                if (intervalSpin.value !== root.rotationInterval)
                                    root.runScript("--interval " + intervalSpin.value)
                                intervalSpin.value = Qt.binding(() => root.rotationInterval)
                            }
                        }
                    }
                }
            }

            MouseArea {
                id: nextWallpaperButton
                Layout.alignment: Qt.AlignRight
                Layout.preferredWidth: nextWallpaperLabel.implicitWidth + 24
                Layout.preferredHeight: 28
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                enabled: !root.applying && root.currentTheme !== ""

                onClicked: root.runScript("--next-wallpaper")

                Rectangle {
                    anchors.fill: parent
                    radius: root.borderRadius
                    color: nextWallpaperButton.containsMouse ? Qt.lighter(root.accentColor, 1.15)
                                                             : root.accentColor
                    opacity: nextWallpaperButton.enabled ? 1 : 0.5
                }

                PlasmaComponents.Label {
                    id: nextWallpaperLabel
                    anchors.centerIn: parent
                    text: "⏭ Fond suivant"
                    font.pixelSize: root.textFontSize
                    color: root.badgeTextColor
                }
            }

            PlasmaComponents.Label {
                text: root.errorMessage
                visible: root.errorMessage !== ""
                font.pixelSize: root.smallFontSize
                color: root.textColor
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            Item { Layout.fillHeight: true }

            // ========== PIED DE PAGE ==========
            PlasmaComponents.Label {
                text: "Clic du milieu sur l'icône : thème suivant"
                font.pixelSize: root.smallFontSize
                color: root.secTextColor
                opacity: 0.7
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
