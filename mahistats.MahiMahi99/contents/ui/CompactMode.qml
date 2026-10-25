// Vue compacte : une ligne CPU · température · RAM · batterie dans le panneau
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

MouseArea {
    id: compact

    Layout.minimumWidth: row.implicitWidth
    Layout.preferredWidth: row.implicitWidth
    Layout.minimumHeight: root.compactIconSize

    hoverEnabled: true
    onClicked: root.expanded = !root.expanded

    // Largeur fixe des valeurs pour que la ligne ne bouge pas quand un chiffre change
    TextMetrics {
        id: percentMetrics
        font.pixelSize: root.textFontSize
        text: "100 %"
    }
    TextMetrics {
        id: tempMetrics
        font.pixelSize: root.textFontSize
        text: "100 °C"
    }
    TextMetrics {
        id: ramMetrics
        font.pixelSize: root.textFontSize
        text: "88,8 Go"
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 10

        // CPU : charge + température
        Stat {
            iconSource: Qt.resolvedUrl("../icons/mahistats-cpu.svg")
            text: root.cpuText
            value: root.cpuUsage
            valueWidth: percentMetrics.advanceWidth
        }
        Stat {
            iconSource: Qt.resolvedUrl("../icons/mahistats-temp.svg")
            text: root.tempText
            value: root.cpuTemp
            valueWidth: tempMetrics.advanceWidth
            alert: root.tempAlert
        }

        Stat {
            iconSource: Qt.resolvedUrl("../icons/mahistats-ram.svg")
            text: root.ramText
            value: root.ramPercent
            valueWidth: root.ramShowPercent ? percentMetrics.advanceWidth : ramMetrics.advanceWidth
            alert: root.ramAlert
        }

        Stat {
            visible: root.hasBattery
            iconSource: root.batteryIcon
            text: root.batteryText
            value: root.batteryPercent
            valueWidth: percentMetrics.advanceWidth
            alert: root.batteryAlert
        }
    }

    // Icône + valeur (+ mini-barre sur 0-100 en style "Barres"), en accentColor si alerte
    component Stat: RowLayout {
        id: stat

        property alias iconSource: icon.source
        property alias text: label.text
        property real value: 0
        property real valueWidth: 0
        property bool alert: false

        spacing: 3

        Kirigami.Icon {
            id: icon
            isMask: true
            color: parent.alert ? root.accentColor : root.textColor
            Layout.preferredWidth: root.compactIconSize
            Layout.preferredHeight: root.compactIconSize
        }

        PlasmaComponents.Label {
            id: label
            font.pixelSize: root.textFontSize
            color: parent.alert ? root.accentColor : root.textColor
            horizontalAlignment: Text.AlignRight
            Layout.minimumWidth: parent.valueWidth
        }

        Rectangle {
            visible: root.compactStyle === "bars"
            Layout.leftMargin: 2
            Layout.preferredWidth: root.compactBarWidth
            Layout.preferredHeight: 4
            radius: height / 2
            color: root.tertiaryColor

            Rectangle {
                width: parent.width * Math.max(0, Math.min(1, stat.value / 100))
                height: parent.height
                radius: height / 2
                color: stat.alert ? root.accentColor : root.primaryColor
            }
        }
    }
}
