// MahiStats : monitoring CPU, température, RAM et batterie (capteurs natifs de Plasma)
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as P5Support
import org.kde.ksysguard.sensors as Sensors
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

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

    // Tailles MahiTheme (onglet "Tailles", voir CLAUDE.md)
    property int titleFontSize: plasmoid.configuration.titleFontSize
    property int textFontSize: plasmoid.configuration.textFontSize
    property int smallFontSize: plasmoid.configuration.smallFontSize
    property int compactIconSize: plasmoid.configuration.compactIconSize
    property int borderRadius: plasmoid.configuration.borderRadius
    property int widgetBorderWidth: plasmoid.configuration.widgetBorderWidth
    property int gaugeSize: plasmoid.configuration.gaugeSize
    property int graphHeight: plasmoid.configuration.graphHeight
    property int barHeight: plasmoid.configuration.barHeight
    property int compactBarWidth: plasmoid.configuration.compactBarWidth

    // Réglages (onglet "General")
    property string fullLayout: plasmoid.configuration.fullLayout
    property bool showHistory: plasmoid.configuration.showHistory
    property string compactStyle: plasmoid.configuration.compactStyle
    property bool ramShowPercent: plasmoid.configuration.ramShowPercent
    property int tempThreshold: plasmoid.configuration.tempThreshold
    property int ramThreshold: plasmoid.configuration.ramThreshold
    property int batteryLowThreshold: plasmoid.configuration.batteryLowThreshold

    // ========== CAPTEURS ==========
    // Capteurs natifs de Plasma (ksystemstats)
    readonly property int sampleInterval: 2000

    Sensors.Sensor {
        id: cpuSensor
        sensorId: "cpu/all/usage"
        updateRateLimit: root.sampleInterval
    }
    Sensors.Sensor {
        id: tempSensor
        sensorId: "cpu/all/maximumTemperature"
        updateRateLimit: root.sampleInterval
    }
    Sensors.Sensor {
        id: ramUsedSensor
        sensorId: "memory/physical/used"
        updateRateLimit: root.sampleInterval
    }
    Sensors.Sensor {
        id: ramPercentSensor
        sensorId: "memory/physical/usedPercent"
        updateRateLimit: root.sampleInterval
    }
    Sensors.Sensor {
        id: ramTotalSensor
        sensorId: "memory/physical/total"
    }

    property real cpuUsage: Number(cpuSensor.value) || 0
    property real cpuTemp: Number(tempSensor.value) || 0
    property real ramUsedGo: (Number(ramUsedSensor.value) || 0) / 1073741824
    property real ramTotalGo: (Number(ramTotalSensor.value) || 0) / 1073741824
    property real ramPercent: Number(ramPercentSensor.value) || 0

    // ========== HISTORIQUE ==========
    // 5 min, un point toutes les 2 s
    readonly property int historySize: 300000 / sampleInterval
    property var cpuHistory: []
    property var tempHistory: []
    property var ramHistory: []

    signal historyUpdated()

    function pushSample(list, value) {
        list.push(value)
        if (list.length > historySize)
            list.shift()
    }

    Timer {
        id: sampleTimer
        interval: root.sampleInterval
        running: true
        repeat: true
        onTriggered: {
            // Pas de point tant que ksystemstats n'a pas répondu
            if (root.ramUsedGo <= 0)
                return
            root.pushSample(root.cpuHistory, root.cpuUsage)
            root.pushSample(root.tempHistory, root.cpuTemp)
            root.pushSample(root.ramHistory, root.ramPercent)
            root.historyUpdated()
        }
    }

    // ========== BATTERIE ==========
    // Moteur powermanagement de Plasma
    P5Support.DataSource {
        id: pmSource
        engine: "powermanagement"
        connectedSources: ["Battery", "AC Adapter"]
    }

    property var batteryData: pmSource.data["Battery"] || ({})
    property bool hasBattery: batteryData["Has Battery"] === true
    property int batteryPercent: batteryData["Percent"] || 0
    property string batteryState: batteryData["State"] || ""
    property bool pluggedIn: (pmSource.data["AC Adapter"] || {})["Plugged in"] === true
    property bool batteryCharging: batteryState === "Charging" || (pluggedIn && batteryState !== "Discharging")
    property real batteryRemainingMsec: batteryData["Remaining msec"] || 0

    // Icône Breeze par paliers de 10 %, variante "charging" sur secteur
    property string batteryIcon: {
        if (!hasBattery)
            return "battery-missing-symbolic"
        const level = Math.min(100, Math.floor(batteryPercent / 10) * 10)
        return "battery-" + String(level).padStart(3, "0")
            + (batteryCharging ? "-charging" : "") + "-symbolic"
    }

    // ========== ALERTES ==========
    // Valeur en accentColor au-delà du seuil
    property bool tempAlert: cpuTemp >= tempThreshold
    property bool ramAlert: ramPercent >= ramThreshold
    property bool batteryAlert: hasBattery && !batteryCharging && batteryPercent <= batteryLowThreshold

    // ========== FORMATAGE ==========
    function formatNumber(value, decimals) {
        // Virgule décimale française, quelle que soit la locale système
        return Number(value).toLocaleString(Qt.locale("fr_FR"), "f", decimals)
    }

    property string cpuText: Math.round(cpuUsage) + " %"
    property string tempText: Math.round(cpuTemp) + " °C"
    property string ramText: ramShowPercent ? Math.round(ramPercent) + " %"
                                            : formatNumber(ramUsedGo, 1) + " Go"
    property string ramDetailText: formatNumber(ramUsedGo, 1) + " / " + formatNumber(ramTotalGo, 1) + " Go"
    property string batteryText: hasBattery ? batteryPercent + " %" : "—"

    // "1 h 05" ou "43 min"
    function formatDuration(msec) {
        const minutes = Math.round(msec / 60000)
        if (minutes < 60)
            return minutes + " min"
        return Math.floor(minutes / 60) + " h " + String(minutes % 60).padStart(2, "0")
    }

    property string batteryStateText: {
        switch (batteryState) {
        case "Charging": return "En charge"
        case "Discharging": return "Sur batterie"
        case "FullyCharged": return "Chargée"
        case "NoCharge": return "Branchée, en pause"
        default: return pluggedIn ? "Branchée" : ""
        }
    }

    // Temps jusqu'à la charge complète (en charge) ou temps restant (sur batterie)
    property string batteryTimeText: {
        if (batteryState !== "Charging" && batteryState !== "Discharging")
            return ""
        if (batteryRemainingMsec <= 0)
            return "Estimation…"
        return batteryState === "Charging"
            ? "Pleine dans " + formatDuration(batteryRemainingMsec)
            : formatDuration(batteryRemainingMsec) + " restantes"
    }

    // ========== REPRÉSENTATIONS ==========
    // Sur le bureau : vue complète directement ; dans un panneau : ligne compacte + popup
    preferredRepresentation: Plasmoid.formFactor === PlasmaCore.Types.Planar
                             ? fullRepresentation : compactRepresentation

    toolTipMainText: "MahiStats"
    toolTipSubText: "CPU " + cpuText + " · " + tempText
                    + "\nRAM " + formatNumber(ramUsedGo, 1) + " / " + formatNumber(ramTotalGo, 1) + " Go"
                    + (hasBattery ? "\nBatterie " + batteryText
                                    + (batteryTimeText ? " · " + batteryTimeText : "") : "")

    compactRepresentation: CompactMode {}
    fullRepresentation: FullMode {}
}
