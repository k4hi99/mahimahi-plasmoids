// Disposition « Barres » : une barre horizontale par info (icône, libellé, valeur)
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

ColumnLayout {
    id: bars

    spacing: 8

    readonly property int iconSize: root.textFontSize + 4

    // Largeurs fixes pour que les barres soient alignées d'une ligne à l'autre
    TextMetrics {
        id: labelMetrics
        font.pixelSize: root.textFontSize
        text: "Batterie"
    }
    TextMetrics {
        id: valueMetrics
        font.pixelSize: root.textFontSize
        font.bold: true
        text: "88,8 Go"
    }

    BarRow {
        iconSource: Qt.resolvedUrl("../icons/mahistats-cpu.svg")
        label: "CPU"
        value: root.cpuUsage
        valueText: root.cpuText
    }
    BarRow {
        iconSource: Qt.resolvedUrl("../icons/mahistats-temp.svg")
        label: "Temp."
        value: root.cpuTemp
        valueText: root.tempText
        alert: root.tempAlert
    }
    BarRow {
        iconSource: Qt.resolvedUrl("../icons/mahistats-ram.svg")
        label: "RAM"
        value: root.ramPercent
        valueText: root.ramText
        detail: root.ramDetailText
        alert: root.ramAlert
    }
    BarRow {
        visible: root.hasBattery
        iconSource: root.batteryIcon
        label: "Batterie"
        value: root.batteryPercent
        valueText: root.batteryText
        detail: root.batteryStateText + (root.batteryTimeText ? " · " + root.batteryTimeText : "")
        alert: root.batteryAlert
    }

    // Une ligne : icône, libellé, barre (pilule sur 0-100), valeur ; détail en dessous
    component BarRow: ColumnLayout {
        id: barRow

        property alias iconSource: icon.source
        property string label: ""
        property real value: 0
        property string valueText: ""
        property string detail: ""
        property bool alert: false

        readonly property color fillColor: alert ? root.accentColor : root.primaryColor

        Layout.fillWidth: true
        spacing: 2

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Kirigami.Icon {
                id: icon
                isMask: true
                color: barRow.fillColor
                Layout.preferredWidth: bars.iconSize
                Layout.preferredHeight: bars.iconSize
            }

            PlasmaComponents.Label {
                id: labelItem
                text: barRow.label
                font.pixelSize: root.textFontSize
                color: root.textColor
                Layout.preferredWidth: labelMetrics.advanceWidth
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredWidth: 180
                Layout.preferredHeight: root.barHeight
                radius: height / 2
                color: root.tertiaryColor

                Rectangle {
                    width: parent.width * Math.max(0, Math.min(1, barRow.value / 100))
                    height: parent.height
                    radius: height / 2
                    color: barRow.fillColor
                }
            }

            PlasmaComponents.Label {
                text: barRow.valueText
                font.pixelSize: root.textFontSize
                font.bold: true
                color: barRow.alert ? root.accentColor : root.textColor
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: valueMetrics.advanceWidth
            }
        }

        // Détail aligné sous la barre
        PlasmaComponents.Label {
            visible: barRow.detail !== ""
            text: barRow.detail
            font.pixelSize: root.smallFontSize
            color: root.secTextColor
            Layout.leftMargin: bars.iconSize + labelMetrics.advanceWidth + 16
        }
    }
}
