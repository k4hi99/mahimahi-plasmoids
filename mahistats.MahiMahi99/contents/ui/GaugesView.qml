// Disposition « Jauges » : une jauge circulaire par info, regroupées au centre
import QtQuick
import QtQuick.Layouts

Item {
    id: gaugesView

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    // Colonnes de même largeur (la plus large, détail compris) : écart régulier entre les cercles
    readonly property real cellWidth: Math.max(cpuGauge.implicitWidth, tempGauge.implicitWidth,
                                               ramGauge.implicitWidth, batteryGauge.implicitWidth)

    RowLayout {
        id: row
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 16

        Gauge {
            id: cpuGauge
            Layout.preferredWidth: gaugesView.cellWidth
            label: "CPU"
            value: root.cpuUsage
            valueText: root.cpuText
        }
        Gauge {
            id: tempGauge
            Layout.preferredWidth: gaugesView.cellWidth
            label: "Temp."
            value: root.cpuTemp
            valueText: root.tempText
            alert: root.tempAlert
        }
        Gauge {
            id: ramGauge
            Layout.preferredWidth: gaugesView.cellWidth
            label: "RAM"
            value: root.ramPercent
            valueText: root.ramText
            detail: root.ramDetailText
            alert: root.ramAlert
        }
        Gauge {
            id: batteryGauge
            Layout.preferredWidth: gaugesView.cellWidth
            visible: root.hasBattery
            label: "Batterie"
            value: root.batteryPercent
            valueText: root.batteryText
            detail: root.batteryStateText + (root.batteryTimeText ? "\n" + root.batteryTimeText : "")
            alert: root.batteryAlert
        }
    }
}
